//
//  BBOpenCtrlViewByString.h
//  pregnancy
//
//  Created by babytree on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBOpenCtrlViewByString : NSObject
//通过方法名称设置值
+(void)setValueByClass:(Class)class withMethodName:(NSString*)methodName withValue:(id)value;
//把字符串处理，字符串，数组（格式：[a,b,c,...]），字典(格式：{a:b,c:d,...}）
+(id)handlerContentString:(NSString*)content;
//通过字符串打开任意界面格式如下：类名？参数A=a&参数B=b...,a可以是字符串，数组（格式：[a,b,c,...]），字典(格式：{a:b,c:d,...}）
+(void)doAction:(NSString*)action withNavCtrl:(UINavigationController*)navCtrl;
@end
