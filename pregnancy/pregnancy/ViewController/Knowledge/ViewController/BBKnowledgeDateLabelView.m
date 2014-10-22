//
//  BBKnowledgeDateLabelView.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-30.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBKnowledgeDateLabelView.h"
static BBUserRoleState roleState = BBUserRoleStateNone;
static int curDays = 0;

@interface BBKnowledgeDateLabelView ()

@end

@implementation BBKnowledgeDateLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setDateData:(BBKonwlegdeModel *)data
{
    labelType type = labelTypePregNormal;
    int parentMonth = 0;
    int parentDay = 0;
    //育儿状态
    if (data.period == knowlegdePeriodParent)
    {
        NSDate * birthDate = [BBPregnancyInfo dateOfPregnancy];
        NSDate * curDate = [birthDate dateByAddingDays:data.days.intValue-1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        NSDateComponents *dateCom = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:birthDate toDate:curDate options:0];
        
        if (dateCom.month == 0)
        {
            type = labelTypePareDays;
        }
        else if(dateCom.month >= 0 && dateCom.day == 0)
        {
            type = labelTypePareMonth;
        }
        else
        {
            type = labelTypePareNormal;
        }
        parentDay = dateCom.day;
        parentMonth = dateCom.month;
        if (parentMonth == 0) {
            parentDay++;
        }
    }//孕期状态
    else if(data.days.intValue == 21)
    {
        type = labelTypePregBegin;
    }
    else if(data.days.intValue % 7 == 0)
    {
        type = labelTypePregWeek;
    }else
    {
        type = labelTypePregNormal;
    }
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIView * labelBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    labelBack.backgroundColor = [UIColor colorWithRed:208./255. green:208./255. blue:208./255. alpha:1];
    labelBack.layer.cornerRadius = 3;

    switch (type)
    {
        case labelTypePregWeek:
        {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, 20, 20)];
            label.text = @"孕";
            label.font = [UIFont boldSystemFontOfSize:14.];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:label];
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(32, 24, 26, 26)];
            label.text = @"周";
            label.font = [UIFont boldSystemFontOfSize:14.];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:label];
            
            UILabel* weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 13, 32, 22)];
            weekLabel.text = @"0";
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.font = [UIFont boldSystemFontOfSize:23.];
            weekLabel.textColor = [UIColor whiteColor];
            weekLabel.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:weekLabel];
            
            labelBack.backgroundColor = RGBColor(255, 83, 123, 1);
            
            if (data.week)
            {
                weekLabel.text = data.week;
            }
            
            break;
        }
        case labelTypePregNormal:
        {
#if 0
            OHAttributedLabel *weekLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(0, 1, 48, 35)];
            [weekLabel setBBTextAlignment:NSTextAlignmentCenter];
            weekLabel.textColor = [UIColor whiteColor];
            weekLabel.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:weekLabel];
            
            OHAttributedLabel *dayLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(0, 21, 48, 35)];
            dayLabel.font = [UIFont systemFontOfSize:17.];
            dayLabel.textColor = [UIColor whiteColor];
            dayLabel.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:dayLabel];
