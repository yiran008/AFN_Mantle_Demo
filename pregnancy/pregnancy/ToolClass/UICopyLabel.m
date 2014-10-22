//
//  UICopyLabel.m
//  pregnancy
//
//  Created by whl on 13-9-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "UICopyLabel.h"

@implementation UICopyLabel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
          [self attachTapHandler];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLabelBackgroundColor) name:UIMenuControllerDidHideMenuNotification object:nil];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self attachTapHandler];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLabelBackgroundColor) name:UIMenuControllerDidHideMenuNotification object:nil];
    }
    return self;
}

-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
    self.exclusiveTouch = YES;
    [touch release];
}


-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//还需要针对复制的操作覆盖两个方法：

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    self.backgroundColor = [UIColor clearColor];
    return (action == @selector(copy:));
}

//针对于响应方法的实现
-(void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

-(void)handleTap:(UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    UIMenuItem *copyLink = [[[UIMenuItem alloc] initWithTitle:@"复制全部内容"
                                                      action:@selector(copy:)]autorelease];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    self.backgroundColor = [UIColor lightGrayColor];
}

-(void)cancelLabelBackgroundColor
{
   self.backgroundColor = [UIColor clearColor];
}

@end
