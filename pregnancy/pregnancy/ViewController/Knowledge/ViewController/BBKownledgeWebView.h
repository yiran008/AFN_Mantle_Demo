//
//  KownledgeWebView.h
//  konwledge-v5
//
//  Created by ZHENGLEI on 14-4-1.
//  Copyright (c) 2014年 ZHENGLEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBKownledgeWebView : UIWebView
- (id)initWithFrame:(CGRect)frame htmlData:(NSMutableDictionary *)data;
- (id)initWithFrame:(CGRect)frame htmlStr:(NSString *)htmlStr imagesStr:(NSString *)imagesStr;
-(void)loadHtMLSTring;
@end
