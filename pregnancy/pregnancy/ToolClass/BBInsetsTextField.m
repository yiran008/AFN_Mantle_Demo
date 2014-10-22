//
//  BBInsetsTextField.m
//  pregnancy
//
//  Created by whl on 13-11-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBInsetsTextField.h"

@implementation BBInsetsTextField

//控制 placeHolder 的位置，左右缩 5
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 0 );
}

// 控制文本的位置，左右缩 5
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5, 0 );
}

@end
