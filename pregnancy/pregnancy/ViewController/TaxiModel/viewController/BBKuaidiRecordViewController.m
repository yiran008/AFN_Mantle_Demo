//
//  BBKuaidiRecordViewController.m
//  pregnancy
//
//  Created by MAYmac on 13-12-12.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBKuaidiRecordViewController.h"
#import "BBCallTaxiRequest.h"
#import "BBKuaidiRecordCell.h"
#import "BBTaxiOrdersDetail.h"
#import "BBKuaidiVerificationViewController.h"
#import "BBRollCycleView.h"
#import "BBTaxiLocationData.h"

@interface BBKuaidiRecordViewController ()<UITableViewDataSource,UITableViewDelegate,BBKuaidiRecordCellDelegate,BBKuaidiVerificationDelegate>
{
    
}
@property(nonatomic,retain) UITableView * recordTableView;
@property(nonatomic,retain) ASIFormDataRequest * recordRequest;
@property(nonatomic,retain) NSMutableArray * recordsArr;
@property(nonatomic,retain) NSMutableArray * banerStrArr;
@property(nonatomic,retain) BBRollCycleView * rollView;
@property(nonatomic,retain) MBProgressHUD * progressBar;
@property(nonatomic,assign) BOOL isApply;
@end

@implementation BBKuaidiRecordViewController

-(void)dealloc
{
    [_recordRequest clearDelegatesAndCancel];
    [_recordRequest release];
    [_recordTableView release];
    [_progressBar release];
    [super dealloc];
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
    self.rollView = [[[BBRollCycleView alloc]initWithFrame:CGRectMake(17, 7, 270, 22)]autorelease];
    
    [self.navigationItem setTitle:@"打车记录"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    NSInteger statusBar = 0;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        statusBar = 20;
    }
    self.recordTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - statusBar) style:UITableViewStylePlain]autorelease];
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recordTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recordTableView];
    
    self.progressBar = [[[MBProgressHUD alloc]initWithView:self.view]autorelease];
    [self.view addSubview:self.progressBar];
    
    [self fecthRecordsData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.rollView stopTimer];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.rollView startTimer];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)fecthRecordsData
{
    NSString * lat = [BBTaxiLocationData getCurrentLatitudeString];
    NSString * lng = [BBTaxiLocationData getCurrentLongitudeString];
    self.recordRequest = [BBCallTaxiRequest fetchKuaidiRecordsWithLat:lat lng:lng];
    [self.recordRequest setDidFinishSelector:@selector(requestFinishedWithRecords:)];
    [self.recordRequest setDidFailSelector:@selector(requestFailedWithRecords:)];
    [self.recordRequest setDelegate:self];
    [self.recordRequest startAsynchronous];
    
    [self.progressBar show:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFinishedWithRecords:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser * parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSDictionary * data = [jsonDictionary dictionaryForKey:@"data"];
        self.recordsArr = (NSMutableArray *)[data arrayForKey:@"order_list"];
        //设置banner的显示内容数组
        self.banerStrArr = nil;
        self.banerStrArr = [[[NSMutableArray alloc]init]autorelease];
        //预防服务器数据类型不稳定
        NSString * word = [[data dictionaryForKey:@"word"]stringForKey:@"city_back_ini_word_first"];
        if (word && word.length)
        {
            [self.banerStrArr addObject:word];
        }
        word = [[data dictionaryForKey:@"word"]stringForKey:@"city_back_ini_word_times"];
        if (word && word.length)
        {
            [self.banerStrArr addObject:word];
        }
        [self.rollView setStrArray:self.banerStrArr];
        [self.rollView resetTimer];
        [self.recordTableView reloadData];
    }
    [self.progressBar hide:YES];
}

- (void)requestFailedWithRecords:(ASIFormDataRequest *)request
{
    [self.progressBar hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //第一个section是用反解析的数据第一条
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.banerStrArr && [self.banerStrArr count])
        {
            return 1;
        }
    }
    else if (section == 1)
    {
        if (self.recordsArr && [self.recordsArr count])
        {
            return [self.recordsArr count];
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 50;
    }
    return 172;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *SimpleTableIdentifier = @"banner";
        UITableViewCell *cell = [self.recordTableView dequeueReusableCellWithIdentifier:
                                 SimpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: SimpleTableIdentifier] autorelease];
            UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 9, 304, 35)];
            imgv.image = [UIImage imageNamed:@"taxi_record_top@2x.png"];
            [imgv addSubview:self.rollView];
            [cell.contentView addSubview:imgv];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           [imgv release];
            
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"BBKuaidiRecordCell";
        BBKuaidiRecordCell *cell = [self.recordTableView dequeueReusableCellWithIdentifier:
                                 CellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BBKuaidiRecordCell" owner:self options:nil] objectAtIndex:0];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData:[self.recordsArr objectAtIndex:indexPath.row] atIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else if(indexPath.section == 1)
    {
        BBTaxiOrdersDetail * tod = [[BBTaxiOrdersDetail alloc]init];
        tod.orderNumber = [[_recordsArr objectAtIndex:indexPath.row]objectForKey:@"enc_order_id"];
        [self.navigationController pushViewController:tod animated:YES];
        [tod release];
    }
}

#pragma mark- BBKuaidiRecordCellDelegateMethod

- (void)applyForCashBackAtIndex:(int)index
{
    BBKuaidiVerificationViewController * kvf = [BBKuaidiVerificationViewController alloc];
    kvf.isApplied = NO;
    kvf.delegate = self;
    kvf.isApplied = self.isApply;
    [self.navigationController pushViewController:kvf animated:YES];
    [kvf release];
}

-(void)verificationIsApply:(BOOL)isApply
{
    self.isApply = isApply;
}

@end
