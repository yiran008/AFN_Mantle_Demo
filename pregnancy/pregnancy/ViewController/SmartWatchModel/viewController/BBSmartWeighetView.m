//
//  BBSmartWeighetView.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartWeighetView.h"
#import "BBSupportTopicDetail.h"
@interface BBSmartWeighetView ()
@property(nonatomic, strong) NSDate *date;
@end

@implementation BBSmartWeighetView

- (void)dealloc
{
    [_chartRequest clearDelegatesAndCancel];
    [_chartRequest release];
    [_monthLabel release];
    [_statusLabel release];
    [_chartImage release];
    [_chartView release];

    [_tableData release];
    [_sheetView release];
    [_loadProgress release];
    [_date release];
    [_monthString release];
    [_tableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.date = [NSDate date];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyyMM"];
        self.monthString = [formatter stringFromDate:self.date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"体重记录"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.exclusiveTouch = YES;
    [rightItemButton setFrame:CGRectMake(0, 0, 72, 34)];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightItemButton setTitle:@"专家建议" forState:UIControlStateNormal];
    [rightItemButton setBackgroundColor:[UIColor clearColor]];
    [rightItemButton addTarget:self action:@selector(expertAdvice:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
    
    IPHONE5_ADAPTATION
    if (IS_IPHONE5)
    {
        [self.sheetView setFrame:CGRectMake(self.sheetView.frame.origin.x, self.sheetView.frame.origin.y, self.sheetView.frame.size.width, self.sheetView.frame.size.height + 88)];
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 88)];
    }
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM"];
    self.monthLabel.text = [formatter stringFromDate:self.date];
    [self loadChartRequest];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)expertAdvice:(id)sender
{
#if USE_SMARTWATCH_MODEL
    [MobClick event:@"watch_v2" label:@"专家建议-体重记录"];
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:[NSString stringWithFormat:@"%@/mobile/app/watch/advice.php?type=weight",BABYTREE_URL_SERVER]];
    [exteriorURL setTitle:@"专家建议"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
    [exteriorURL release];
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)previousClicked:(id)sender
{
    self.date = [BBTimeUtility getBeforeMonthDate:self.date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMM"];
    self.monthString = [formatter stringFromDate:self.date];
    [formatter setDateFormat:@"yyyy-MM"];
    self.monthLabel.text = [formatter stringFromDate:self.date];
    [self loadChartRequest];
}

-(IBAction)nextClicked:(id)sender
{
    self.date = [BBTimeUtility getLastMonthDate:self.date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMM"];
    self.monthString = [formatter stringFromDate:self.date];
    [formatter setDateFormat:@"yyyy-MM"];
    self.monthLabel.text = [formatter stringFromDate:self.date];
    [self loadChartRequest];
}

-(void)loadChartRequest
{
    [self.loadProgress show:YES];
    [self.chartRequest clearDelegatesAndCancel];
    self.chartRequest = [BBSmartRequest smartWatchWeight:self.monthString];
    [self.chartRequest setDidFinishSelector:@selector(loadChartDataFinish:)];
    [self.chartRequest setDidFailSelector:@selector(loadChartDataFail:)];
    [self.chartRequest setDelegate:self];
    [self.chartRequest startAsynchronous];
    
}


- (void)loadChartDataFinish:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
        if (![jsonData isNotEmpty])
        {
            return;
        }
        //返回数据成功
        NSDictionary *listDic = [jsonData dictionaryForKey:@"data"];
        NSDictionary *weightDic = [listDic dictionaryForKey:@"weight"];
        NSString *oriWeight = [weightDic stringForKey:@"origin_weight"];
        NSString *curWeight = [weightDic stringForKey:@"curr_weight"];
        NSString *gaoWeight = [weightDic stringForKey:@"gap_weight"];
        if (oriWeight == nil) {
            oriWeight = @" ";
        }
        if (curWeight == nil) {
            curWeight = @" ";
        }
        if (gaoWeight == nil) {
            gaoWeight = @" ";
        }
        self.statusLabel.text = [NSString stringWithFormat:@"孕前： %@千克   当前：%@千克   %@",oriWeight,curWeight, gaoWeight];
        
        self.tableData = [listDic arrayForKey:@"list"];
        
        [self.tableView reloadData];
        
        NSDictionary *resultData = [jsonData dictionaryForKey:@"data"];
        NSString *chartData = [resultData stringForKey:@"img"];
        NSData *imageData = [GTMBase64 decodeString:chartData];
        
        UIImage *codeImage = [UIImage imageWithData:imageData];
        if (codeImage) {
            [self.chartImage setImage:codeImage];
        }else{
            [self.chartImage setImage:[UIImage imageNamed:@"chart_default"]];
        }
    }
}

- (void)loadChartDataFail:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark - UITableView methods
/**
 1、返回 UITableView 的区段数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 2、返回 UITableView 的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. cell标示符，使cell能够重用
    static NSString *smartCell = @"smartWeightCell";
    // 2. 从TableView中获取标示符为smartWeightCell的Cell
    BBSmartWeightCell *cell = (BBSmartWeightCell *)[tableView dequeueReusableCellWithIdentifier:smartCell];
    // 如果 cell = nil , 则表示 tableView 中没有可用的闲置cell
    if(cell == nil){
      cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSmartWeightCell" owner:self options:nil] objectAtIndex:0];
        
    }
    // 5. 设置单元格属性
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.tableData count] > indexPath.row) {
        [cell setupCell:[self.tableData objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
