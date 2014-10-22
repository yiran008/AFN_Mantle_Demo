//
//  BBAutoCalculationSize.m
//  pregnancy
//
//  Created by whl on 13-12-31.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBAutoCalculationSize.h"

@implementation BBAutoCalculationSize

+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString
{
    CGSize size = CGSizeZero;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        CGRect expectedFrame = [calculationString boundingRectWithSize:sizeRect
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        wordFont, NSFontAttributeName,
                                                                        nil]
                                                               context:nil];
        size = expectedFrame.size;
        size.height = ceil(size.height);
        size.width  = ceil(size.width);
#endif
        
    }
    else
    {
        size = [calculationString sizeWithFont:wordFont constrainedToSize:sizeRect lineBreakMode:0];
    }

    
    CGSize  modifySize = CGSizeMake(size.width, size.height);
    
    
    return modifySize;
}

+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString maxLine:(NSInteger)lineNum
{

    CGSize resultSize = [BBAutoCalculationSize autoCalculationSizeRect:sizeRect withFont:wordFont withString:calculationString];
    
    if (lineNum<=0)
    {
        return resultSize;
    }
    
    CGSize fontSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        fontSize = [calculationString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName,nil]];
    }
    else
    {
        fontSize = [calculationString sizeWithFont:wordFont];
    }
    
    if (resultSize.height > fontSize.height*lineNum)
    {
        return CGSizeMake(resultSize.width, fontSize.height*lineNum);
    }
    else
    {
        return resultSize;
    }
}
@end
