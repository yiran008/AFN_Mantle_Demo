//
//  HMMulImageView.m
//  Test
//
//  Created by babytree on 1/6/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "HMMulImageView.h"
#import "UIImageView+WebCache.h"


@implementation HMMulImageView
{
    UIImageView *mulImageView1;
    UIImageView *mulImageView2;
    UIImageView *mulImageView3;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        mulImageView1 = [[UIImageView alloc] init];
        mulImageView2 = [[UIImageView alloc] init];
        mulImageView3 = [[UIImageView alloc] init];
        mulImageView1.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
        mulImageView2.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
        mulImageView3.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
        [self addSubview:mulImageView1];
        [self addSubview:mulImageView2];
        [self addSubview:mulImageView3];
    }
    
    return self;
}

- (void)refreshView:(NSArray *)array WithFrame:(CGRect)frame
{
    self.frame = CGRectMake(0, frame.origin.y, UI_SCREEN_WIDTH, frame.size.height+HMMulImageView_DefaultGap*2);

    self.imageArray = [NSArray arrayWithArray:array];
    
    NSInteger count = self.imageArray.count;
    if (count < 3 && count > 0)
    {
        mulImageView2.hidden = YES;
        mulImageView3.hidden = YES;
        if (self.isCenter)
        {
            mulImageView1.frame = CGRectMake((UI_SCREEN_WIDTH-frame.size.width)/2, HMMulImageView_DefaultGap, frame.size.width, frame.size.height);
        }
        else
        {
            mulImageView1.frame = CGRectMake(10, HMMulImageView_DefaultGap, frame.size.width, frame.size.height);
        }
        NSString *imageUrl = [self.imageArray objectAtIndex:0];
//        mulImageView1.clipsToBounds = YES;
//        mulImageView1.contentMode = UIViewContentModeScaleAspectFill;
        [mulImageView1 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    }
    else if (count >= 3)
    {
        mulImageView2.hidden = NO;
        mulImageView3.hidden = NO;
        
        // 右边图的宽和高
        NSInteger w1 = ((self.width-20) / 3) * 2;
        NSInteger h1 = frame.size.height;
        // 左边图的宽和高
        NSInteger w2 = (self.width-20) / 3;
        NSInteger h2 = frame.size.height / 2;
        mulImageView1.frame = CGRectMake(10, HMMulImageView_DefaultGap, w1, h1);
        mulImageView2.frame = CGRectMake(10 + w1 + 1, HMMulImageView_DefaultGap, w2 - 1, h2-1);
        mulImageView3.frame = CGRectMake(10 + w1 + 1, h2+HMMulImageView_DefaultGap, w2 - 1, h2);
        
        NSString *url1 = [self.imageArray objectAtIndex:0];
        mulImageView1.clipsToBounds = YES;
        mulImageView1.contentMode = UIViewContentModeScaleAspectFill;
        [mulImageView1 setImageWithURL:[NSURL URLWithString:url1] placeholderImage:nil];
        NSString *url2 = [self.imageArray objectAtIndex:1];
        mulImageView2.clipsToBounds = YES;
        mulImageView2.contentMode = UIViewContentModeScaleAspectFill;
        [mulImageView2 setImageWithURL:[NSURL URLWithString:url2] placeholderImage:nil];
        NSString *url3 = [self.imageArray objectAtIndex:2];
        mulImageView3.clipsToBounds = YES;
        mulImageView3.contentMode = UIViewContentModeScaleAspectFill;
        [mulImageView3 setImageWithURL:[NSURL URLWithString:url3] placeholderImage:nil];
    }
}

@end
