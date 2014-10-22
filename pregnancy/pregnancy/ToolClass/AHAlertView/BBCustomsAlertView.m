//
//  BBCustomsAlertView.m
//  pregnancy
//
//  Created by babytree on 9/16/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBCustomsAlertView.h"
#import "UIImageView+WebCache.h"

@implementation BBCustomsAlertView
{
    UIView *popView;
    UIView *faView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTheTitle:(NSString *)theViewTitle WithTittles:(NSArray *)titles AndColors:(NSArray *)imageArray WithDelegate:(id)delegate
{
    self = [super init];
    if(self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_pop_layer.png"]];
        self.userInteractionEnabled = YES;
        //设置弹窗
        popView = [[UIView alloc] initWithFrame:CGRectMake( 28, 500, 264, 285)];
        [self addSubview:popView];
        popView.userInteractionEnabled = YES;
        popView.backgroundColor = [UIColor whiteColor];
        UILabel *topView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 264, 36)];
        topView.backgroundColor = [UIColor colorWithHexString:@"ff628b"];
        topView.text = theViewTitle;
        topView.font = [UIFont boldSystemFontOfSize:17];
        topView.textColor = [UIColor whiteColor];
        topView.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:topView];
        
        faView=[[UIView alloc] initWithFrame:CGRectMake(0, 36, 264, 191)];
        faView.backgroundColor=[UIColor whiteColor];
        [popView addSubview:faView];
        
        if([titles isNotEmpty])
        {
            for(int i=0;i<titles.count;i++)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 10+i;
                if(titles.count == 1)
                {
                    button.frame = CGRectMake(78, 233, 108, 39);
                }
                else
                {
                    button.frame = CGRectMake(10+i*129, 233, 108, 39);
                }
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    if(i<imageArray.count)
                    {
                        [button setBackgroundImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
                    }
                    [button addTarget:self action:@selector(buttonsClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [popView addSubview:button];
                }
            }
            self.delegate = delegate;
        }
    
    return self;
}

#pragma mark - 显示弹窗
-(void)showWithImage:(NSString *)imageUrl
{
    if([imageUrl isNotEmpty])
    {
        [self adjustTheView];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 264, 191)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scroll.bounds];
        __weak UIImageView *image_view = imageView;
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
            
            image_view.frame = CGRectMake(0, 0, 264, image.size.height);
            scroll.contentSize = CGSizeMake(0, image.size.height);
            
        } failure:^(NSError *error) {
            
        }];
        [faView addSubview:scroll];
        [scroll addSubview:imageView];
        [self dynamicPopUp];
    }
}

-(void)showWithText:(NSString *)content
{
    if([content isNotEmpty])
    {
        [self adjustTheView];
        UITextView *textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        textView.frame = CGRectMake(0, 0, 264, 191);
        textView.editable = NO;
        textView.text = content;
        [faView addSubview:textView];
        [self dynamicPopUp];
    }
}


#pragma mark - 调整视图
-(void)adjustTheView
{
    if(!self.superview)
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    if([faView.subviews isNotEmpty])
    {
        [faView removeAllSubviews];
    }
    
}

#pragma mark - 动态弹出弹层

-(void)dynamicPopUp
{
    [UIView animateWithDuration:0.3 animations:^{
        
        popView.frame = CGRectMake( 28, 130, 264, 285);
    }];
}

#pragma mark -点击按钮触发事件
-(void)buttonsClicked: (UIButton *)btn
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButtonAtIndex:)])
    {
        [self.delegate clickedButtonAtIndex:btn.tag-10];
    }
    
    [self dismiss];
}

//取消弹框
-(void)dismiss
{
    self.hidden = YES;
    if(self.superview)
    {
        [self removeFromSuperview];
    }
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
