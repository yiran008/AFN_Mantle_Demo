//
//  BBShareMenuItem.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-7-24.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBShareMenuItem.h"

@interface BBShareMenuItem ()

@end

@implementation BBShareMenuItem

- (void)dealloc {
    [_shareTo release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithTitle:(NSString *)title image:(NSString *)imageName shareTo:(NSString *)shareTo{
    self = [super init];
    if (self) {
        self.shareTo = shareTo;
        [self addImgeViewWithImage:imageName];
        [self addTitleLabelWithTitle:title];
    }
    return self;
}

- (void)addImgeViewWithImage:(NSString *)imageName{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 45, 45)] autorelease];
    imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
    
}

- (void)addTitleLabelWithTitle:(NSString *)title {
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 55, 60, 15)] autorelease];
    // 适应保存到相册
    if([title length] >= 5)
    {
        titleLabel.width = 70;
    }
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1];
    [self addSubview:titleLabel];
}



@end
