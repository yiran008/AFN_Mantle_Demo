//
//  UILabel+TextAlignment.m
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "UILabel+TextAlignment.h"

@implementation UILabel (TextAlignment)
- (void)setBBTextAlignment:(NSTextAlignment)alignment
{
    if (alignment == NSTextAlignmentLeft) {
        [self setTextAlignment:0];
    }else if(alignment == NSTextAlignmentCenter) {
        [self setTextAlignment:1];
    }else if(alignment == NSTextAlignmentRight) {
        [self setTextAlignment:2];
    }
}

- (void)alignTop
{
    int appendNewLineCount = [self getAppendNewLineCount];
    for(int i=0; i<appendNewLineCount; i++)
    {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

- (void)alignBottom
{
    int appendNewLineCount = [self getAppendNewLineCount];
    for(int i=0; i<appendNewLineCount; i++)
    {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

- (int)getAppendNewLineCount
{
    CGSize oneLineSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        oneLineSize = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     self.font, NSFontAttributeName,
                                                     nil]];
    }
    else
    {
        oneLineSize = [self.text sizeWithFont:self.font];
    }
    oneLineSize = CGSizeMake(ceil(oneLineSize.width), ceil(oneLineSize.height));
    
    
    CGSize maxLabelSize = CGSizeMake(ceil(self.frame.size.width), oneLineSize.height * self.numberOfLines);
    
    
    CGSize textSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        CGRect expectedFrame = [self.text boundingRectWithSize:maxLabelSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                self.font, NSFontAttributeName,
                                                                nil]
                                                       context:nil];
        textSize = expectedFrame.size;
        #endif
    }
    else
    {
        textSize = [self.text sizeWithFont:self.font constrainedToSize:maxLabelSize lineBreakMode:self.lineBreakMode];
    }
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    
    
    int appendNewLineCount = (maxLabelSize.height - textSize.height) / oneLineSize.height;
    return appendNewLineCount;
}


@end
