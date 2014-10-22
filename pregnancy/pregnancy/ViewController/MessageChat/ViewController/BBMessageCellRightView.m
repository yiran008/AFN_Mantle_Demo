//
//  BBMessageRightCell.m
//  pregnancy
//
//  Created by mac on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBMessageCellRightView.h"
#import "UIButton+WebCache.h"

@implementation BBMessageCellRightView
@synthesize deleteButton,dateLabel,avtarButton,contentLabel,contentLabelBg,data,selectStatusValue,messageChatDelegate,linkButton;

- (void)dealloc
{
    [deleteButton release];
    [dateLabel release];
    [avtarButton release];
    [contentLabel release];
    [contentLabelBg release];
    [data release];
    [linkButton release];
    [_tipBackView release];
    [_tipLabel release];
    
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setData:(NSDictionary *)commentData withEditStatus:(BOOL)editStatus withSelectStatus:(BOOL)selectStatus withBBMessageChatDelegate:(id<BBMessageChatDelegate>)delegate{
    [self.avtarButton.layer setMasksToBounds:YES];
    [self.avtarButton.layer setCornerRadius:23];
    self.avtarButton.exclusiveTouch = YES;
    self.deleteButton.exclusiveTouch = YES;
    self.linkButton.exclusiveTouch = YES;
    self.messageChatDelegate = delegate;
    self.data = commentData;
    self.selectStatusValue = selectStatus;
    NSString *content=[commentData stringForKey:@"content"];
    if (content==nil || [content isEqual:[NSNull null]]){
        content=@"";
    }
    NSInteger width = 0;
    NSInteger height = 0;
    NSMutableString *contentStl = [[[NSMutableString alloc]initWithString:content]autorelease];
    [contentStl replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
    [contentStl replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
	CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(MAXFLOAT, 13.0) withFont:[UIFont systemFontOfSize:13.0] withString:contentStl];
    if (size.width<=156) {
        if (size.width<=45) {
            width = 45;
        }else
        {
            width = size.width;
        }
        if ([[data stringForKey:@"type"] isEqualToString:@"1"] ||[[data stringForKey:@"type"] isEqualToString:@"2"] ||[[data stringForKey:@"type"] isEqualToString:@"3"])
        {
            if(size.width < 84){
                width = 84;
            }
        }
        height = 42;
    }else{
        size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(156.0f, MAXFLOAT) withFont:[UIFont systemFontOfSize:13.0] withString:content];
        width = 156;
        if (size.height>42) {
            height = size.height;
        }else{
            height = 42;
        }
    }
    
    NSInteger avtarButtonOffsetY= 0;
    if (height>42) {
        avtarButtonOffsetY = (height-42)/2;
    }
    if (editStatus) {
        [deleteButton setHidden:NO];
        self.contentLabel.frame=CGRectMake(246-width, 19, width, height);
        [self.avtarButton setFrame:CGRectMake(self.avtarButton.frame.origin.x, 16, self.avtarButton.frame.size.width, self.avtarButton.frame.size.height)];
        [self.deleteButton setFrame:CGRectMake(self.deleteButton.frame.origin.x, 16+avtarButtonOffsetY, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height)];
    }else {
        [deleteButton setHidden:YES];
        self.contentLabel.frame=CGRectMake(246-width, self.contentLabel.frame.origin.y, width, height);
        [self.avtarButton setFrame:CGRectMake(self.avtarButton.frame.origin.x, 16, self.avtarButton.frame.size.width, self.avtarButton.frame.size.height)];
        [self.deleteButton setFrame:CGRectMake(self.deleteButton.frame.origin.x, 16+avtarButtonOffsetY, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height)];
    }
    
    if (selectStatusValue) {
        [deleteButton setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateHighlighted];
    }else{
        [deleteButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateHighlighted];
    }
    
    [self.contentLabel setText:content];
    
    UIImage *image = nil;
    image = [[UIImage imageNamed:@"message_me_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:34];
    if (height>42) {
        [self.contentLabelBg setFrame:CGRectMake(contentLabel.frame.origin.x-16, contentLabel.frame.origin.y-4, contentLabel.frame.size.width+32, contentLabel.frame.size.height+8)];
    }else{
        [self.contentLabelBg setFrame:CGRectMake(contentLabel.frame.origin.x-10, contentLabel.frame.origin.y, contentLabel.frame.size.width+24, contentLabel.frame.size.height)];
    }

    [self.contentLabelBg setImage:image];
    
    NSString *imageUrl = [commentData stringForKey:@"user_avatar"];
    if (imageUrl!=nil && ![imageUrl isEqual:[NSNull null]]) {
        [avtarButton setImageWithURL:[NSURL URLWithString:imageUrl]
                    placeholderImage:[UIImage imageNamed:@"message_avtar"]];
    }
    
    NSString *messageDate=[commentData stringForKey:@"last_ts"];
    if (messageDate==nil || [messageDate isEqual:[NSNull null]]){
        messageDate=@"0";
    }
    [self.dateLabel setText:[BBTimeUtility stringDateWithFormat:@"yyyy-MM-dd HH:mm" withTimestamp:[messageDate doubleValue]]];
    CGFloat cellHeight = [BBMessageCellRightView calculateHeightWithContent:commentData];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,cellHeight)];
     self.backgroundColor = [UIColor  clearColor];
    
    if ([[data stringForKey:@"type"] isEqualToString:@"1"] ||[[data stringForKey:@"type"] isEqualToString:@"2"] ||[[data stringForKey:@"type"] isEqualToString:@"3"])
    {
        // 带有链接
        self.linkButton.hidden = NO;
        self.contentLabelBg.height += 28;
        self.linkButton.top = self.contentLabelBg.bottom - 27;
        self.linkButton.left = self.contentLabel.left;
    }
    else
    {
        self.linkButton.hidden = YES;
    }
    NSString *tip = [data stringForKey:@"tip"];
    if ([tip isNotEmpty])
    {
        CGSize tipSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(244, MAXFLOAT) withFont:[UIFont systemFontOfSize:12.0] withString:tip];
        CGFloat tipHeight = (int)tipSize.height+1+8;
        CGRect tipOriginRect = self.tipBackView.frame;
        tipOriginRect.size.height = tipHeight;
        tipOriginRect.origin.y = cellHeight-tipHeight-6;
        self.tipBackView.frame = tipOriginRect;
        self.tipBackView.hidden = NO;
        [self.tipLabel setText:tip];
    }
    else
    {
        self.tipBackView.hidden = YES;
    }
}
+(CGFloat)calculateHeightWithContent:(NSDictionary *)messageData{
    NSString *content=[messageData stringForKey:@"content"];
    if (content==nil || [content isEqual:[NSNull null]]){
        content=@"";
    }
    NSMutableString *contentStl = [[[NSMutableString alloc]initWithString:content]autorelease];
    [contentStl replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
    [contentStl replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [contentStl length])];
    NSInteger height = 0;
	CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(MAXFLOAT, 13.0f) withFont:[UIFont systemFontOfSize:13.0] withString:contentStl];
    if (size.width<=156) {
        height = 42;
    }else{
        size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(156.0, MAXFLOAT) withFont:[UIFont systemFontOfSize:13.0] withString:content];
        if (size.height>42) {
            height = size.height;
        }else{
            height = 42;
        }
    }
    if (height>42)
    {
        height =  72+height-42;
    }
    else
    {
        height = 72;
    }
    
    if ([[messageData stringForKey:@"type"] isEqualToString:@"1"] ||[[messageData stringForKey:@"type"] isEqualToString:@"2"] ||
        [[messageData stringForKey:@"type"] isEqualToString:@"3"])
    {
        // 带有链接
        height += 28;
    }
    
    NSString *tip = [messageData stringForKey:@"tip"];
    if ([tip isNotEmpty])
    {
        CGSize tipSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(244, MAXFLOAT) withFont:[UIFont systemFontOfSize:12.0] withString:tip];
        height += (6 + 8 + (int)tipSize.height+1);
    }
    return height;
}


- (IBAction)pressLinkButton:(id)sender
{
    if ([messageChatDelegate respondsToSelector:@selector(linkAction:)])
    {
        [messageChatDelegate linkAction:self.data];
    }
}

-(IBAction)selectAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (selectStatusValue) {
        [btn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateHighlighted];
        [messageChatDelegate delMessageId:[self.data stringForKey:@"message_id"]];
    }else{
        [btn setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateHighlighted];
        [messageChatDelegate addMessageId:[self.data stringForKey:@"message_id"]];
    }
    self.selectStatusValue = !self.selectStatusValue;
}
-(IBAction)avtarAction:(id)sender {
    [messageChatDelegate avtarAction:[self.data stringForKey:@"user_encode_id"] userName:[self.data stringForKey:@"nickname"]];

}
@end
