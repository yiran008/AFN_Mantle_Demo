//
//  HMRecommendDayCell.m
//  lama
//
//  Created by songxf on 13-6-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMRecommendDayCell.h"
#import <QuartzCore/CALayer.h>
#import "HMRecommendItemCell.h"
//#import "BBNewTopicDetail.h"
#import "HMShowPage.h"

@implementation HMRecommendDayCell
@synthesize timeLab;
@synthesize cellData;
@synthesize c_table;

- (void)dealloc
{
    [c_table release];
    [timeLab release];
    [cellData release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // 加载一个显示时间的lab
        self.timeLab = [[[UILabel alloc] initWithFrame:CGRectMake((getScreenWidth()-100)/2, 0, 100, 20)] autorelease];
        timeLab.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = [UIFont systemFontOfSize:12];
        timeLab.textColor = [UIColor whiteColor];
        [[timeLab layer] setCornerRadius:4];
        [self.contentView addSubview:timeLab];

        // 用table加载其他数据
        self.c_table = [[[UITableView alloc] initWithFrame: CGRectMake(DISTANCE_ABOUT_SCREENLEFT, 30, getScreenWidth()-DISTANCE_ABOUT_SCREENLEFT*2, 365-1)] autorelease];
        c_table.separatorColor = [UIColor colorWithHex:0xEEEEEE];
        c_table.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:c_table];
        [[c_table layer] setCornerRadius:10];
        c_table.dataSource = self;
        c_table.scrollEnabled = NO;
        c_table.delegate = self;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

// 设置对应数据并刷新
- (void)setNewData:(HMDayRecommendModel *)Data
{
    self.cellData = Data;
    timeLab.text = [cellData getDateText];
    [c_table reloadData];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark
#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellData.dayRecommendList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return BIG_ITEM_HEIGHT;
    }
    
    return SMALL_ITEM_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"itemCellIdentifier";
    HMRecommendItemCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[HMRecommendItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    }
    
    // 设置cell绑定的数据
    HMRecommendModel *rowData = (HMRecommendModel *)[cellData.dayRecommendList objectAtIndex:indexPath.row];
    [cell setNewData:rowData style:!indexPath.row itemHeight:SMALL_ITEM_HEIGHT];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMRecommendModel *data = (HMRecommendModel *)[cellData.dayRecommendList objectAtIndex:indexPath.row];
    if ([BBUser getNewUserRoleState]==BBUserRoleStatePrepare)
    {
        [MobClick event:@"recommend_prepare_v2" label:[NSString stringWithFormat:@"宝宝树推荐-%@",data.topicId]];
    }
    else if ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant)
    {
        [MobClick event:@"recommend_pregnant_v2" label:[NSString stringWithFormat:@"宝宝树推荐-%@",data.topicId]];
    }
    else
    {
        [MobClick event:@"recommend_baby_v2" label:[NSString stringWithFormat:@"宝宝树推荐-%@",data.topicId]];
    }
    [BBStatistic visitType:BABYTREE_TYPE_TOPIC_RECOMMEND_MORE contentId:data.topicId];
    [HMShowPage showTopicDetail:self.viewController topicId:data.topicId topicTitle:data.title];

}

@end
