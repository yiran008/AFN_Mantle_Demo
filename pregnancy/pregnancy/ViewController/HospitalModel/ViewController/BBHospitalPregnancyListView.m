//
//  BBHospitalPregnancyListView.m
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalPregnancyListView.h"
#import "BBHospitalRequest.h"

@implementation BBHospitalPregnancyListView

@synthesize pregnancyTable, pregnancyArray, myRequest, hospitalId, hud,viewCtrl;

- (void)dealloc
{
    [pregnancyTable release];
    [pregnancyArray release];
    [myRequest clearDelegatesAndCancel];
    [myRequest release];
    [hospitalId release];
    [hud release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withHospitalId:(NSString *)hosId
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.pregnancyTable = [[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain] autorelease];
        pregnancyTable.delegate = self;
        pregnancyTable.dataSource = self;
        pregnancyTable.backgroundColor = [UIColor clearColor];
        pregnancyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:pregnancyTable];
        
        self.hud = [[[MBProgressHUD alloc] initWithView:self] autorelease];
        [self addSubview:hud];
        [hud setLabelText:@"正在查询"];
        [hud show:YES];
        
        self.backgroundColor = [UIColor colorWithRed:244./255. green:244./255. blue:244./255. alpha:1];
        
        self.hospitalId = hosId;
        [self.myRequest clearDelegatesAndCancel];
        self.myRequest = [BBHospitalRequest hospitalPregnancyListWithHospitalId:self.hospitalId withStartIndex:@"0"];
        [myRequest setDelegate:self];
        [myRequest setDidFinishSelector:@selector(connectFinished:)];
        [myRequest setDidFailSelector:@selector(connectFail:)];
        [myRequest startAsynchronous];
    }
    return self;
}

#pragma mark-- ASIFormDataRequest
- (void)connectFinished:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if ([[parserData stringForKey:@"status"] isEqualToString:@"0"] || [[parserData stringForKey:@"status"] isEqualToString:@"success"]) {
        self.pregnancyArray = (NSMutableArray *)[parserData arrayForKey:@"list"];
        [self.pregnancyTable reloadData];
    } else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[parserData stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)connectFail:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark-- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (pregnancyArray != nil) {
        number = pregnancyArray.count;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pregnancyCell = @"BBHospitalPregnancyCell";
    BBHospitalPregnancyCell *cell = [tableView dequeueReusableCellWithIdentifier:pregnancyCell];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBHospitalPregnancyCell" owner:self options:nil] objectAtIndex:0];
        cell.viewCtrl = self.viewCtrl;
    }
    
    NSDictionary *item = [pregnancyArray objectAtIndex:indexPath.row];
    [cell setData:item];
    
    return cell;
}

#pragma mark-- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark-- BBHospitalpregnancyCellDelegate
- (void)sendMessageCallBack:(NSString *)pregnancyId
{
    
}

@end
