//
//  BBUmengAdView.m
//  pregnancy
//
//  Created by babytree babytree on 12-8-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBUmengAdScrollView.h"
#import "BBApp.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "BBStringLengthByCount.h"

@implementation BBUmengAdScrollView

- (id)initWithFrame:(CGRect)frame withKeywords:(NSString *)keywords withIsAtuoFill:(BOOL)isAtuoFill
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *appKey = nil;
        
//        if ([[BBApp getProjectCategory] isEqualToString:@"1"]) {
//            appKey =@"5045cd255270155e4400023c";
//        } else {
            appKey =@"4f8e312a52701573c9000041";
//        }
        
        _mTableView = [[UMUFPTableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain appkey:appKey slotId:nil currentViewController:nil];
        _mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.mAutoFill = isAtuoFill;
        if (keywords != nil) {
            _mTableView.mKeywords = keywords;
        }
        _mTableView.dataLoadDelegate = (id<UMUFPTableViewDataLoadDelegate>)self;
        
        
        
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [self addSubview:_mScrollView];
        
       
        //如果设置了tableview的dataLoadDelegate，请在viewController销毁时将tableview的dataLoadDelegate置空，这样可以避免一些可能的delegate问题，虽然我有在tableview的dealloc方法中将其置空


        [_mTableView requestPromoterDataInBackground];
    }
    return self;
}

#pragma mark - UMTableViewDataLoadDelegate methods

- (void)loadDataFailed {
    
}

- (void)UMUFPTableViewDidLoadDataFinish:(UMUFPTableView *)tableview promoters:(NSArray *)promoters {
    
    if ([promoters count] > 0)
    {
        [self reload];
    }
    else if ([_mTableView.mPromoterDatas count])
    {
        [self reload];
    }
    else 
    {
        [self loadDataFailed];
    }    
}

- (void)UMUFPTableView:(UMUFPTableView *)tableview didLoadDataFailWithError:(NSError *)error {
    
    if ([_mTableView.mPromoterDatas count])
    {
        [self reload];
    }
    else 
    {
        [self loadDataFailed];
    }
}

-(void)reload{
    
    for (UIView *view in [_mScrollView subviews]) {
        [view removeFromSuperview];
    }
    [_mScrollView setContentSize:CGSizeMake(60*[_mTableView.mPromoterDatas count],self.frame.size.height)];
    for (int i=0; i<[_mTableView.mPromoterDatas count]; i++) {
        NSDictionary *promoter = [_mTableView.mPromoterDatas objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.exclusiveTouch = YES;
        [button setFrame:CGRectMake(i*60, 0, 60.0f, 70.0f)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6.0f, 2.0f, 48.0f, 48.0f)];
        imageView.layer.cornerRadius = 9.0;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(6, 52, 48, 18)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor darkGrayColor]];
        [label setFont:[UIFont systemFontOfSize:12]];
        label.lineBreakMode = NSLineBreakByClipping;
        [button addSubview:imageView];
        [button addSubview:label];
        
        if ([promoter valueForKey:@"icon"]!=nil && ![[promoter valueForKey:@"icon"] isEqual:[NSNull null]]) {
            [imageView setImageWithURL:[NSURL URLWithString:[promoter valueForKey:@"icon"]]
                                placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        }
        label.text = [BBStringLengthByCount subStringByCount:[promoter valueForKey:@"title"] withCount:12];
        button.tag = i;
        [_mScrollView addSubview:button];
    }
    
}

- (IBAction)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag < [_mTableView.mPromoterDatas count]){
        NSDictionary *promoter = [_mTableView.mPromoterDatas objectAtIndex:button.tag];
        [_mTableView didClickPromoterAtIndex:promoter index:button.tag];
        [MobClick event:@"my_center_v2" label:@"应用推荐总点击"];
    }
}

@end
