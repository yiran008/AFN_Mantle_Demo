//
//  BBAutoCalculationSize.h
//  pregnancy
//
//  Created by whl on 13-12-31.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAutoCalculationSize : NSObject

+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString;

//增加了最大行数限制
+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString maxLine:(NSInteger)lineNum;
@end
