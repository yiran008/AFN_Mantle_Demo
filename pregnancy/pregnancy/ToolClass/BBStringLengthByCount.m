//
//  BBStringLengthByCount.m
//  pregnancy
//
//  Created by babytree babytree on 12-11-1.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBStringLengthByCount.h"

@implementation BBStringLengthByCount

+(NSInteger)subStringLengthByCount:(NSString *)string withCount:(NSInteger)count{
    if (string==nil) {
        return 0;
    }
    int i;
    int sum=0;
    int count2=0;
    for(i=0;i<[string length];i++)
    {
        unichar str = [string characterAtIndex:i];  
        if(str < 256)
        {
            sum+=1;
        }else {
            sum+=2;
        }
        count2++;
        if (sum>=count){
            break;
        }
    }
    if(sum>count)
    {
        return count2-1;
    }else{ 
        return count2;
    }
}
+(NSString *)subStringByCount:(NSString *)string withCount:(NSInteger)count{
    if (string==nil) {
        return @"";
    }
    int i;
    int sum=0;
    for(i=0;i<[string length];i++)
    {
        unichar str = [string characterAtIndex:i];  
        if(str < 256)
        {
            sum+=1;
        }else {
            sum+=2;
        }
        if(sum>count){
            NSString * str=[string substringWithRange:NSMakeRange(0,[self subStringLengthByCount:string withCount:count-3])];
            return [NSString stringWithFormat:@"%@...",str];
        }
    } 
    return string;
}
@end
