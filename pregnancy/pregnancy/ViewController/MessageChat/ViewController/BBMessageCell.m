//
//  BBMessageCell.m
//  pregnancy
//
//  Created by mac on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBMessageCell.h"
#import "BBUser.h"


@implementation BBMessageCell
@synthesize chatLeftView,chatRightView;
- (void)dealloc
{
    [chatLeftView release];
    [chatRightView release];
    
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.chatLeftView = [[[NSBundle mainBundle] loadNibNamed:@"BBMessageCellLeftView" owner:self options:nil]objectAtIndex:0];
        [self addSubview:chatLeftView];
        self.chatRightView = [[[NSBundle mainBundle] loadNibNamed:@"BBMessageCellRightView" owner:self options:nil]objectAtIndex:0];
        [self addSubview:chatRightView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setContent:(NSDictionary *)messageData withEditStatus:(BOOL)editStatus withSelectStatus:(BOOL)selectStatus withBBMessageChatDelegate:(id<BBMessageChatDelegate>)messageChatDelegate
{
//#if (APP_ID==0) && USE_FATHER_VERSION
    BOOL isSendBySelf = YES;

    if (![[messageData stringForKey:@"user_encode_id"] isEqualToString:[BBUser getEncId]] && ![[messageData stringForKey:@"user_encode_id"] isEqualToString:@"uzljsrc"])
    {
        isSendBySelf = NO;
    }

    
    if (!isSendBySelf)
    {
        [chatLeftView setHidden:NO];
        [chatLeftView setData:messageData withEditStatus:(BOOL)editStatus withSelectStatus:selectStatus withBBMessageChatDelegate:messageChatDelegate];
        [chatRightView setHidden:YES];
    }
    else
    {
        [chatLeftView setHidden:YES];
        [chatRightView setHidden:NO];
        [chatRightView setData:messageData withEditStatus:(BOOL)editStatus withSelectStatus:selectStatus withBBMessageChatDelegate:messageChatDelegate];
    }
    
//#else
//    
//    if (![[messageData stringForKey:@"user_encode_id"] isEqualToString:[BBUser getEncId]] && ![[messageData stringForKey:@"user_encode_id"] isEqualToString:@"uzljsrc"]) {
//        [chatLeftView setHidden:NO];
//        [chatLeftView setData:messageData withEditStatus:(BOOL)editStatus withSelectStatus:selectStatus withBBMessageChatDelegate:messageChatDelegate];
//        [chatRightView setHidden:YES];
//    }else {
//        [chatLeftView setHidden:YES];
//        [chatRightView setHidden:NO];
//        [chatRightView setData:messageData withEditStatus:(BOOL)editStatus withSelectStatus:selectStatus withBBMessageChatDelegate:messageChatDelegate];
//    }
//#endif
     self.backgroundColor = [UIColor  clearColor];
}

+(CGFloat)calculateHeightWithContent:(NSDictionary *)messageData{
    if (![[messageData stringForKey:@"user_encode_id"] isEqualToString:[BBUser getEncId]]) {
        return [BBMessageCellLeftView calculateHeightWithContent:messageData];
    }else {
        return [BBMessageCellRightView calculateHeightWithContent:messageData];
    }
}
@end
