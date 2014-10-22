//
//  BBTopicMessageCell.m
//  pregnancy
//
//  Created by Wang Jun on 12-11-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBNotificationCell.h"
#import "BBTimeUtility.h"
#import "BBApp.h"

#define NOTIFICATION_CONTENT_FONT 14

@implementation BBNotificationCell

@synthesize contentLabel,timeLabel,data,cellLineImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        self.contentLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(9, 12, 250, 14)];
        [contentLabel setFont:[UIFont systemFontOfSize:NOTIFICATION_CONTENT_FONT]];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:contentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(109, 36, 150, 14)];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [timeLabel setTextColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1.0]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:timeLabel];
        
        self.cellLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 37, 320, 1)];
        
        [self.cellLineImageView setImage:[UIImage imageNamed:@"community_grey_line"]];


        [self.contentView addSubview:self.cellLineImageView];
        [self.contentView setClipsToBounds:YES];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Custom Method

+ (CGFloat)heightForCellWithData:(NSDictionary *)theData
{
    if ([[theData stringForKey:@"type"] isEqualToString:@"1"]) {
        NSString *topic_title = [NSString stringWithFormat:@"\"%@\"",[theData stringForKey:@"topic_title"]];
        NSString *titleString = [NSString stringWithFormat:@"你的话题 %@ 有%@条新回复",topic_title, [theData stringForKey:@"topic_reply_unread_count"]];
        CGSize messageSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(250, 1024) withFont:[UIFont systemFontOfSize:NOTIFICATION_CONTENT_FONT] withString:titleString];
        return 12 +messageSize.height + 12 + 14 + 12;
    } else {
        NSString *topic_title = [NSString stringWithFormat:@"\"%@\"",[theData stringForKey:@"topic_title"]];
        NSString *titleString = [NSString stringWithFormat:@"%@ 在话题 %@ 中回复了你", [theData stringForKey:@"reply_user_nickname"], topic_title];
        CGSize messageSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(250, 1024) withFont:[UIFont systemFontOfSize:NOTIFICATION_CONTENT_FONT] withString:titleString];
        return 12 +messageSize.height + 12 + 14 + 12;
    }
}

- (void)setCellWithData:(NSDictionary *)theData
{
    self.data = theData;
    
    CGFloat currentHeight = 0;
    
    if ([[theData stringForKey:@"type"] isEqualToString:@"1"]) {
        currentHeight = 12;

        NSMutableAttributedString *topicTitleAttri = nil;
        NSString *topic_title = [NSString stringWithFormat:@"\"%@\"",[theData stringForKey:@"topic_title"]];
        NSString *titleString = [NSString stringWithFormat:@"你的话题 %@ 有%@条新回复",topic_title, [theData stringForKey:@"topic_reply_unread_count"]];
        topicTitleAttri = [NSMutableAttributedString attributedStringWithString:titleString];
        [topicTitleAttri setTextIsUnderlined:NO];
        [topicTitleAttri setTextColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1.0]];
       
        [topicTitleAttri setTextColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0] range:[titleString rangeOfString:topic_title]];
        [topicTitleAttri setFont:[UIFont systemFontOfSize:NOTIFICATION_CONTENT_FONT]];
        
        [contentLabel setAttributedText:topicTitleAttri];
        CGSize messageSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(250, 1024) withFont:[UIFont systemFontOfSize:NOTIFICATION_CONTENT_FONT] withString:titleString];
        [contentLabel setFrame:CGRectMake(8, 12, 250, messageSize.height + 10)];
        
        currentHeight = currentHeight + messageSize.height +12;
        
        [timeLabel setText:[BBTimeUtility stringDateWithPastTimestamp:[[theData stringForKey:@"topic_last_reply_ts"] doubleValue]]];
        [timeLabel setFrame:CGRectMake(162, currentHeight, 150, 14)];
    } else {
        currentHeight = 12;
        
        NSMutableAttributedString *topicTitleAttri = nil;
        NSString *topic_title = [NSString stringWithFormat:@"\"%@\"",[theData stringForKey:@"topic_title"]];
        NSString *titleString = [NSString stringWithFormat:@"%@ 在话题 %@ 中回复了你", [theData stringForKey:@"reply_user_nickname"], topic_title];
        topicTitleAttri = [NSMutableAttributedString attributedStringWithString:titleString];
        [topicTitleAttri setTextIsUnderlined:NO];
        [topicTitleAttri setTextColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1.0]];
        [topicTitleAttri setTextColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0] range:[titleString rangeOfString:topic_title]];
        [topicTitleAttri setFont:[UIFont systemFontOfSize:NOTIFICATION_CONTENT_FONT]];
        
        [contentLabel setAttributedText:topicTitleAttri];
        CGSize titleSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(250, 1024) withFont:[UIFont systemFontOfSize:NOTIFICATION_CONTENT_FONT] withString:contentLabel.attributedText.string];
        [contentLabel setFrame:CGRectMake(8, 12, 250, titleSize.height + 10)];
        
        currentHeight = currentHeight + titleSize.height +12;
        
        [timeLabel setText:[BBTimeUtility stringDateWithPastTimestamp:[[theData stringForKey:@"reply_user_ts"] doubleValue]]];
        [timeLabel setFrame:CGRectMake(162, currentHeight, 150, 14)];
    }
    [self.cellLineImageView setFrame:CGRectMake(0, currentHeight+14+11, 320, 1)];
    //[self.selectedBg setFrame:CGRectMake(0, 0, 320, currentHeight+14+11)];
}
@end
