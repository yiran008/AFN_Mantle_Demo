//
//  HMReportVC.m
//  lama
//
//  Created by songxf on 14-4-21.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMReportVC.h"
#import "BBConfigureAPI.h"

@interface HMReportVC ()

@property (nonatomic,strong) NSArray *s_reportTypeData;
@property (nonatomic,strong) NSIndexPath *s_LastIndexPath;

@end

@implementation HMReportVC

- (void)dealloc
{
    [_m_ReportRequest clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withReportedName:(NSString *)reportedName topicID:(NSString *)topicID replyID:(NSString *)replyID floor:(NSString *)floor
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.m_TopicID = topicID;
        self.m_ReplyID = replyID;

        if ([replyID isNotEmpty])
        {
            self.m_IsReply = YES;
        }

        if (self.m_IsReply)
        {
            if ([reportedName isNotEmpty])
            {
                self.m_ReportedName = [NSString stringWithFormat:@"%@楼%@的回复", floor, reportedName];
            }
            else
            {
                self.m_ReportedName = [NSString stringWithFormat:@"%@楼的回复", floor];
            }
        }
        else
        {
            if ([reportedName isNotEmpty])
            {
                self.m_ReportedName = [NSString stringWithFormat:@"楼主%@的帖子", reportedName];
            }
            else
            {
                self.m_ReportedName = @"楼主帖子";
            }
        }
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
//    self.umeng_VCname = @"举报页面";
    [self setNavBar:@"举报" bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:@"发送" rightBtnImage:nil rightToucheEvent:@selector(reportCommit:)];

    self.m_ProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.m_ProgressHUD];
    
    self.s_reportTypeData = [[NSArray alloc]initWithObjects:@"垃圾广告", @"敏感信息", @"虚假中奖", @"淫秽色情", @"不实信息", nil];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 50)];
    headLabel.numberOfLines = 0;
    [headLabel setBackgroundColor:[UIColor clearColor]];
    [headLabel setTextColor:UI_TEXT_OTHER_COLOR];
    [headLabel setFont:[UIFont systemFontOfSize:16]];
    [headLabel setText:@"   请选择举报类型"];
    [self.m_ReportTableView setTableHeaderView:headLabel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.m_ReportTableView reloadData];
}

-(void)reportCommit:(id)sender
{
    if (self.s_LastIndexPath != nil)
    {
        [self.m_ReportRequest clearDelegatesAndCancel];
        [self.m_ProgressHUD setLabelText:@"举报..."];
        [self.m_ProgressHUD show:YES];
        self.m_ReportRequest = [BBUserRequest reportSendRequest:self.m_TopicID withReplyId:self.m_ReplyID withReportType:[NSString stringWithFormat:@"%d",self.s_LastIndexPath.row + 1]];
        [self.m_ReportRequest setDidFinishSelector:@selector(reportRequestFinished:)];
        [self.m_ReportRequest setDidFailSelector:@selector(reportRequestFailed:)];
        [self.m_ReportRequest setDelegate:self];
        [self.m_ReportRequest startAsynchronous];
    }
    else
    {
        [PXAlertView showAlertWithTitle:@"提示信息" message:@"请选择举报类型" cancelTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        }];
    }
}

- (void)reportRequestFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *jsonData = [responseString objectFromJSONString];

    if (![jsonData isDictionaryAndNotEmpty])
    {
        [self.m_ProgressHUD setLabelText:@"举报失败"];
        [self.m_ProgressHUD show:YES];
        [self.m_ProgressHUD hide:YES afterDelay:2];

        return;
    }
    
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [self.m_ProgressHUD setLabelText:@"举报成功"];
        [self.m_ProgressHUD show:YES];
        [self.m_ProgressHUD hide:YES afterDelay:2];
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self backAction:nil];
        });
    }
    else
    {
        [self.m_ProgressHUD setLabelText:@"举报失败"];
        [self.m_ProgressHUD show:YES];
        [self.m_ProgressHUD hide:YES afterDelay:2];
    }
}

- (void)reportRequestFailed:(ASIFormDataRequest *)request
{
    [self.m_ProgressHUD setLabelText:@"举报失败"];
    [self.m_ProgressHUD show:YES];
    [self.m_ProgressHUD hide:YES afterDelay:2];
}


#pragma tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.s_reportTypeData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"reportTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        cell.textLabel.textColor  = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    cell.textLabel.text = [self.s_reportTypeData objectAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    int newRow = [indexPath row];
    int oldRow = (self.s_LastIndexPath != nil) ? [self.s_LastIndexPath row] : -1;
    if(newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.s_LastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.s_LastIndexPath = indexPath;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
