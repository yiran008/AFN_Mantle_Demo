//
//  BBMainPagePregnantTimingView.m
//  BBProgressView
//
//  Created by liumiao on 5/12/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "BBMainPagePregnantTimingView.h"
#import "DAMainPageCircularProgressView.h"
#import "BBCircleView.h"
#import "PulsingHaloLayer.h"
@interface BBMainPagePregnantTimingView ()
@property (nonatomic, strong)DAMainPageCircularProgressView *s_ProgressView;
@property (nonatomic, strong)UIView *s_BottomView;
@property (nonatomic, strong)UILabel *s_PregnantWeekLabel;
@property (nonatomic, strong)UILabel *s_PregnantCountDownLabel;
@property (nonatomic, strong)UIButton *s_ActionButton;
@property (nonatomic, strong)PulsingHaloLayer *s_BlinkLayer;
@end

@implementation BBMainPagePregnantTimingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.s_BottomView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-36, 320, 36)];
        [self addSubview:self.s_BottomView];
        [self.s_BottomView setBackgroundColor:[UIColor colorWithHex:0xff537b]];
        
        BBCircleView *circleView = [[BBCircleView alloc]initWithFrame:CGRectMake(12, 0, 62, 62)];
        [self addSubview:circleView];
        
        self.s_ProgressView = [[DAMainPageCircularProgressView alloc]initWithFrame:CGRectMake(12+(62-56)/2, (62-56)/2, 56, 56)];
        [self.s_ProgressView setTrackTintColor:RGBColor(255,255,255,0.1)];
        [self.s_ProgressView setThicknessRatio:0.2];
        
        [self addSubview:self.s_ProgressView];
        
        self.s_ActionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.s_ActionButton setCenter:self.s_ProgressView.center];
        [self.s_ActionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        self.s_ActionButton.exclusiveTouch = YES;
        [self addSubview:self.s_ActionButton];
        
        self.s_PregnantWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 3, 80, 30)];
        [self.s_BottomView addSubview:self.s_PregnantWeekLabel];
        [self.s_PregnantWeekLabel setTextColor:[UIColor whiteColor]];
        [self.s_PregnantWeekLabel setBackgroundColor:[UIColor clearColor]];
        
        self.s_PregnantCountDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 3, 160, 30)];
        [self.s_BottomView addSubview:self.s_PregnantCountDownLabel];
        [self.s_PregnantCountDownLabel setBackgroundColor:[UIColor clearColor]];
        [self.s_PregnantCountDownLabel setTextColor:[UIColor whiteColor]];
        self.s_BlinkLayer = [PulsingHaloLayer layer];
        self.s_BlinkLayer.backgroundColor = PregnancyColor.CGColor;
        self.s_BlinkLayer.animationDuration = 1.8;
        //self.s_BlinkLayer.pulseInterval = 0.1;
        self.s_BlinkLayer.radius = 45;
        self.s_BlinkLayer.position = self.s_ActionButton.center;
    }
    return self;
}

