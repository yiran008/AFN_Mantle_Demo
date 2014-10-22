//
//  BBSmartFetalmoveView.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartFetalmoveView.h"
#import "BBSupportTopicDetail.h"
@interface BBSmartFetalmoveView ()

@property (nonatomic, strong) NSArray *tableDetailData;
@property (assign) BOOL isMonth;
@property(nonatomic, strong) NSDate *date;

@end

@implementation BBSmartFetalmoveView

- (void)dealloc
{
    [_chartRequest clearDelegatesAndCancel];
    [_chartRequest release];
    [_chartImage release];
    [_chartView release];
    
    [_tableData release];
    [_sheetView release];
    [_loadProgress release];
    [_tableView release];
    
    [_sheetTitle release];
    [_detailTableView release];
    [_sheetDetailView release];
    [_date release];
    [_tableDetailData release];
    [_changeString release];
    [_changeLabel release];
    [_chengeButton release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isMonth = NO;
        
        self.date = [NSDate date];
        NSCalendar *greCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
        NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self.date];
        self.changeString = [NSString stringWithFormat:@"%i",dateComponents.week];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"胎动计数"];
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
    [rightItemButton addTarget:self action:@selector(expertAdvice:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
    if (!self.isMonth) {
        NSCalendar *greCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
        NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self.date];
        self.changeString = [NSString stringWithFormat:@"%i",dateComponents.week];
        self.changeLabel.text = [BBTimeUtility getWeekDateString:self.date];
        [self.chengeButton setTitle:@"月视图" forState:UIControlStateNormal];
    }else{
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyyMM"];
        self.changeString = [formatter stringFromDate:self.date];
        [formatter setDateFormat:@"yyyy-MM"];
        self.changeLabel.text = [formatter stringFromDate:self.date];
        [self.chengeButton setTitle:@"周视图" forState:UIControlStateNormal];
    }
    self.chengeButton.exclusiveTouch = YES;
    
    IPHONE5_ADAPTATION
    if (IS_IPHONE5)
    {
        [self.sheetView setFrame:CGRectMake(self.sheetView.frame.origin.x, self.sheetView.frame.origin.y, self.sheetView.frame.size.width, self.sheetView.frame.size.height+88)];
        [self.sheetDetailView setFrame:CGRectMake(self.sheetDetailView.frame.origin.x, self.sheetDetailView.frame.origin.y, self.sheetDetailView.frame.size.width, self.sheetDetailView.frame.size.height+88)];
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height+88)];
        [self.detailTableView setFrame:CGRectMake(self.detailTableView.frame.origin.x, self.detailTableView.frame.origin.y, self.detailTableView.frame.size.width, self.detailTableView.frame.size.height+88)];
    }
    [self loadChartRequest];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sheetDetailView setHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sheetDetailView setHidden:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)expertAdvice:(id)sender
{
#if USE_SMARTWATCH_MODEL
    [MobClick event:@"watch_v2" label:@"专家建议-胎动计数"];
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:[NSString stringWithFormat:@"%@/mobile/app/watch/advice.php?type=fetal",BABYTREE_URL_SERVER]];
    [exteriorURL setTitle:@"专家建议"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
    [exteriorURL release];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)previousClicked:(id)sender
{
    if (self.isMonth) {
        self.date = [BBTimeUtility getBeforeMonthDate:self.date];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyyMM"];
        self.changeString = [formatter stringFromDate:self.date];
        [formatter setDateFormat:@"yyyy-MM"];
        self.changeLabel.text = [formatter stringFromDate:self.date];
    }else{
        self.date = [BBTimeUtility getBeforeWeekDate:self.date];
        NSCalendar *greCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
        NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self.date];
        self.changeString = [NSString stringWithFormat:@"%i",dateComponents.week];
        self.changeLabel.text = [BBTimeUtility getWeekDateString:self.date];
    }
    [self cancelCheckDetail];
    [self loadChartRequest];
}

