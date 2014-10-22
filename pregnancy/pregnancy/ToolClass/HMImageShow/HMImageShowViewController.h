//
//  HMImageShowViewController.h
//  lama
//
//  Created by mac on 13-10-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMImageShowViewDelegate <NSObject>

- (void)imageShowViewDidFinish:(NSArray *)imageDataArray isChanged:(BOOL)bChanged;
- (void)imageShowViewCancle;

@end


@interface HMImageShowViewController : BaseViewController
<
    UIGestureRecognizerDelegate,
    UIScrollViewDelegate
>
{
    BOOL _isDeleted;
    
    CGPoint s_GesturePoint;
}
@property (nonatomic, assign) id <HMImageShowViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIScrollView *m_ScrollView;
@property (retain, nonatomic) IBOutlet UIView *m_ToolBar;

@property (retain, nonatomic) IBOutlet UIButton *m_CancleBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_DeleteBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_OkBtn;


@property (nonatomic, retain) NSMutableArray *m_ImageDataArray;
@property (nonatomic, retain) NSMutableArray *m_ImageViewArray;
@property (nonatomic, assign) NSInteger m_Index;


- (IBAction)cancleClick:(id)sender;
- (IBAction)deleteClick:(id)sender;
- (IBAction)OkClick:(id)sender;


@end