#endif
            
            if (data.week)
            {
#if 0
                NSMutableAttributedString *topicTitleAttri = nil;
                NSString *titleString = [NSString stringWithFormat:@"孕%@周", data.week];
                topicTitleAttri = [NSMutableAttributedString attributedStringWithString:titleString];
                [topicTitleAttri setTextIsUnderlined:NO];
                [topicTitleAttri setFont:[UIFont systemFontOfSize:19.] range:[titleString rangeOfString:data.week]];
                weekLabel.font = [UIFont systemFontOfSize:24.];
                [weekLabel setAttributedText:topicTitleAttri];
                [weekLabel setBBTextAlignment:NSTextAlignmentCenter];
                weekLabel.textColor = [UIColor whiteColor];
                
                topicTitleAttri = nil;
                titleString = [NSString stringWithFormat:@"%@天", data.weekPlusDay];
                topicTitleAttri = [NSMutableAttributedString attributedStringWithString:titleString];
                [topicTitleAttri setTextIsUnderlined:NO];
                [topicTitleAttri setFont:[UIFont systemFontOfSize:19.] range:[titleString rangeOfString:data.weekPlusDay]];
                [dayLabel setAttributedText:topicTitleAttri];
                dayLabel.textColor = [UIColor whiteColor];
                [dayLabel setBBTextAlignment:NSTextAlignmentCenter];
                dayLabel.textAlignment = NSTextAlignmentCenter;
#endif
                
  
                NSString *content1Text = @"孕";
                NSInteger length1 = [content1Text length];
                
                NSString *content2Text = data.week;
                NSInteger length2 = [content2Text length];
                
                NSString *content3Text = @"周";
                NSInteger length3 = [content3Text length];
                
                NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",content1Text,content2Text,content3Text]];
                [contentText addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(0, length1)];
                
                [contentText addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor whiteColor]
                                    range:NSMakeRange(0, length1)];
                
                [contentText addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:18]
                                    range:NSMakeRange(length1, length2)];
                [contentText addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor whiteColor]
                                    range:NSMakeRange(length1, length2)];
                
                [contentText addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(length1+length2, length3)];
                [contentText addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor whiteColor]
                                    range:NSMakeRange(length1+length2, length3)];
                UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 48, 28)];
                weekLabel.attributedText = contentText;
                weekLabel.textAlignment = NSTextAlignmentCenter;
                weekLabel.backgroundColor = [UIColor clearColor];
                [labelBack addSubview:weekLabel];
                
                
                content1Text = @"";
                length1 = [content1Text length];
                
                content2Text = data.weekPlusDay;
                length2 = [content2Text length];
                
                content3Text = @"天";
                length3 = [content3Text length];
                
                contentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",content1Text,content2Text,content3Text]];
                [contentText addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(0, length1)];
                
                [contentText addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor whiteColor]
                                    range:NSMakeRange(0, length1)];
                
                [contentText addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:18]
                                    range:NSMakeRange(length1, length2)];
                [contentText addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor whiteColor]
                                    range:NSMakeRange(length1, length2)];
                
                [contentText addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:13]
                                    range:NSMakeRange(length1+length2, length3)];
                [contentText addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor whiteColor]
                                    range:NSMakeRange(length1+length2, length3)];
                UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, 48, 28)];
                dayLabel.attributedText = contentText;
                dayLabel.textAlignment = NSTextAlignmentCenter;
                dayLabel.backgroundColor = [UIColor clearColor];
                [labelBack addSubview:dayLabel];
           }
            
            break;
        }
        case labelTypePregBegin:
        {
            UILabel *babyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 48, 28)];
            [babyLabel setBBTextAlignment:NSTextAlignmentCenter];
            babyLabel.text = @"孕3周";
            babyLabel.font = [UIFont boldSystemFontOfSize:14.];
            babyLabel.textColor = [UIColor whiteColor];
            babyLabel.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:babyLabel];
            
            UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, 48, 28)];
            [dayLabel setBBTextAlignment:NSTextAlignmentCenter];
            dayLabel.font = [UIFont boldSystemFontOfSize:14.];
            dayLabel.textColor = [UIColor whiteColor];
            dayLabel.text = @"之前";
            dayLabel.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:dayLabel];
            break;
        }
        case labelTypePareNormal:
        {
            UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, 48, 14)];
            label1.text = @"宝宝";
            label1.font = [UIFont boldSystemFontOfSize:12.];
            label1.textColor = [UIColor whiteColor];
            label1.backgroundColor = [UIColor clearColor];
            label1.textAlignment = NSTextAlignmentCenter;
            [labelBack addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, 48, 14)];
            label2.text = @"月";
            label2.font = [UIFont boldSystemFontOfSize:12.];
            label2.textColor = [UIColor whiteColor];
            label2.backgroundColor = [UIColor clearColor];
            label2.textAlignment = NSTextAlignmentCenter;
            [labelBack addSubview:label2];
            
            UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 48, 14)];
            label3.text = @"天";
            label3.font = [UIFont boldSystemFontOfSize:12.];
            label3.textColor = [UIColor whiteColor];
            label3.backgroundColor = [UIColor clearColor];
            label3.textAlignment = NSTextAlignmentCenter;
            [labelBack addSubview:label3];
            
            label2.text = [NSString stringWithFormat:@"%d个月",parentMonth];
            label3.text = [NSString stringWithFormat:@"%d天",parentDay];
            
            break;
        }
        case labelTypePareDays:
        case labelTypePareMonth:
        {
            UILabel *babyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 48, 28)];
            [babyLabel setBBTextAlignment:NSTextAlignmentCenter];
            babyLabel.text = @"宝宝";
            babyLabel.font = [UIFont boldSystemFontOfSize:14.];
            babyLabel.textColor = [UIColor whiteColor];
            babyLabel.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:babyLabel];
            
            OHAttributedLabel *dayLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(0, 21, 48, 35)];
            dayLabel.font = [UIFont boldSystemFontOfSize:17.];
            dayLabel.textColor = [UIColor whiteColor];
            dayLabel.backgroundColor = [UIColor clearColor];
            [labelBack addSubview:dayLabel];
            
            if (type == labelTypePareDays)
            {
                if (parentDay == 1) {
                    dayLabel.font = [UIFont boldSystemFontOfSize:14.];
                    dayLabel.frame = CGRectMake(3.5, 25, 48, 35);
                    dayLabel.text = @"出生了";
                    labelBack.backgroundColor = RGBColor(255, 83, 123, 1);
                }else
                {
                    NSMutableAttributedString *topicTitleAttri = nil;
                    NSString *titleString = [NSString stringWithFormat:@"%d天", parentDay];
                    topicTitleAttri = [NSMutableAttributedString attributedStringWithString:titleString];
                    [topicTitleAttri setTextIsUnderlined:NO];
                    [topicTitleAttri setFont:[UIFont systemFontOfSize:19.] range:[titleString rangeOfString:[NSString stringWithFormat:@"%d",parentDay]]];
                    [dayLabel setAttributedText:topicTitleAttri];
                    dayLabel.textColor = [UIColor whiteColor];
                    [dayLabel setBBTextAlignment:NSTextAlignmentCenter];
                    dayLabel.textAlignment = NSTextAlignmentCenter;
                }
                
            }else
            {
                NSMutableAttributedString *topicTitleAttri = nil;
                NSString *titleString = [NSString stringWithFormat:@"%d个月", parentMonth];
                topicTitleAttri = [NSMutableAttributedString attributedStringWithString:titleString];
                [topicTitleAttri setTextIsUnderlined:NO];
                [topicTitleAttri setFont:[UIFont systemFontOfSize:19.] range:[titleString rangeOfString:[NSString stringWithFormat:@"%d",parentMonth]]];
                [dayLabel setAttributedText:topicTitleAttri];
                dayLabel.textColor = [UIColor whiteColor];
                [dayLabel setBBTextAlignment:NSTextAlignmentCenter];
                dayLabel.textAlignment = NSTextAlignmentCenter;
                labelBack.backgroundColor = RGBColor(255, 83, 123, 1);
            }
            
            break;
        }
            
        default:
            break;
    }

    //每一条的date
    int myDays = curDays;

    NSDate * date = nil;
    if (roleState == BBUserRoleStatePregnant)
    {
        date= [[NSDate date]dateByAddingDays:(data.period == knowlegdePeriodParent)?(data.days.intValue + 280 - myDays -1):(data.days.intValue - myDays)];
    }
    else
    {
        date= [[NSDate date]dateByAddingDays:(data.period == knowlegdePeriodParent)?(data.days.intValue - myDays):(data.days.intValue - 280 - myDays + 1)];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"M'月'd'日"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(-3, 48, 54, 16)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:11.5];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    if (dateStr)
    {
        dateLabel.text = dateStr;
    }
    [self addSubview:dateLabel];
    
    [self addSubview:labelBack];

    if (data.days && data.days.intValue == myDays
        &&((data.period == knowlegdePeriodPregnancy && roleState==BBUserRoleStatePregnant)
           ||(data.period == knowlegdePeriodParent && roleState==BBUserRoleStateHasBaby)))
    {
        labelBack.backgroundColor = [UIColor colorWithRed:248./255. green:147./255. blue:173./255. alpha:1];
        dateLabel.text = @"今天";
    }
}


+ (void)setRoleState:(BBUserRoleState)state
{
    roleState = state;
}

+ (void)setCurDays:(int)days
{
    curDays = days;
}
@end
