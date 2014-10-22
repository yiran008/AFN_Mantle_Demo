//
//  BBUmengAdView.h
//  pregnancy
//
//  Created by babytree babytree on 12-8-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMUFPTableView.h"
#import "UMTableViewCell.h"

@interface BBUmengAdView : UIView <UITableViewDelegate, UITableViewDataSource, UMUFPTableViewDataLoadDelegate> {
    
    UMUFPTableView *_mTableView;
    UIView *_mLoadingWaitView;
    UILabel *_mLoadingStatusLabel;
    UIImageView *_mNoNetworkImageView;
    UIActivityIndicatorView *_mLoadingActivityIndicator;  
}
- (id)initWithFrame:(CGRect)frame withKeywords:(NSString *)keywords withIsAtuoFill:(BOOL)isAtuoFill;
@end
