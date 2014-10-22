//
//  BBTaxiCashBackView.h
//  pregnancy
//
//  Created by whl on 13-12-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTaxiCashBackView : BaseViewController
<
    ShareMenuDelegate,
    UMSocialUIDelegate
>

@property(nonatomic, strong) IBOutlet UILabel *cashBackLable;
@property(nonatomic, strong) NSString *cashBackString;
@property(nonatomic, strong) IBOutlet UIView *cashBackView;

@end
