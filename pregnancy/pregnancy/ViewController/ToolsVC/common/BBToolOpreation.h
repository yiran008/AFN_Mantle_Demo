//
//  BBToolsKit.h
//  pregnancy
//
//  Created by liumiao on 7/27/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBToolModel.h"
@class BBToolOpreation;
// 工具页面类型
typedef NS_ENUM(NSInteger, ToolPageType)
{
    ToolPageTypeMain,
    ToolPageTypeTool
};

@protocol BBToolOpreationDelegate <NSObject>

@required
@property (nonatomic,strong)BBToolOpreation *s_ToolOperation;

@end
@interface BBToolOpreation : NSObject

// 工具页new状态检测
+ (BOOL)compareOldTools:(NSArray *)oldList withNewTools:(NSArray*)newList;
+ (void)setToolsState:(BOOL)state forTool:(NSString*)toolName;
+ (NSDictionary*)toolsState;

// 从原始工具列表中过滤出当前版本支持的工具列表
+ (NSArray *)getCurrentVersionSupportedToolsArray:(NSArray*)originArray;
+ (NSSet*)currentSupportedToolsTypeSet;

// 工具列表读取、存储和清理
+ (NSDictionary *)getToolActionDataOfType:(ToolPageType)type;
+ (void)setToolActionData:(NSDictionary *)actionData ofType:(ToolPageType)type;
+ (void)clearToolActionDataOfType:(ToolPageType)type;

+ (BBToolModel*)modelFromDict:(NSDictionary*)dict;
+ (NSString*)getHolderImageForItem:(NSDictionary*)item;


- (void)performActionOfTool:(BBToolModel*)tool target:(id<BBToolOpreationDelegate>)target;
@end
