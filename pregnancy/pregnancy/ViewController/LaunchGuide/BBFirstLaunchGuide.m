//
//  BBFirstLaunchGuide.m
//  babyrecord
//
//  Created by Wang Chris on 12-7-27.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBFirstLaunchGuide.h"
#import "BBMainPage.h"
#import "BBApp.h"
#import "BBAppDelegate.h"
#import "BBAppConfig.h"
#import "YBBDateSelect.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "BBDueDateViewController.h"
#import "BBFatherInfo.h"
#import "BBChoseRole.h"

// 安装用户引导页数量
#define GUIDE_INSTALL_PAGE_NUMBER 4

// 升级用户引导页数量
#define GUIDE_UPGRADE_PAGE_NUMBER 1

#define SHARE_TO_SINA     1000
#define SHARE_TO_TENCENT  2000
#define SHARE_TO_QZONE    3000
#define SHARE_BUTTON_TAG    100

@interface BBFirstLaunchGuide ()

@property (nonatomic, retain)   NSString   *shareTo;
@property (assign) NSInteger  s_GuidePages;
@property (nonatomic, strong)  NSTimer  *s_launchTimer;

//label
@property (nonatomic, strong) UILabel *label_one;
@property (nonatomic, strong) UILabel *label_two;
@property (nonatomic, strong) UILabel *label_three;
@property (nonatomic, strong) UILabel *label_four;
@property (nonatomic, strong) UILabel *label_five;
@property (nonatomic, strong) UILabel *label_six;
@property (nonatomic, strong) UILabel *label_seven;


//image
@property (nonatomic, strong) UIImageView *image_first_one;
@property (nonatomic, strong) UIImageView *image_first_two;
@property (nonatomic, strong) UIImageView *image_first_three;
@property (nonatomic, strong) UIImageView *image_first_four;

@property (nonatomic, strong) UIImageView *image_second_one;
@property (nonatomic, strong) UIImageView *image_second_two;
@property (nonatomic, strong) UIImageView *image_second_three;
@property (nonatomic, strong) UIImageView *image_second_four;

@property (nonatomic, strong) UIImageView *image_third_one;
@property (nonatomic, strong) UIImageView *image_third_two;
@property (nonatomic, strong) UIImageView *image_third_three;
@property (nonatomic, strong) UIImageView *image_third_four;
@property (nonatomic, strong) UIImageView *image_third_five;

@property (nonatomic, strong) UIImageView *image_forth_one;
@property (nonatomic, strong) UIImageView *image_forth_two;
@property (nonatomic, strong) UIImageView *image_forth_three;
@property (nonatomic, strong) UIImageView *image_forth_four;
@property (nonatomic, strong) UIImageView *image_forth_five;
@property (nonatomic, strong) UIImageView *image_forth_six;
@property (nonatomic, strong) UIImageView *image_forth_seven;

@end

@implementation BBFirstLaunchGuide

@synthesize scrollView,pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;// default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setFrame:CGRectMake(0, 0, 320, 568)];
    
	//向scrollView中添加imageView
