//
//  HMImageWallView.m
//  lama
//
//  Created by mac on 13-10-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMImageWallView.h"

@interface HMImageWallView ()
{
    CGFloat s_ImageSideLength;
}
@end


@implementation HMImageWallView
@synthesize delegate;

@synthesize m_MaxCount;
@synthesize m_CountPerLine;

@synthesize m_ImageDataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_MaxCount = HMImageWallView_DefaultMaxCount;
        m_CountPerLine = HMImageWallView_DefaultCount;
        s_ImageSideLength = (self.width-((m_CountPerLine+1)*HMImageWallView_DefaultGap))/m_CountPerLine;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawWithArray:(NSArray *)array
{
    if (s_ImageSideLength == 0)
    {
        return;
    }
    
    [self removeAllSubviews];
    
    self.m_ImageDataArray = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:0];
    
    if ([m_ImageDataArray isNotEmpty])
    {
        NSInteger i = 0;
        for (NSData *imageData in m_ImageDataArray)
        {
            UIImage *image = [UIImage imageWithData:imageData];

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //btn.frame = CGRectMake(0, 0, s_ImageSideLength, s_ImageSideLength);
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            btn.tag = HMImageWallView_StartTag + i;
            [btn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
            i++;

            [btnArray addObject:btn];
            btn.exclusiveTouch = YES;
        }
        
        if (m_ImageDataArray.count < m_MaxCount)
        {
            UIImage *image = [UIImage imageNamed:@"imagewallview_addphoto_icon"];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //btn.frame = CGRectMake(0, 0, s_ImageSideLength, s_ImageSideLength);
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            btn.tag = HMImageWallView_StartTag+HMImageWallView_DefaultMaxCount+1;
            [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [btnArray addObject:btn];
            btn.exclusiveTouch = YES;
        }
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"imagewallview_addphoto_cameraicon"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //btn.frame = CGRectMake(0, 0, s_ImageSideLength, s_ImageSideLength);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        btn.tag = HMImageWallView_StartTag+HMImageWallView_DefaultMaxCount;
        [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnArray addObject:btn];
        btn.exclusiveTouch = YES;
    }
    
    [self drawBtnWithArray:btnArray];
}

- (void)drawBtnWithArray:(NSArray *)array
{
    CGFloat x = HMImageWallView_DefaultGap;
    CGFloat y = HMImageWallView_DefaultGap;
    CGFloat width = HMImageWallView_DefaultGap + s_ImageSideLength;
    CGFloat height = HMImageWallView_DefaultGap + s_ImageSideLength;
    NSInteger line = 0;
    
    for (NSInteger i = 0; i<array.count; i++)
    {
        if (line < i/m_CountPerLine)
        {
            line = i/m_CountPerLine;
            x = HMImageWallView_DefaultGap;
        }
        
        UIButton *btn = [array objectAtIndex:i];
        btn.frame = CGRectMake(x, y+(height*line), s_ImageSideLength, s_ImageSideLength);
        
        [self addSubview:btn];
        
        x += width;
    }
    
    self.height = height*(line+1)+HMImageWallView_DefaultGap;
}


#pragma mark -
#pragma mark Events

- (void)addImage:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(imageWallViewAddImage)])
    {
        [delegate imageWallViewAddImage];
    }
}

- (void)selectImage:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(imageWallView:didSelecte:)])
    {
        NSInteger index = btn.tag - HMImageWallView_StartTag;
        
        if (index < 0 || index >= m_MaxCount)
        {
            return;
        }
        
        NSData *imageData = [m_ImageDataArray objectAtIndex:index];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [delegate imageWallView:image didSelecte:index];
    }
}


@end
