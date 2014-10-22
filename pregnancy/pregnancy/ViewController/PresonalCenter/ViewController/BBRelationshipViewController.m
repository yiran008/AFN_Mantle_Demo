//
//  BBRelationshipViewController.m
//  pregnancy
//
//  Created by MacBook on 14-8-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRelationshipViewController.h"
#import "BBSearchUserCell.h"
#import "BBSearchUserCellClass.h"
#import "BBAttentionRequest.h"
#import "BBPersonalViewController.h"

@interface BBRelationshipViewController ()

@end

@implementation BBRelationshipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *title;
    if(self.relationType == RelationType_Attention)
    {
        title = @"关注";
    }
    else if(self.relationType == RelationType_Fans)
    {
        title = @"粉丝";
    }
    [self setNavTitle:title];
   
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self freshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showNoDataNoticeWithType:(HMNODATAVIEW_TYPE)type withTitle:(NSString *)title
{
    self.m_NoDataView.m_Type = type;
    self.m_NoDataView.m_PromptText = title;
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.hidden = NO;
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)freshData
{
    s_LoadedPage = 1;
    [self loadNextData];
    
    [self.m_ProgressHUD setLabelText:@"加载中..."];
    [self.m_ProgressHUD show:YES];
}

- (void)loadNextData
{
    _refresh_bottom_view.refreshStatus = NO;
    if (self.m_DataRequest!=nil)
    {
        [self.m_DataRequest clearDelegatesAndCancel];
    }
    
    [self.m_DataRequest setDelegate:nil];
    
    if(self.relationType == RelationType_Attention)
    {
        self.m_DataRequest = [BBAttentionRequest getFollowingList:self.u_id page:s_LoadedPage limit:20];
        [self.m_DataRequest setDidFinishSelector:@selector(getFollowListFinished:)];
        [self.m_DataRequest setDidFailSelector:@selector(getFollowListFail:)];
        [self.m_DataRequest setDelegate:self];
        [self.m_DataRequest startAsynchronous];
    }
    else if(self.relationType == RelationType_Fans)
    {
        self.m_DataRequest = [BBAttentionRequest getFollowedList:self.u_id page:s_LoadedPage limit:20];
        [self.m_DataRequest setDidFinishSelector:@selector(getFollowListFinished:)];
        [self.m_DataRequest setDidFailSelector:@selector(getFollowListFail:)];
        [self.m_DataRequest setDelegate:self];
        [self.m_DataRequest startAsynchronous];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"BBSearchUserCell";
    BBSearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSearchUserCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    //数据模型
    if(indexPath.row < [self.m_Data count])
    {
        BBSearchUserCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
        [cell setSearchUserCell:item];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_Data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.m_Data count])
    {
        BBSearchUserCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
        return item.cellHeight;
    }
    else
    {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= [self.m_Data count])
    {
        return;
    }
    BBPersonalViewController *userInformation = [[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil];
    BBSearchUserCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
    userInformation.userEncodeId = item.user_encodeID;
    userInformation.userName = item.user_name;
    [self.navigationController pushViewController:userInformation animated:YES];
}


#pragma mark - FollowList Result
- (void)getFollowListFinished:(ASIFormDataRequest *)request
{
    [self hideEGORefreshView];
    [self.m_ProgressHUD hide:YES];
    [self.m_NoDataView setHidden:YES];

    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
    if (![dictData isDictionaryAndNotEmpty])
    {
        [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:@"数据错误"];
        return ;
    }
    
    NSDictionary *dictList = [dictData dictionaryForKey:@"data"];
    if ([[dictData stringForKey:@"status"] isEqualToString:@"success"])
    {
        s_LoadedTotalCount = [dictList intForKey:@"total"];
        
        if ([[dictList arrayForKey:@"user_list"] count] == 0 && self.m_Data.count == 0)
        {
            [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:[NSString stringWithFormat:@"这里还什么都木有..."]];
        }
        else
        {
            if (s_LoadedPage == 1)
            {
                [self.m_Data removeAllObjects];
            }
            s_LoadedPage++;
            
            NSArray *userArray = [dictList arrayForKey:@"user_list"];
            if ([userArray isNotEmpty])
            {
                for (NSInteger i = 0; i<userArray.count; i++)
                {
                    NSDictionary *userDic = [userArray objectAtIndex:i];
                    BBSearchUserCellClass *userCellClass = [BBSearchUserCellClass getSearchUserClass:userDic];
                    
                    [self.m_Data addObject:userCellClass];
                }
            }
            else
            {
                _refresh_bottom_view.refreshStatus = YES;
            }
            
            [self.m_Table reloadData];
        }
    }
}

- (void)getFollowListFail:(ASIFormDataRequest *)request
{
    if (self.m_Data.count == 0)
    {
        self.m_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
        self.m_NoDataView.hidden = NO;
    }
    else
    {
        [PXAlertView showAlertWithTitle:@"亲，网络不给力！"];
    }
    
    [self hideEGORefreshView];
    [self.m_ProgressHUD hide:YES];
}

@end
