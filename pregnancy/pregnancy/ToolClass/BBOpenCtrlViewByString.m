//
//  BBOpenCtrlViewByString.m
//  pregnancy
//
//  Created by babytree on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBOpenCtrlViewByString.h"

@implementation BBOpenCtrlViewByString
//通过方法名称设置值
+(void)setValueByClass:(Class)class withMethodName:(NSString*)methodName withValue:(id)value{
    SEL selector = NSSelectorFromString(methodName);
    if ([class respondsToSelector:selector]) {
        [class performSelector:selector withObject:value];
    }
}

//把字符串处理，字符串，数组（格式：[a,b,c,...]），字典(格式：{a:b,c:d,...}）
+(id)handlerContentString:(NSString*)content{
    if([content hasPrefix:@"{"]){
        NSMutableDictionary *dicDate = [[[NSMutableDictionary alloc]init]autorelease];
        NSString *contentStr = [content stringByReplacingOccurrencesOfString:@"{" withString:@""];
        contentStr = [contentStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSArray *pramsArray = [contentStr componentsSeparatedByString:@","];
        NSUInteger size = [pramsArray count];
        if(size > 0){
            for (int i = 0; i < size; i++) {
                NSArray *tempArray = [[pramsArray objectAtIndex:i] componentsSeparatedByString:@":"];
                if ([tempArray count]>1) {
                    [dicDate setValue:[tempArray objectAtIndex:1] forKey:[tempArray objectAtIndex:0]];
                }
            }
        }
        return dicDate;
    }else if([content hasPrefix:@"["]){
        NSString *contentStr = [content stringByReplacingOccurrencesOfString:@"[" withString:@""];
        contentStr = [contentStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
        return [contentStr componentsSeparatedByString:@","];
    }   
    return content;
}
//通过字符串打开任意界面格式如下：类名？参数A=a&参数B=b...,a可以是字符串，数组（格式：[a,b,c,...]），字典(格式：{a:b,c:d,...}）
+(void)doAction:(NSString*)action withNavCtrl:(UINavigationController*)navCtrl{
    NSArray *dataArray = [action componentsSeparatedByString:@"??"];
    NSArray *pramsArray = nil;
    NSString *className = nil;
    if([dataArray count]>0){
        className= [dataArray objectAtIndex:0];
    }else{
        return;
    }
    UIViewController *viewController = [[[NSClassFromString(className) alloc] initWithNibName:className bundle:nil]autorelease];
    if([dataArray count]>1){
        pramsArray = [[dataArray objectAtIndex:1] componentsSeparatedByString:@"&&"];
        NSUInteger size = [pramsArray count];
        if(size > 0){
            for (int i = 0; i < size; i++) {
                NSArray *tempArray = [[pramsArray objectAtIndex:i] componentsSeparatedByString:@"=="];
                if ([tempArray count]>1) {
                    [self setValueByClass:(Class)viewController withMethodName:[tempArray objectAtIndex:0] withValue:[self handlerContentString:[tempArray objectAtIndex:1]]];
                }
            }
        }
    }
    viewController.hidesBottomBarWhenPushed = YES;
    [navCtrl pushViewController:viewController animated:YES];
}
@end
