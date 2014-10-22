//
//  BBPlaceholderTextView.h
//  pregnancy
//
//  Created by apple on 13-5-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBPlaceholderTextView : UITextView
@property (copy, nonatomic) NSString *placeholder;


- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor;
- (UIColor *)placeholderTextColor;
- (void)setHasLine:(BOOL)hasLine;
@end
