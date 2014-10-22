//
//  BBKuaidiRecordCell.m
//  pregnancy
//
//  Created by MAYmac on 13-12-12.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBKuaidiRecordCell.h"

@interface BBKuaidiRecordCell ()
{
    
}

@property(nonatomic,retain) IBOutlet UILabel * callTexiTimeLabel;
@property(nonatomic,retain) IBOutlet UILabel * startPlaceLabel;
@property(nonatomic,retain) IBOutlet UILabel * endPlaceLabel;
@property(nonatomic,retain) IBOutlet UILabel * orderTimeLabel;
@property(nonatomic,retain) IBOutlet UILabel * orderStatusLabel;
//申请返现按钮
@property(nonatomic,retain) IBOutlet UIButton * applyButton;
@property(nonatomic,retain) IBOutlet UIImageView * orderStatusImage;
//cell在arr中的index
@property(nonatomic,assign) int index;

@end

@implementation BBKuaidiRecordCell

- (void)dealloc
{
    [_callTexiTimeLabel release];
    [_startPlaceLabel release];
    [_endPlaceLabel release];
    [_orderTimeLabel release];
    [_orderStatusLabel release];
    [_applyButton release];
    [_orderStatusImage release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (NSString *)getImageNameByIndex:(int)type
{
    if (type == 1)
    {
        return @"taxi_record_timeoff@2x.png";
    }
    else if (type == 0)
    {
        return @"taxi_record_idreview@2x.png";
    }
    else if (type == 4)
    {
        return @"taxi_record_cashback@2x.png";
    }
    else if (type == 2)
    {
        return @"taxi_record_nothing@2x.png";
    }
    else if (type == 3)
    {
        return @"taxi_record_onreview@2x.png";
    }
    return nil;
}

- (NSString *)getStatusByType:(int)type
{
    if (type == 0 || type == 2)
    {
        return @"订单审核中";
    }
    else if(type == 1 || type == 3)
    {
        return @"订单取消";
    }
    else if(type == 4)
    {
        return @"订单失败";
    }else if(type == 5)
    {
        return @"订单完成";
    }
    return @"";
}

- (void)setData:(NSDictionary *)cellData atIndex:(int)index
{
    [self.applyButton setBackgroundImage:[[UIImage imageNamed:@"message_button"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    self.index = index;
    self.callTexiTimeLabel.text = [NSString stringWithFormat:@"接单时间:%@",[cellData stringForKey:@"accept_ts"]];
    self.startPlaceLabel.text = [NSString stringWithFormat:@"起点:%@",[cellData stringForKey:@"from"]];
    self.endPlaceLabel.text = [NSString stringWithFormat:@"终点:%@",[cellData stringForKey:@"to"]];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",[cellData stringForKey:@"create_ts"]];
    self.orderStatusLabel.text = [self getStatusByType:[[cellData objectForKey:@"order_status"]intValue]];
    self.orderStatusImage.image = [UIImage imageNamed:[self getImageNameByIndex:[[cellData stringForKey:@"back_status"]integerValue]]];
    
    if ([[cellData stringForKey:@"back_status"]isEqualToString:@"-2"])
    {
        self.applyButton.hidden = NO;
    }else
    {
        self.applyButton.hidden = YES;
    }
    self.applyButton.exclusiveTouch = YES;
}

//点击申请返现按钮
- (IBAction)applyForCashBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyForCashBackAtIndex:)]) {
        [self.delegate applyForCashBackAtIndex:self.index];
    }
}

@end
