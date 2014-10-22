//
//  BBWaterMarkViewController.h
//  pregnancy
//
//  Created by duyanqiu on 13-9-25.
//  Copyright (c) 2013年 Babytree.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBWaterMarkDelegate <NSObject>

@required
//
//回调得到加有水印图片
//
- (void)getWaterMarkImage:(UIImage*)image;

@end

@interface BBWaterMarkViewController : BaseViewController<UIScrollViewDelegate>
{
    BOOL pageControlUsed;
}

//
//是否外设水印
//
@property (nonatomic, assign) BOOL outSet;

//
//水印屏数（与外设水印一起用）
//
@property (nonatomic, assign) NSInteger pageNumber;


//
//图片预览
//
@property (nonatomic, strong) UIImageView *imageView;

//
//水印滚动视图
//
@property (nonatomic, strong) UIScrollView *waterMarkScroll;

//
//回调代理
//
@property (assign) id<BBWaterMarkDelegate> delegate;


@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;

//
//给水印图片添加文字
//
-(UIImage*)addWaterMarkText:(NSInteger)pageIndex;

@end

