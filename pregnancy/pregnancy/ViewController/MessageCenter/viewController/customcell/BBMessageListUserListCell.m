//
//  BBMessageListUserListCell.m
//  pregnancy
//
//  Created by babytree on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBMessageListUserListCell.h"
#import "UIImageView+WebCache.h"
//#if (APP_ID == 0) && USE_FATHER_VERSION
#import "BBFatherInfo.h"
#import "BBUser.h"
//#endif

@implementation BBMessageListUserListCell
@synthesize avtarImageView;
@synthesize username;
@synthesize unreadMessageCount;
@synthesize messageContent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.avtarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 46, 46)];
        [self.contentView addSubview:self.avtarImageView];
        [self.avtarImageView setImage:[UIImage imageNamed:@"avatar_default"]];
        
        self.username = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, 180, 21)];
        [self.contentView addSubview:self.username];
        [self.username setFont:[UIFont boldSystemFontOfSize:15]];
        [self.username setTextColor:RGBColor(80, 80, 80, 1)];
        [self.username setBackgroundColor:[UIColor clearColor]];
        
        self.messageContent = [[UILabel alloc]initWithFrame:CGRectMake(65, 36, 250, 21)];
        [self.contentView addSubview:self.messageContent];
        [self.messageContent setFont:[UIFont systemFontOfSize:12]];
        [self.messageContent setTextColor:RGBColor(120, 120, 120, 1)];
        [self.messageContent setBackgroundColor:[UIColor clearColor]];
        
        self.unreadMessageCount = [[UILabel alloc]initWithFrame:CGRectMake(44, 2, 20, 20)];
        [self.contentView addSubview:self.unreadMessageCount];
        [self.unreadMessageCount setFont:[UIFont systemFontOfSize:14]];
        [self.unreadMessageCount setTextColor:[UIColor whiteColor]];
        [self.unreadMessageCount setTextAlignment:NSTextAlignmentCenter];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 66, 320, 1)];
        [self.contentView addSubview:line];
        [line setImage:[UIImage imageNamed:@"community_grey_line"]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.unreadMessageCount.layer.cornerRadius = 10;
    self.unreadMessageCount.layer.masksToBounds = YES;
    self.unreadMessageCount.backgroundColor = [UIColor redColor];
    avtarImageView.layer.masksToBounds = YES;
    avtarImageView.layer.cornerRadius = 23.f;
}
- (void)setCellWithData:(NSDictionary *)theData
{
    NSString *profileImg = [theData stringForKey:@"user_avatar"];
    if (profileImg!=nil && ![profileImg isEqual:[NSNull null]]) {
        [avtarImageView setImageWithURL:[NSURL URLWithString:profileImg]
                            placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    }
    if([theData stringForKey:@"nickname"]!=nil){
        [username setText:[theData stringForKey:@"nickname"]];
    }
    else
    {
        [username setText:nil];
    }
    if([theData stringForKey:@"unread_count"]!=nil){
        if ([[theData stringForKey:@"unread_count"]isEqualToString:@"0"]) {
            [unreadMessageCount setHidden:YES];
        }
        else
        {
            [unreadMessageCount setHidden:NO];
            if ([[theData stringForKey:@"unread_count"]integerValue]>99)
            {
                [unreadMessageCount setText:@"99"];
            }
            else
            {
                [unreadMessageCount setText:[theData stringForKey:@"unread_count"]];
            }
        }
    }
    else
    {
        [unreadMessageCount setHidden:YES];
    }
    if([theData stringForKey:@"content"]!=nil){
        [messageContent setText:[theData stringForKey:@"content"]];
    }
    else
    {
        [messageContent setText:nil];
    }
     self.backgroundColor = [UIColor  clearColor];
}
@end