//    self.s_GuidePages = self.isNewUser ?  GUIDE_INSTALL_PAGE_NUMBER : GUIDE_UPGRADE_PAGE_NUMBER ;
    self.s_GuidePages = GUIDE_INSTALL_PAGE_NUMBER;
    
	for (NSUInteger i = 1; i <= self.s_GuidePages; i++)
	{
        UIView *guideView = [[UIView alloc]initWithFrame:CGRectMake((i-1)*320, 0, 320, 568)];
        guideView.backgroundColor = [UIColor clearColor];
        UIImageView *guideImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 350)];
        [guideImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_bg%d",i]]];
        [guideView addSubview:guideImage];
        guideView.tag = i;
        [scrollView addSubview:guideView];
	}
    scrollView.contentSize = CGSizeMake(320*self.s_GuidePages+1, 568);
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.backgroundColor = [UIColor clearColor];
    [startButton setImage:[UIImage imageNamed:@"guide_arrow"] forState:UIControlStateNormal];
    [startButton setFrame:CGRectMake(320*self.s_GuidePages - 42 , DEVICE_HEIGHT - 56, 32, 20)];
    [startButton addTarget:self action:@selector(enterAppAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:startButton];
    
    [self checkShouldShare];
    [pageControl setEnabled:NO];
    //定义pageControl
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = self.s_GuidePages;
    
    self.image_third_five = [self guideImage:@"guide_third_box" withFrame:CGRectMake(DEVICE_WIDTH + 66 , 296, 66, 66)];
    [self.view addSubview:self.image_third_five];

    self.image_forth_five = [self guideImage:@"guide_forth_car" withFrame:CGRectMake(DEVICE_WIDTH + 84, 276, 86, 84)];
    [self.view addSubview:self.image_forth_five];

    UIImageView *momImage = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_WIDTH - 114)/2, 186, 114, 180)];
    [momImage setImage:[UIImage imageNamed:@"pregnancy_mom"]];
    [self.view addSubview:momImage];

    [self addImageView];
    [self addLabelView];

    //iphone5适配
    if (IS_IPHONE5)
    {
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
        [self.scrollView setFrame:CGRectMake(0, 0, 320, 568)];
    }
    
    CGRect rect = pageControl.frame;
    rect.origin.y = DEVICE_HEIGHT - 45;
    pageControl.frame = rect;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self guideFirstShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.s_launchTimer invalidate];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view.layer removeAllAnimations];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addLabelView
{
    self.label_one = [self guideLabel:@"发现附近的宝妈" withFont:[UIFont systemFontOfSize:22.0]];
    self.label_two = [self guideLabel:@"有我陪着你，有你陪着我" withFont:[UIFont systemFontOfSize:15.0]];
    self.label_three = [self guideLabel:@"我要当女神" withFont:[UIFont systemFontOfSize:22.0]];
    self.label_four = [self guideLabel:@"发帖盖楼，就能让你万众瞩目" withFont:[UIFont systemFontOfSize:15.0]];
    self.label_five = [self guideLabel:@"多款超强大孕育工具" withFont:[UIFont systemFontOfSize:22.0]];
    self.label_six = [self guideLabel:@"能不能吃、月子食谱、宝宝辅食..." withFont:[UIFont systemFontOfSize:15.0]];
    self.label_seven = [self guideLabel:@"快乐孕期改名啦" withFont:[UIFont systemFontOfSize:22.0]];

    [self.view addSubview:self.label_one];
    [self.view addSubview:self.label_two];
    [self.view addSubview:self.label_three];
    [self.view addSubview:self.label_four];
    [self.view addSubview:self.label_five];
    [self.view addSubview:self.label_six];
    [self.view addSubview:self.label_seven];
}

