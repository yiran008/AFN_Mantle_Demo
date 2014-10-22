//
//  BBKuaidiAlipayAccountViewController.h
//  pregnancy
//
//  Created by ZHENGLEI on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol alipayAccountModifySuccessDelegate <NSObject>
@optional
- (void)alipayAccountModifySuccessed:(NSString *)account;
@end

@interface BBKuaidiAlipayAccountViewController : BaseViewController
@property(retain,nonatomic)NSString * alipayAccount;
@property(assign,nonatomic)id<alipayAccountModifySuccessDelegate>delegate;
@end
