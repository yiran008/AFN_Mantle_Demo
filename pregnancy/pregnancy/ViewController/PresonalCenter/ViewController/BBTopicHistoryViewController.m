//
//  BBTopicHistoryViewController.m
//  pregnancy
//
//  Created by MacBook on 14-9-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBTopicHistoryViewController.h"
#import "HMTopicListCell.h"
#import "BBTopicHistoryDB.h"
#import "HMShowPage.h"

@interface BBTopicHistoryViewController ()

@property (nonatomic, retain) UITableView *historyTableView;
@property (nonatomic, retain) NSArray *m_topicHistoryArray;
// 无数据提示
@property (nonatomic, retain) HMNoDataView *m_NoDataView;
// 清空button
@property (nonatomic, retain) UIButton *cleanButton;
@end

@implementation BBTopicHistoryViewController

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
    
    self.navigationItem.title = @"最近浏览的帖子";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];

    self.m_topicHistoryArray = [[NSArray alloc] initWithArray:[BBTopicHistoryDB topicHistoryModelArray]];
   
    self.historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 44) style:UITableViewStylePlain];
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyTableView.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:self.historyTableView];
    [self.view addSubview:self.historyTableView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    self.cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cleanButton.exclusiveTouch = YES;
    [self.cleanButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.cleanButton setTitle:@"清空" forState:UIControlStateNormal];
    [self.cleanButton addTarget:self action:@selector(cleanAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clearBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.cleanButton];
    [self.navigationItem setRightBarButtonItem:clearBarButton];
    if([self.m_topicHistoryArray count] == 0)
    {
        self.cleanButton.userInteractionEnabled = NO;
        self.cleanButton.titleLabel.textColor = [UIColor colorWithHex:0xcccccc];
    }
    
    // 无数据提示
    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.historyTableView addSubview:self.m_NoDataView];
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.delegate = self;
    self.m_NoDataView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 看过帖子后 刷新列表
    self.m_topicHistoryArray = [BBTopicHistoryDB topicHistoryModelArray];
    [self.historyTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

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

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cleanAction:(UIButton *)button
{
    UIActionSheet *clearSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清空浏览记录", nil];
    [clearSheet showInView:self.view];
}

- (CGFloat)topicTitleHeight:(NSString *)title
{
    CGFloat height = 0.0;
    CGSize size;
    if (IOS_VERSION < 7.0)
    {
        size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f]];
    }
    else
    {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f]};
        size = [title sizeWithAttributes:attributes];
    }
    if (size.width >= 300)
    {
        height += 42;
    }
    else
    {
        height += 24;
    }
    return height;
}

#pragma mark - UITableView & UITableData Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.m_topicHistoryArray count] == 0)
    {
        [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:[NSString stringWithFormat:@"这里还什么都木有..."]];
    }

    return [self.m_topicHistoryArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.m_topicHistoryArray count])
    {
        BBTopicHistoryModel *class = [self.m_topicHistoryArray objectAtIndex:indexPath.row];
    
        return [self topicTitleHeight:class.m_TopicTitle] + 52;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"HMTopicListCell";
    HMTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicListCell" owner:self options:nil] lastObject];
        [cell makeCellStyle];
    }
  
    // 隐藏不需要cell内容
    cell.m_MarkIconTopView.hidden = YES;
    cell.m_MarkIconNewView.hidden = YES;
    cell.m_MarkIconEtView.hidden = YES;
    cell.m_MarkIconHelpView.hidden = YES;
    cell.m_MarkIconPicView.hidden = YES;
    cell.m_ReplyIconView.hidden = YES;
    cell.m_ReplyCountLabel.hidden = YES;
    
    if(indexPath.row < [self.m_topicHistoryArray count])
    {
        BBTopicHistoryModel *class = [self.m_topicHistoryArray objectAtIndex:indexPath.row];
        
        cell.m_TitleLabel.height = [self topicTitleHeight:class.m_TopicTitle];
        cell.m_BottomBoxView.top = cell.m_TitleLabel.height + 10;
        cell.m_ContentView.height = cell.m_BottomBoxView.bottom;
        cell.m_BottomLine.top = cell.m_BottomBoxView.bottom + 8;
        
        cell.m_MasterNameLabel.text = class.m_PosterName;
        cell.m_TitleLabel.text = class.m_TopicTitle;
        cell.m_TimeLabel.text = [NSDate hmStringDateFromTs:[class.m_AddTime doubleValue]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.historyTableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row < [self.m_topicHistoryArray count])
    {
        BBTopicHistoryModel *class = [self.m_topicHistoryArray objectAtIndex:indexPath.row];
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_RECENTLY contentId:class.m_TopicID];
        [HMShowPage showTopicDetail:self topicId:class.m_TopicID topicTitle:class.m_TopicTitle];
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [BBTopicHistoryDB clearTopicHistory];
        self.m_topicHistoryArray = [BBTopicHistoryDB topicHistoryModelArray];
        [self.historyTableView reloadData];
        
        self.cleanButton.userInteractionEnabled = NO;
        self.cleanButton.titleLabel.textColor = [UIColor colorWithHex:0xcccccc];
    }
}

@end