-(void)addImageView
{
    self.image_first_one = [self guideImage:@"guide_first_ma" withFrame:CGRectMake(88, -80, 64, 80)];
    self.image_first_two = [self guideImage:@"guide_first_mom" withFrame:CGRectMake(42, -54, 43, 54)];
    self.image_first_three = [self guideImage:@"guide_first_math" withFrame:CGRectMake(244, -50, 40, 50)];
    self.image_first_four = [self guideImage:@"guide_first_tree" withFrame:CGRectMake(52, -68, 50, 68)];
    
    self.image_second_one = [self guideImage:@"guide_second_ring" withFrame:CGRectMake(130, -50, 64, 50)];
    self.image_second_two = [self guideImage:@"guide_second_necklace" withFrame:CGRectMake(90, -22, 30, 22)];
    self.image_second_three = [self guideImage:@"guide_second_mofabang" withFrame:CGRectMake(146, -60, 26, 60)];
    self.image_second_four = [self guideImage:@"guide_second_star" withFrame:CGRectMake(92, -12, 8, 12)];

    self.image_third_one = [self guideImage:@"guide_third_music" withFrame:CGRectMake(26, -60, 60, 60)];
    self.image_third_two = [self guideImage:@"guide_third_circle" withFrame:CGRectMake(58, -60, 60, 60)];
    self.image_third_three = [self guideImage:@"guide_third_baby" withFrame:CGRectMake(258, -60, 60, 60)];
    self.image_third_four = [self guideImage:@"guide_third_lunch" withFrame:CGRectMake(184, -40, 40, 40)];


    self.image_forth_one = [self guideImage:@"guide_forth_color_one" withFrame:CGRectMake(220, -16, 16, 16)];
    self.image_forth_two = [self guideImage:@"guide_forth_color_two" withFrame:CGRectMake(261, -48, 24, 48)];
    self.image_forth_three = [self guideImage:@"guide_forth_color_third" withFrame:CGRectMake(48, -20, 20, 20)];
    self.image_forth_four = [self guideImage:@"guide_forth_color_four" withFrame:CGRectMake(50, -24, 24, 24)];
    self.image_forth_six = [self guideImage:@"guide_forth_word" withFrame:CGRectMake(23, -68, 274, 68)];
    self.image_forth_seven = [self guideImage:@"guide_forth_naiping" withFrame:CGRectMake(98, -24, 20, 24)];
    
    [self.view addSubview:self.image_first_one];
    [self.view addSubview:self.image_first_two];
    [self.view addSubview:self.image_first_three];
    [self.view addSubview:self.image_first_four];

    [self.view addSubview:self.image_second_one];
    [self.view addSubview:self.image_second_two];
    [self.view addSubview:self.image_second_three];
    [self.view addSubview:self.image_second_four];
    
    [self.view addSubview:self.image_third_one];
    [self.view addSubview:self.image_third_two];
    [self.view addSubview:self.image_third_three];
    [self.view addSubview:self.image_third_four];
    
    [self.view addSubview:self.image_forth_one];
    [self.view addSubview:self.image_forth_two];
    [self.view addSubview:self.image_forth_three];
    [self.view addSubview:self.image_forth_four];
    [self.view addSubview:self.image_forth_six];
    [self.view addSubview:self.image_forth_seven];
}

-(UILabel*)guideLabel:(NSString*)text withFont:(UIFont*)font
{
    UILabel *guideLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40)];
    guideLabel.textColor = [UIColor colorWithHex:0xa38f92];
    [guideLabel setFont:font];
    guideLabel.textAlignment = NSTextAlignmentCenter;
    guideLabel.text = text;
    guideLabel.backgroundColor = [UIColor clearColor];
    return guideLabel;
}

-(UIImageView *)guideImage:(NSString*)imageName withFrame:(CGRect)rect
{
    UIImageView *guideImage = [[UIImageView alloc]initWithFrame:rect];
    [guideImage setImage:[UIImage imageNamed:imageName]];
    return guideImage;
}

-(void)guideFirstShow
{
    [self showView:self.label_one toFrame:CGRectMake(0, 386, 320, 40) during:0.5];
    [self showView:self.label_two toFrame:CGRectMake(0, 416, 320, 40) during:0.5];
    [self showView:self.image_first_one toFrame:CGRectMake(88, 44, 64, 80) during:0.25];
    [self showView:self.image_first_two toFrame:CGRectMake(42, 160, 43, 54) during:0.5];
    [self showView:self.image_first_three toFrame:CGRectMake(244, 232, 40, 50) during:0.75];
    [self showView:self.image_first_four toFrame:CGRectMake(52, 262, 50, 68) during:0];
    
}

-(void)guideFirstHide
{
    [self hiddenView:self.label_one toFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40) during:0.5];
    [self hiddenView:self.label_two toFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40) during:0.5];
    [self hiddenView:self.image_first_one toFrame:CGRectMake(88, -80, 64, 80) during:0.5];
    [self hiddenView:self.image_first_two toFrame:CGRectMake(42, -54, 43, 54) during:0.5];
    [self hiddenView:self.image_first_three toFrame:CGRectMake(244, -50, 40, 50) during:0.5];
    [self hiddenView:self.image_first_four toFrame:CGRectMake(52, -68, 50, 68) during:0.5];
}


