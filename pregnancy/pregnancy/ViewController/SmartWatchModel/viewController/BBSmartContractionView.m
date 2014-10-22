//
//  BBSmartContractionView.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartContractionView.h"
#import "BBSupportTopicDetail.h"
@interface BBSmartContractionView ()

@property (nonatomic, strong) NSMutableArray *tableDetailData;
@property (assign) NSInteger page;
@property (assign) NSInteger pageCount;

@end

@implementation BBSmartContractionView

- (void)dealloc
{
    [_chartRequest clearDelegatesAndCancel];
    [_chartRequest release];
    [_chartImage release];
    [_chartLabel release];
    [_chartView release];
    
    [_tableData release];
    [_sheetView release];
    [_loadProgress release];
    [_tableView release];
    
    [_sheetTitle release];
    [_detailTableView release];
    [_sheetDetailView release];
    [_tableDetailData release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.page = 1;
        self.pageCount =1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"宫缩计数"];
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
        [self.sheetDetailView setFrame:CGRectMake(self.sheetDetailView.frame.origin.x, self.sheetDetailView.frame.origin.y, self.sheetDetailView.frame.size.width, self.sheetDetailView.frame.size.height + 88)];
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 88)];
        [self.detailTableView setFrame:CGRectMake(self.detailTableView.frame.origin.x, self.detailTableView.frame.origin.y, self.detailTableView.frame.size.width, self.detailTableView.frame.size.height + 88)];
    }
    self.chartLabel.text = [NSString stringWithFormat:@"%d-%d",self.page,self.pageCount];
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
    [MobClick event:@"watch_v2" label:@"专家建议-宫缩"];
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:[NSString stringWithFormat:@"%@/mobile/app/watch/advice.php?type=contraction",BABYTREE_URL_SERVER]];
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
    if (self.page > 1) {
        self.page--;
    }
    self.chartLabel.text = [NSString stringWithFormat:@"%d-%d",self.page,self.pageCount];
    [self loadChartRequest];
}

-(IBAction)nextClicked:(id)sender
{
    if (self.page == self.pageCount) {
        return;
    }
    self.page++;
    self.chartLabel.text = [NSString stringWithFormat:@"%d-%d",self.page,self.pageCount];
    [self loadChartRequest];
}


-(void)loadChartRequest
{
    [self.loadProgress show:YES];
    [self.chartRequest clearDelegatesAndCancel];
    self.chartRequest = [BBSmartRequest smartWatchContraction:[NSString stringWithFormat:@"%d",self.page]];
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
        self.page = [[resultData stringForKey:@"page"] integerValue];
        self.pageCount = [[resultData stringForKey:@"page_total"] integerValue];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 111) {
        return [self.tableData count];
    }else{
        return [self.tableDetailData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 111) {
        static NSString *smartCell = @"smartContractionCell";
        BBSmartContractionCell *cell = (BBSmartContractionCell *)[tableView dequeueReusableCellWithIdentifier:smartCell];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSmartContractionCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([self.tableData count] > indexPath.row)
        {
          [cell setupCell:[self.tableData objectAtIndex:indexPath.row]];
        }
        return cell;
    }else{
        static NSString *detailCell = @"contractionDetailCell";
        BBContractionDetailCell *concell = (BBContractionDetailCell *)[tableView dequeueReusableCellWithIdentifier:detailCell];
        if(concell == nil){
            concell = [[[NSBundle mainBundle] loadNibNamed:@"BBContractionDetailCell" owner:self options:nil] objectAtIndex:0];
        }
        if([self.tableDetailData count] > indexPath.row)
        {
            [concell setupCell:[self.tableDetailData objectAtIndex:indexPath.row]];
        }
        return concell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 111) {
        [MobClick event:@"watch_v2" label:@"详细-宫缩"];
        [self openCheckDetail];
        if ([self.tableData count] > indexPath.row) {
            self.sheetTitle.text = [[self.tableData objectAtIndex:indexPath.row] stringForKey:@"date"];
            self.tableDetailData = [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"detail_list"];
        }
        [self.detailTableView reloadData];
    }
    
}


#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
