//
//  HMTabBarItemView.m
//  HMHotMom
//
//  Created by songxf on 13-6-9.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTabBarItemView.h"
#import "JSBadgeView.h"


@implementation BBTabBarItemView
@synthesize m_titleLable;
@synthesize m_icon;
@synthesize m_tipLab;
@synthesize m_iconImages;



#define ITEM_NORMAL_COLOR  [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1.0f]
#define ITEM_HIGHLIGHT_COLOR [UIColor colorWithRed:255/255.f green:83/255.f blue:123/255.f alpha:1.0f]

//- (void)dealloc
//{
//    [m_iconImages release];
//    
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.m_icon = [[UIImageView alloc] init];
        self.m_icon.frame = CGRectMake((frame.size.width-34)/2, 5, 34, 27);
		[self addSubview:self.m_icon];
        
        self.m_titleLable = [[UILabel alloc] init];
        self.m_titleLable.frame = CGRectMake(0, frame.size.height-16, frame.size.width, 15);
        [self.m_titleLable setFont:[UIFont boldSystemFontOfSize:10.0]];
        [self.m_titleLable setTextAlignment:NSTextAlignmentCenter];
        self.m_titleLable.backgroundColor = [UIColor clearColor];
        self.m_titleLable.textColor = ITEM_NORMAL_COLOR;
        [self addSubview:self.m_titleLable];
        
        self.m_tipLab = [[UILabel alloc] initWithFrame:CGRectMake(43, 3, 12, 12)];
        m_tipLab.textAlignment = NSTextAlignmentCenter;
        m_tipLab.backgroundColor = [UIColor clearColor];
        m_tipLab.textColor = [UIColor whiteColor];
        m_tipLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_tipLab];
        m_tipLab.hidden = YES;

	}
    
    return self;
}

// 设置图标背景图组
- (void)setNormalImageName:(NSString *)normal
        highLightImageName:(NSString *)high
         selectedImageName:(NSString *)selected
{
    self.m_iconImages = [[NSArray alloc] initWithObjects:normal,high,selected, nil];
    [m_icon setImage:[UIImage imageNamed:[m_iconImages objectAtIndex:0]]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        [m_icon setImage:[UIImage imageNamed:[m_iconImages objectAtIndex:1]]];
        m_titleLable.textColor = ITEM_HIGHLIGHT_COLOR;
        if ((self.tag-ITEM_TAG_START == 1))
        {
            [self hideTipPoint];
        }
    }
    else
    {
        [m_icon setImage:[UIImage imageNamed:[m_iconImages objectAtIndex:0]]];
        m_titleLable.textColor = ITEM_NORMAL_COLOR;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}

- (void)showTipPoint
{
    m_tipLab.hidden = NO;
    m_tipLab.text = nil;
    m_tipLab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_point"]];
}

- (void)hideTipPoint
{
    m_tipLab.hidden = YES;
}
// 0 隐藏
- (void)setTipNumber:(NSInteger)number
{
    if (number>0)
    {
        m_tipLab.hidden = NO;
        m_tipLab.text = [NSString stringWithFormat:@"%d",number];
        if (number>9)
        {
            m_tipLab.text = @"9+";
        }
        m_tipLab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mtab_tipLab_icon"]];
    }
    else
    {
        [self hideTipPoint];
    }
}

- (BOOL)isTipShow
{
    return !m_tipLab.hidden;
}

@end