-(void)guideSecondShow
{
    [self showView:self.label_three toFrame:CGRectMake(0, 386, 320, 40) during:0.5];
    [self showView:self.label_four toFrame:CGRectMake(0, 416, 320, 40) during:0.5];
    [self showView:self.image_second_one toFrame:CGRectMake(130, 154, 64, 50) during:0.4];
    [self showView:self.image_second_two toFrame:CGRectMake(146, 263, 30, 22) during:0.1];
    [self showView:self.image_second_three toFrame:CGRectMake(90, 226, 26, 60) during:0.75];
    [self showView:self.image_second_four toFrame:CGRectMake(92, 230, 8, 12) during:0];
    
    [self shashuoAnimation:self.image_second_four withDuration:0.2];

}

-(void)guideSecondHide
{
    [self.image_second_four.layer removeAllAnimations];
    [self hiddenView:self.label_three toFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40) during:0.5];
    [self hiddenView:self.label_four toFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40) during:0.5];
    [self hiddenView:self.image_second_one toFrame:CGRectMake(130, -50, 64, 50) during:0.5];
    [self hiddenView:self.image_second_two toFrame:CGRectMake(146, -22, 30, 22) during:0.5];
    [self hiddenView:self.image_second_three toFrame:CGRectMake(90, -60, 26, 60) during:0.5];
    [self hiddenView:self.image_second_four toFrame:CGRectMake(92, -12, 8, 12) during:0];

}

-(void)guideThirdShow
{
    [self showView:self.label_five toFrame:CGRectMake(0, 386, 320, 40) during:0.5];
    [self showView:self.label_six toFrame:CGRectMake(0, 416, 320, 40) during:0.5];    
    [self showView:self.image_third_one toFrame:CGRectMake(26, 220, 60, 60) during:0.5];
    [self showView:self.image_third_two toFrame:CGRectMake(58, 50, 60, 60) during:0.5];
    [self showView:self.image_third_three toFrame:CGRectMake(258, 190, 60, 60) during:0.5];
    [self showView:self.image_third_four toFrame:CGRectMake(184, 94, 40, 40) during:0.5];
    [self showView:self.image_third_five toFrame:CGRectMake(200, 296, 66, 66) during:0.5];
    
}

-(void)guideThirdHide
{
    [self hiddenView:self.label_five toFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40) during:0.5];
    [self hiddenView:self.label_six toFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40) during:0.5];
    [self hiddenView:self.image_third_one toFrame:CGRectMake(26, -60, 60, 60) during:0.5];
    [self hiddenView:self.image_third_two toFrame:CGRectMake(58, -60, 60, 60) during:0.5];
    [self hiddenView:self.image_third_three toFrame:CGRectMake(258, -60, 60, 60) during:0.5];
    [self hiddenView:self.image_third_four toFrame:CGRectMake(184, -40, 40, 40) during:0.5];
    [self hiddenView:self.image_third_five toFrame:CGRectMake(DEVICE_WIDTH + 66, 296, 66, 66) during:0.5];
}


-(void)guideFourthShow
{
    [self showView:self.label_seven toFrame:CGRectMake(0, 386, 320, 40) during:0.5];
    [self showView:self.image_forth_one toFrame:CGRectMake(220, 84, 16, 16) during:0.5];
    [self showView:self.image_forth_two toFrame:CGRectMake(261, 134, 24, 48) during:0.5];
    [self showView:self.image_forth_three toFrame:CGRectMake(48, 198, 20, 20) during:0.5];
    [self showView:self.image_forth_four toFrame:CGRectMake(50, 334, 24, 24) during:0.5];
    [self showView:self.image_forth_five toFrame:CGRectMake(210, 280, 86, 84) during:0.5];
    [self showView:self.image_forth_six toFrame:CGRectMake(23, 26, 274, 68) during:0.5];
    [self showView:self.image_forth_seven toFrame:CGRectMake(98, 250, 20, 24) during:0.5];
    [self timerGuideEnterApp];
}

