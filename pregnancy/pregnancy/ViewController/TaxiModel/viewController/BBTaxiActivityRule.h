//
//  BBTaxiActivityRule.h
//  pregnancy
//
//  Created by whl on 13-12-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTaxiActivityRule : BaseViewController

@property(nonatomic,strong) IBOutlet UIWebView *activityRule;

@property(nonatomic,strong) NSString *contentHtml;

@property(nonatomic,strong) NSString *rightStatus;

@property (nonatomic, strong) ASIFormDataRequest *competenceRequest;
@property (nonatomic, strong) MBProgressHUD *loadProgress;

@end
