//
//  BBNavigationLabel.m
//  pregnancy
//
//  Created by Wang Jun on 12-8-2.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBNavigationLabel.h"


@implementation BBNavigationLabel

+ (UILabel *)customNavigationLabel:(NSString *)title
{
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)] autorelease];
    [titleLabel setFont:[UIFont systemFontOfSize:22]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel setMinimumFontSize:14.0];
    [titleLabel setMinimumScaleFactor:14.0/22.0];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    return titleLabel;
}


+ (UILabel *)customKnowledgeNavigationLabel:(NSString *)title
{
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)] autorelease];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    return titleLabel;
}

+ (UILabel *)customNavigationLabel:(NSString *)title withWidth:(CGFloat)width
{
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 44)] autorelease];
    [titleLabel setFont:[UIFont systemFontOfSize:22]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel setMinimumFontSize:14.0];
    [titleLabel setMinimumScaleFactor:14.0/22.0];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    return titleLabel;
}

@end
