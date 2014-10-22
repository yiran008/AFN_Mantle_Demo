//
//  BBUmengAdView.h
//  pregnancy
//
//  Created by babytree babytree on 12-8-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMUFPTableView.h"

@interface BBUmengAdScrollView : UIView {
    
    UMUFPTableView *_mTableView;
    UIScrollView *_mScrollView;
}
-(void)reload;
- (id)initWithFrame:(CGRect)frame withKeywords:(NSString *)keywords withIsAtuoFill:(BOOL)isAtuoFill;
@end