-(IBAction)nextClicked:(id)sender
{
    if (self.isMonth) {
        self.date = [BBTimeUtility getLastMonthDate:self.date];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyyMM"];
        self.changeString = [formatter stringFromDate:self.date];
        [formatter setDateFormat:@"yyyy-MM"];
        self.changeLabel.text = [formatter stringFromDate:self.date];
    }else{
        self.date = [BBTimeUtility getLastWeekDate:self.date];
        NSCalendar *greCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
        NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self.date];
        self.changeString = [NSString stringWithFormat:@"%i",dateComponents.week];
        self.changeLabel.text = [BBTimeUtility getWeekDateString:self.date];
    }
    [self cancelCheckDetail];
    [self loadChartRequest];
}

-(IBAction)changeMonthChart:(id)sender
{
    self.date = [NSDate date];
    if (self.isMonth) {
        self.isMonth = NO;
        NSCalendar *greCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
        NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self.date];
        self.changeString = [NSString stringWithFormat:@"%i",dateComponents.week];
        self.changeLabel.text = [BBTimeUtility getWeekDateString:self.date];
        [self.chengeButton setTitle:@"月视图" forState:UIControlStateNormal];
    }else{
        [MobClick event:@"watch_v2" label:@"月线图-胎动"];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyyMM"];
        self.changeString = [formatter stringFromDate:self.date];
        self.isMonth = YES;
        [formatter setDateFormat:@"yyyy-MM"];
        self.changeLabel.text = [formatter stringFromDate:self.date];
        [self.chengeButton setTitle:@"周视图" forState:UIControlStateNormal];
    }
    [self cancelCheckDetail];
    [self loadChartRequest];
}


-(void)loadChartRequest
{
    [self.loadProgress show:YES];
    [self.chartRequest clearDelegatesAndCancel];
    self.chartRequest = [BBSmartRequest smartWatchFetalMove:self.changeString withValueType:self.isMonth];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 111) {
        return [self.tableData count];
    }else{
        return [self.tableDetailData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 111) {
        static NSString *smartCell = @"smartFetalMoveCell";
        BBSmartFetalMoveCell *cell = (BBSmartFetalMoveCell *)[tableView dequeueReusableCellWithIdentifier:smartCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSmartFetalMoveCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.tableData count] > indexPath.row) {
            [cell setupCell:[self.tableData objectAtIndex:indexPath.row]]; 
        }
        return cell;
    }else{
        static NSString *detailCell = @"fetalMoveDetailCell";
        BBFetalMoveDetailCell *concell = (BBFetalMoveDetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCell];
        if(concell == nil){
             concell = [[[NSBundle mainBundle] loadNibNamed:@"BBFetalMoveDetailCell" owner:self options:nil] objectAtIndex:0];
        }
        if ([self.tableDetailData count] > indexPath.row) {
            [concell setupCell:[self.tableDetailData objectAtIndex:indexPath.row]];
        }
        return concell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 111) {
        [MobClick event:@"watch_v2" label:@"记录详细-胎动"];
        [self openCheckDetail];
        if ([self.tableData count] > indexPath.row) {
            self.sheetTitle.text = [[self.tableData objectAtIndex:indexPath.row] stringForKey:@"date"];
            self.tableDetailData = [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"fetal_list"];
        }
        [self.detailTableView reloadData];
    }
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32.0;
}


-(IBAction)backSheetView:(id)sender
{
    [self cancelCheckDetail];
}

- (void)cancelCheckDetail
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.sheetDetailView setFrame:CGRectMake(321, self.sheetView.frame.origin.y, self.sheetDetailView.frame.size.width, self.sheetDetailView.frame.size.height)];
    }];
}

- (void)openCheckDetail
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.sheetDetailView setFrame:CGRectMake(0, self.sheetDetailView.frame.origin.y, self.sheetDetailView.frame.size.width, self.sheetDetailView.frame.size.height)];
    }];
}


@end
