//
//  BBGuideDB.h
//  pregnancy
//
//  Created by whl on 14-7-16.
//  Copyright (c) 2014年 babytree. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BBCoverLayerClass : NSObject
//版本号
@property (nonatomic, strong) NSString *m_AppVersion;
//蒙层的KEY
@property (nonatomic, strong) NSString *m_CoverLayerKey;
//是否显示
@property (nonatomic, assign) BOOL m_IsShow;

@end

@interface BBGuideDB : NSObject

+(BOOL)isExistCorverLayer;

+(BOOL)createCoverLayerLocationDB;

+(BOOL)insertAndUpdateCoverLayerData:(BBCoverLayerClass *)coverLayerData;

+(BBCoverLayerClass *)getCoverLayerData:(NSString *)coverLayerKey;

+ (BBCoverLayerClass *)getCoverLayerClass:(NSString *)coverLayerKey withIsShow:(BOOL)isShow;

+(NSString *)getGuideImageName:(NSString*)guideKey;

@end
