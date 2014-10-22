//
//  BBCustomsAlertView.h
//  pregnancy
//
//  Created by babytree on 9/16/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBCustomsAlertViewDelegate <NSObject>

-(void)clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface BBCustomsAlertView : UIView

@property (nonatomic,weak) id<BBCustomsAlertViewDelegate>delegate;

//初始化。。。
-(id)initWithTheTitle:(NSString *)theViewTitle WithTittles:(NSArray *)titles AndColors:(NSArray *)imageArray WithDelegate:(id)delegate;

//显示弹框

-(void)showWithImage:(NSString *)imageUrl;

-(void)showWithText:(NSString *)content;

@end
