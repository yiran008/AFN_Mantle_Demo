//
//  BBWebViewController.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-5-6.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBAdTapDelegate <NSObject>
- (void)adAction:(NSString *)title withUrl:(NSString *)url;
- (void)topicInnerUrl:(NSString *)url;
@end

@interface BBWebViewController : BaseViewController
@property(nonatomic,strong)IBOutlet UIWebView * webView;
@property(nonatomic,strong) NSString * htmlStr;
@property(nonatomic,strong) NSString * imagesStr;
@property(nonatomic,strong) NSString * ID;
@property(nonatomic,assign) id<BBAdTapDelegate>delegate;
@end
