//
//  HMMoreCircleTableView.m
//  lama
//
//  Created by jiangzhichao on 14-6-6.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMMoreCircleTableView.h"
#import "HMShowPage.h"
#import "HMApiRequest.h"

@implementation HMMoreCircleTableView

- (id)initWithFrame:(CGRect)frame refreshType:(HMRefreshType)refreshType
{
    self = [super initWithFrame:frame refreshType:refreshType];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCircleJoinState:) name:DIDCHANGE_CIRCLE_JOIN_STATE object:nil];
        self.m_Table.delegate = self;
        self.m_Table.dataSource = self;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_CIRCLE_JOIN_STATE object:nil];
}

- (void)freshData
{
    [super freshData];
    [self loadNextData];
}

- (void)loadNextData
{
    [super loadNextData];
    
    if (self.m_CanLoadNextPage)
    {
        [self loadDataRequest];
    }
    else
    {
        [self doneLoadingData];
    }
}


#pragma mark - loadDataRequest

- (void)loadDataRequest
{
    [self.m_DataRequest clearDelegatesAndCancel];
    self.m_DataRequest = [HMApiRequest circleListwithStart:self.m_BakLoadedPage withClassId:self.m_CircleId];
    [self.m_DataRequest setDelegate:self];
    [self.m_DataRequest setDidFinishSelector:@selector(loadDataFinished:)];
    [self.m_DataRequest setDidFailSelector:@selector(loadDataFail:)];
    [self.m_DataRequest startAsynchronous];
}

- (void)loadDataFinished:(ASIFormDataRequest *)request
{
    [self doneLoadingData];
    self.m_NoDataView.hidden = YES;
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];
    
    if (![dictData isDictionaryAndNotEmpty])
    {
        if (self.m_Data == 0)
        {
            self.m_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.m_NoDataView.hidden = NO;
        }
        else
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return ;
    }
    
    NSDictionary *dictList = [dictData dictionaryForKey:@"data"];
    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        if (self.m_LoadedPage == 0)
        {
            [self.m_Data removeAllObjects];
        }
        
        self.m_EachLoadCount = [dictList intForKey:@"page_count"];
        self.m_LoadedTotalCount = 10000;//API暂时没有
        
        NSArray *group = [dictList arrayForKey:@"group"];
        if ([group count] == 0)
        {
            self.m_LoadedTotalCount = [self.m_Data count];//API暂时没有
            if (self.m_Data.count == 0)
            {
                self.m_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
                self.m_NoDataView.hidden = NO;
            }
        }
        
        if ([group isNotEmpty])
        {
            for (NSDictionary *clumn in [dictList arrayForKey:@"group"])
            {
                if (![clumn isDictionaryAndNotEmpty])
                {
                    continue;
                }
                HMCircleClass *item = [[HMCircleClass alloc] init];
                item.circleId = [clumn stringForKey:@"id"];
                
                // 去重操作
                BOOL isExisted = NO;
                NSArray *array = [self.m_Data lastArrayWithCount:DUPLICATE_COMPARECOUNT];
                for (HMCircleClass *item1 in array)
                {
                    if ([item.circleId isEqualToString:item1.circleId])
                    {
                        isExisted = YES;
                        break;
                    }
                }
                if (isExisted)
                {
                    continue;
                }
                
                item.circleImageUrl = [clumn stringForKey:@"img_src"];
                item.circleTitle = [clumn stringForKey:@"title" defaultString:@""];
                item.topicNum = [clumn stringForKey:@"topic_count" defaultString:@""];
                item.memberNum = [clumn stringForKey:@"user_count" defaultString:@""];
                item.circleId = [clumn stringForKey:@"id"];
                item.addStatus = [clumn boolForKey:@"is_joined"];
                item.circleIntro = [clumn stringForKey:@"desc" defaultString:@""];

                item.type = [clumn stringForKey:@"type"];
                if ([item.type isEqualToString:@"1"])
                {
                    item.m_HospitalID = [clumn stringForKey:@"hospital_id" defaultString:@""];
                }
                item.isMyCityCircle = [clumn boolForKey:@"is_mycity"];
                [self.m_Data addObject:item];
            }
            
            self.m_LoadedPage++;
            
            if ([self.m_Data isNotEmpty])
            {
                [self.m_Table reloadData];
            }
        }
    }
    else
    {
        if (self.m_Data.count == 0)
        {
            self.m_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.m_NoDataView.hidden = NO;
        }
        else
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
    }
    

}
- (void)loadDataFail:(ASIFormDataRequest *)request
{
    [self doneLoadingData];
    if (self.m_Data.count == 0)
    {
        self.m_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
        self.m_NoDataView.hidden = NO;
    }
    else
    {
        [PXAlertView showAlertWithTitle:@"数据下载错误, 请稍后再试！"];
    }
}


#pragma mark - TableDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_Data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HMMORECIRCLE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"HMMoreCircleCell";
    HMMoreCircleCell *cell = [self.m_Table dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMMoreCircleCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        [cell makeCellStyle];
    }
    
    if ( self.m_Data != nil && indexPath.row < self.m_Data.count)
    {
        HMCircleClass *item = [self.m_Data objectAtIndex:indexPath.row];
        [cell setCellContent:item];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"discuz_v2" label:@"更多圈-圈子点击"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < [self.m_Data count])
    {
        HMCircleClass *class = [self.m_Data objectAtIndex:indexPath.row];
        [HMShowPage showCircleTopic:self.viewController circleClass:class];
    }
}


#pragma mark - HMMoreCircleCellDelegate

- (void)showHud:(NSString *)text delay:(NSTimeInterval)delay
{
    if ([text isNotEmpty])
    {
        if (delay > 0)
        {
            [self.m_ProgressHUD show:YES withText:text delay:delay];
        }
        else
        {
            [self.m_ProgressHUD show:YES withText:text];
        }
    }
    else
    {
        [self.m_ProgressHUD show:YES showBackground:NO];
    }
}

- (void)hideHud
{
    [self.m_ProgressHUD hide:YES];
}


#pragma mark - 通知: DIDCHANGE_CIRCLE_JOIN_STATE

- (void)changeCircleJoinState:(NSNotification *)notify
{
    NSDictionary *data = notify.object;
    NSString *groupId = [data stringForKey:@"group_id"];
    
    for (HMCircleClass *class in self.m_Data)
    {
        if ([class.circleId isEqual:groupId])
        {
            BOOL state = [data boolForKey:@"join_state"];
            class.addStatus = state;
        }
    }
}

@end
