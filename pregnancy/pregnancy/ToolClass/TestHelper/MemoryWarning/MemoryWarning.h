//
//  MemoryWarning.h
//  Childcare
//  状态栏内存查看类
//  Created by duyanqiu on 13-9-2.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryWarning : NSObject{
	int64_t				_manualBytes;
	NSMutableArray *	_manualBlocks;
}

@property (nonatomic, readonly) int64_t				manualBytes;
@property (nonatomic, readonly) NSMutableArray *	manualBlocks;

+(MemoryWarning *)shareInstance;

@property (strong, nonatomic) UIWindow *memoryWindow;

@property (strong, nonatomic) NSTimer *timer;

-(void)statusBarLoad;

-(void)close;

-(void)open;

-(void)sendMemoryWarning;
@end