-(void)guideFourthHide
{
    [self hiddenView:self.label_seven toFrame:CGRectMake(0, DEVICE_HEIGHT + 44, 320, 40) during:0.5];
    [self hiddenView:self.image_forth_one toFrame:CGRectMake(220, -16, 16, 16) during:0.5];
    [self hiddenView:self.image_forth_two toFrame:CGRectMake(261, -48, 24, 48) during:0.5];
    [self hiddenView:self.image_forth_three toFrame:CGRectMake(48, -20, 20, 20) during:0.5];
    [self hiddenView:self.image_forth_four toFrame:CGRectMake(50, -24, 24, 24) during:0.5];
    [self hiddenView:self.image_forth_five toFrame:CGRectMake(DEVICE_WIDTH + 84, 276, 86, 84) during:0.5];
    [self hiddenView:self.image_forth_six toFrame:CGRectMake(23, -68, 274, 68) during:0.5];
    [self hiddenView:self.image_forth_seven toFrame:CGRectMake(98, -24, 20, 24) during:0.5];
}


-(void)fadeAnimationFor:(UIImageView *)currentImageView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.f];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObject:animation];
    group.delegate = self;
    group.duration = 1;
    group.removedOnCompletion = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [currentImageView.layer addAnimation:group forKey:nil];
}


- (void)popInAnimationForDuration:(NSTimeInterval)duration withAnimationView:(UIImageView *)currentImageView
{
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.85f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = duration * .4f;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeIn.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scale, fadeIn, nil];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [currentImageView.layer addAnimation:group forKey:nil];
}

- (void)windWithView:(UIView *)view times:(NSInteger)times count:(NSInteger)count
{
    if (times == count)
    {
        return;
    }

    [UIView animateWithDuration:0.5 animations:^{
        view.layer.transform = CATransform3DMakeRotation(M_PI/6, 0, 0, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            view.layer.transform = CATransform3DMakeRotation(-M_PI/6, 0, 0, 1);
        } completion:^(BOOL finished) {
            [self windWithView:view times:times count:count+1];
        }];
    }];
}


-(float)radians:(float)degrees
{
    return degrees * M_PI/180;
}

-(void)timerGuideEnterApp
{
    if (self.s_launchTimer)
    {
        [self.s_launchTimer invalidate];
        self.s_launchTimer = nil;
    }
    self.s_launchTimer =  [NSTimer  scheduledTimerWithTimeInterval:7 target:self selector:@selector(enterAppAction:) userInfo:nil repeats:NO];
}


-(void)shashuoAnimation:(UIImageView*)currentImageView withDuration:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:duration];
    [animation setAutoreverses:YES];    //这里设置是否恢复初始的状态,
    [animation setRepeatCount:INFINITY];   //设置重复次数
    [animation setFromValue:[NSNumber numberWithInt:1.0]];  //设置透明度从1 到 0
    [animation setToValue:[NSNumber numberWithInt:0.0]];
    [currentImageView.layer addAnimation:animation forKey:@"opatity-animation"];
}


-(void)showView:(UIView *)view toFrame:(CGRect)frame during:(float)time
{
    [UIView beginAnimations:@"show_view" context:nil];
    
    [UIView setAnimationDuration:time];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    view.hidden = NO;
    
    view.layer.opacity = 1.0;
    
    view.frame = frame;
    
    [UIView commitAnimations];
    
}

- (void)hiddenView:(UIView *)view toFrame:(CGRect)frame during:(float)time
{
    
    [UIView beginAnimations:@"hide_view" context:nil];
    
    [UIView setAnimationDuration:time];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    view.frame = frame;
    
    view.layer.opacity = 0.0;
    
    [UIView commitAnimations];
    
}

