//
//  BBMusicTypeListController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicTypeListController.h"
#import "BBMusicRequest.h"
#import "BBMusicViewController.h"
#import "ZXScanMusicQR.h"
#import "BBMusicTypeCell.h"
#import "BBMusicActivation.h"

@interface BBMusicTypeListController ()
@property (nonatomic, retain) ASIFormDataRequest    *musicListRequest;
@property (nonatomic, retain) NSMutableArray        *musicListArray;
@property (nonatomic, retain) UITableView           *musicListTable;
@property (nonatomic, retain) MBProgressHUD         *progressHUD;
@end

@implementation BBMusicTypeListController

- (void)dealloc {
    [_musicListRequest clearDelegatesAndCancel];
    [_musicListRequest release];
    [_musicListTable release];
    [_musicListArray release];
    [_progressHUD release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    
    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    self.musicListArray = nil;
    [self.musicListRequest clearDelegatesAndCancel];
    self.musicListRequest = nil;
    self.musicListTable = nil;
    self.progressHUD = nil;
}


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
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    [self addMusicListTable];
    [self addTitleLabel];
    [self addBackButton];
    [self addProgressHUD];
    [self requestVideoList];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 扫描二维码成功后，更新列表显示激活状态
    if([self.musicListArray count] > 0)
    {
      [self.musicListTable reloadData];
    }
}

- (void)addTitleLabel {
    UILabel *titleLabel = [BBNavigationLabel customNavigationLabel:@"亲子音乐"];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)addBackButton {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
}

- (void)addMusicListTable {
    self.musicListTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, DEVICE_HEIGHT - 20 - 44) style:UITableViewStylePlain] autorelease];
    self.musicListTable.backgroundColor = [UIColor clearColor];
    self.musicListTable.delegate = self;
    self.musicListTable.dataSource = self;
    self.musicListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *header = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
    [header setBackgroundColor:[UIColor clearColor]];
    self.musicListTable.tableHeaderView = header;
    [self setExtraCellLineHidden:self.musicListTable];
    [self.view addSubview:self.musicListTable];
}

- (void)addProgressHUD {
    self.progressHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.progressHUD];

}

- (void)requestVideoList {
    [self.progressHUD setLabelText:@"加载中..."];
    [self.progressHUD show:YES];
    [self.musicListRequest clearDelegatesAndCancel];
    self.musicListRequest = [BBMusicRequest getMusicList];
    [self.musicListRequest setDidFinishSelector:@selector(getMusicFinish:)];
    [self.musicListRequest setDidFailSelector:@selector(getMusicFail:)];
    [self.musicListRequest setDelegate:self];
    [self.musicListRequest startAsynchronous];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

- (void)leftButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.musicListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    BBMusicTypeCell *cell = (BBMusicTypeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[BBMusicTypeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.musicListArray objectAtIndex:indexPath.row];
    cell.musicTypeInfo = dic;
    [cell resetCell];
    return cell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [MobClick event:@"music_v2" label:@"胎教音乐（孕4-5月）"];
    }
    else if(indexPath.row == 1)
    {
        [MobClick event:@"music_v2" label:@"胎教音乐（孕5-6月）"];
    }
    else if(indexPath.row == 2)
    {
        [MobClick event:@"music_v2" label:@"胎教音乐（孕6-7月）"];
    }
    else if(indexPath.row == 3)
    {
        [MobClick event:@"music_v2" label:@"胎教音乐（孕7-8月）"];
    }
    else if(indexPath.row == 4)
    {
        [MobClick event:@"music_v2" label:@"胎教音乐（孕8-9月）"];
    }
    else if(indexPath.row == 5)
    {
        [MobClick event:@"music_v2" label:@"胎教音乐（孕9-10月）"];
    }
    else if(indexPath.row == 6)
    {
        [MobClick event:@"music_v2" label:@"胎教音乐（其他）"];
    }
    NSDictionary *dic = [self.musicListArray objectAtIndex:indexPath.row];
    
    if ([[dic stringForKey:@"need_check"] intValue] == 1) {
        if ([[dic stringForKey:@"valid"] intValue] == 1) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([[defaults objectForKey:[[dic stringForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] isEqualToString:@"YES"]) {
                
                BBMusicViewController *musicController = [[[BBMusicViewController alloc] init] autorelease];
                musicController.musicTypeInfo = dic;
                [self.navigationController pushViewController:musicController animated:YES];
            }else {
                BBMusicActivation *activation = [[[BBMusicActivation alloc] initWithNibName:@"BBMusicActivation" bundle:nil] autorelease];
                activation.m_ScanDic = dic;
                [self.navigationController pushViewController:activation animated:YES];
            }
        }else {
            [AlertUtil showAlert:nil withMessage:@"更多精彩，请继续关注..."];
        }
    }else {
        BBMusicViewController *musicController = [[[BBMusicViewController alloc] init] autorelease];
        musicController.musicTypeInfo = dic;
        [self.navigationController pushViewController:musicController animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - ASIHttpRequest delegate
- (void)getMusicFinish:(ASIFormDataRequest *)request {
    [self.progressHUD hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *submitReplyData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        
        return;
    }
    if ([[submitReplyData stringForKey:@"status"] isEqualToString:@"success"]) {
        self.musicListArray = (NSMutableArray *)[[submitReplyData dictionaryForKey:@"data"] arrayForKey:@"list"];
        
    }
    [self.musicListTable reloadData];
}

- (void)getMusicFail:(ASIFormDataRequest *)request {
    [self.progressHUD hide:YES];
    [AlertUtil showAlert:@"" withMessage:@"亲，您的网络不给力啊"];
}


@end