-(void)reload
{
    //获取怀孕天数
    NSInteger pregnancyDays = [BBPregnancyInfo daysOfPregnancy];
    pregnancyDays = (pregnancyDays>MAX_PREGMENT_DAYS) ? MAX_PREGMENT_DAYS : pregnancyDays;
    
    float progress = 0;
    if (pregnancyDays<7)
    {
        progress = 0.025f;
    }
    else
    {
        progress = (float)pregnancyDays/MAX_PREGMENT_DAYS;
    }
    [self.s_ProgressView setProgress:progress animated:NO];
    //调整计时label的内容样式
    NSString *content1Text = @"距离宝宝出生还有";
    NSInteger length1 = [content1Text length];
    
    NSString *content2Text = [NSString stringWithFormat:@"%d",MAX_PREGMENT_DAYS-pregnancyDays];
    NSInteger length2 = [content2Text length];
    
    NSString *content3Text = @"天";
    NSInteger length3 = [content3Text length];
    
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",content1Text,content2Text,content3Text]];
    [contentText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:12]
                        range:NSMakeRange(0, length1)];
    
    [contentText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:24]
                        range:NSMakeRange(length1, length2)];
    
    [contentText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:12]
                        range:NSMakeRange(length1+length2, length3)];
    
    self.s_PregnantCountDownLabel.attributedText = contentText;
    
    
    NSString *week1Text = nil;
    NSString *week2Text = nil;
    if(pregnancyDays/7 == 0)
    {
        week1Text = [NSString stringWithFormat:@"%d",pregnancyDays%7];
        week2Text = @"天";
    }
    else
    {
        week1Text = [NSString stringWithFormat:@"%d",pregnancyDays/7];
        if(pregnancyDays%7 == 0)
        {
            week2Text = @"周";
        }
        else
        {
            week2Text = [NSString stringWithFormat:@"周+%d天",pregnancyDays%7];
        }
    }
    NSInteger weeklength1 = [week1Text length];
    NSInteger weeklength2 = [week2Text length];
    NSMutableAttributedString *weekText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",week1Text,week2Text]];
    [weekText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:24]
                        range:NSMakeRange(0, weeklength1)];
    
    [weekText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:12]
                        range:NSMakeRange(weeklength1, weeklength2)];
    self.s_PregnantWeekLabel.attributedText = weekText;
    
    //根据规则，36周之后才会出现宝宝出生button
    if (pregnancyDays/7 < 38)
    {
        [self showBabyBornButton:NO animated:NO];
    }
    else if(pregnancyDays/7>=38 && pregnancyDays/7<40)
    {
        [self showBabyBornButton:YES animated:NO];
    }
    else
    {
        [self showBabyBornButton:YES animated:YES];
    }
}
-(void)showBabyBornButton:(BOOL)show animated:(BOOL)animated
{
//    [self.s_ActionButton.layer removeAnimationForKey:@"kFTAnimationPopIn"];
    [self.s_BlinkLayer removeFromSuperlayer];
    if (show)
    {
        //显示报喜按钮
        [self.s_ActionButton setImage:nil forState:UIControlStateNormal];
        [self.s_ActionButton setTitle:@"报喜" forState:UIControlStateNormal];
        [self.s_ActionButton setBackgroundImage:[UIImage imageNamed:@"baoxiButtonBg"] forState:UIControlStateNormal];
        [self.s_ActionButton setUserInteractionEnabled:YES];
        if (animated)
        {
            //显示报喜动态效果
//            float duration = 0.f;
//            CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//            scale.duration = duration;
//            scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
//                            [NSNumber numberWithFloat:1.2f],
//                            [NSNumber numberWithFloat:.85f],
//                            [NSNumber numberWithFloat:1.f],
//                            nil];
//            
////            CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
////            fadeIn.duration = duration * .4f;
////            fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
////            fadeIn.toValue = [NSNumber numberWithFloat:1.f];
////            fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
////            fadeIn.fillMode = kCAFillModeForwards;
//            
//            CAAnimationGroup *group = [CAAnimationGroup animation];
//            group.repeatCount = INFINITY;
//            group.autoreverses = YES;
//            group.delegate = nil;
//            group.animations = [NSArray arrayWithObjects:scale, nil];
//            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            [self.s_ActionButton.layer addAnimation:group forKey:@"kFTAnimationPopIn"];
            [self.layer insertSublayer:self.s_BlinkLayer below:self.s_ActionButton.layer];
        }
    }
    else
    {
        //显示宝宝图片

        [self.s_ActionButton setTitle:nil forState:UIControlStateNormal];
        [self.s_ActionButton setImage:[UIImage imageNamed:@"mainPageBaby"] forState:UIControlStateNormal];
        [self.s_ActionButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.s_ActionButton setUserInteractionEnabled:NO];
    }
}
-(void)displayProgressAnimation
{
    NSInteger pregnancyDays = [BBPregnancyInfo daysOfPregnancy];
    pregnancyDays = (pregnancyDays>MAX_PREGMENT_DAYS) ? MAX_PREGMENT_DAYS : pregnancyDays;
    
    float progress = 0;
    if (pregnancyDays<7)
    {
        progress = 0.025f;
    }
    else
    {
        progress = (float)pregnancyDays/MAX_PREGMENT_DAYS;
    }
    [self.s_ProgressView setProgress:progress animated:YES];
}
-(void)addButtonActionWithTarget:(id)target selector:(SEL)selector
{
    [self.s_ActionButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