-(void)moveView:(UIView *)view toFrame:(CGRect)frame during:(float)time
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:time];
    view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - UIScroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage = (int)(self.scrollView.contentOffset.x + 180)/320;
    
    if (self.scrollView.contentOffset.x>=320*(self.s_GuidePages-1)+20)
    {
        close = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.s_launchTimer)
    {
        [self.s_launchTimer invalidate];
        self.s_launchTimer = nil;
    }
    
    if (pageControl.currentPage == 0)
    {
        [self guideSecondHide];
        [self guideThirdHide];
        [self guideFourthHide];
        [self guideFirstShow];
    }
    if (pageControl.currentPage == 1)
    {
        [self guideFirstHide];
        [self guideThirdHide];
        [self guideFourthHide];
        [self guideSecondShow];
    }
    if (pageControl.currentPage == 2)
    {
        [self  guideFirstHide];
        [self guideSecondHide];
        [self guideFourthHide];
        [self guideThirdShow];
    }
    if (pageControl.currentPage == 3)
    {
        [self guideFirstHide];
        [self guideSecondHide];
        [self guideThirdHide];
        [self guideFourthShow];
    }

    if (close)
    {
        [self enterAppAction:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - UIControl Event Handle Method


- (IBAction)enterAppAction:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self shareApplication];
    BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([BBUser getNewUserRoleState] == BBUserRoleStateNone)
    {
        [appDelegate enterChoseRolePage];
    }
    else
    {
        [appDelegate enterMainPage];

    }
}

#pragma mark - share 

- (void)checkShouldShare
{
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina])
    {
        [self addShareButtonWithType:SHARE_TO_SINA];
        return;
    }
    
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToTencent])
    {
        [self addShareButtonWithType:SHARE_TO_TENCENT];
        return;
    }

}

- (void)addShareButtonWithType:(int)shareType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.frame = CGRectMake(320*(self.s_GuidePages-1) + ((320-120)/2), DEVICE_HEIGHT - 54, 16, 16);
    [button setImage:[UIImage imageNamed:@"share_select"] forState:UIControlStateNormal];
    button.selected = YES;
    button.tag = SHARE_BUTTON_TAG;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(changeShareState:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(button.left + 18, DEVICE_HEIGHT - 56, 120, 21)];
    shareLabel.textColor = [UIColor colorWithHex:0xa38f92];
    shareLabel.textAlignment = NSTextAlignmentLeft;
    [shareLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.scrollView addSubview:shareLabel];
    
    switch (shareType) {
        case SHARE_TO_SINA:
            shareLabel.text = @"分享至新浪微博";
            self.shareTo = UMShareToSina;
            break;
        case SHARE_TO_TENCENT:
            shareLabel.text = @"分享至腾讯微博";
            self.shareTo = UMShareToTencent;
            break;
        default:
            break;
    }
}

- (void)changeShareState:(id)sender {
    UIButton *shareButton = (UIButton *)sender;
    shareButton.selected = !shareButton.selected;
    if (shareButton.selected) {
        [shareButton setImage:[UIImage imageNamed:@"share_select"] forState:UIControlStateNormal];
    }else {
        [shareButton setImage:[UIImage imageNamed:@"share_no_select"] forState:UIControlStateNormal];
    }
    
}

- (void)shareApplication {
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:SHARE_BUTTON_TAG];
    
    if (button) {
        if (button.selected) {
            NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
            NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
            NSString *shareContent = [NSString  stringWithFormat:@"宝宝树孕育客户端V%@上线了！使用更便捷，看贴更方便。下载地址：%@（分享自@宝宝树孕育",versionNum,SHARE_DOWNLOAD_URL];
            [[UMSocialControllerService defaultControllerService].socialDataService postSNSWithTypes:[NSArray arrayWithObject:self.shareTo] content:shareContent image:nil location:nil urlResource:nil completion:^(UMSocialResponseEntity *response) {
            }];
        }
    }
    
}

@end
