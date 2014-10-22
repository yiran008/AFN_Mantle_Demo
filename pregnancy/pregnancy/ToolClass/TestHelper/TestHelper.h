//
//  TestHelper.h
//  Home
//
//  Created by Heyanyang 2014-07-25
//  Copyright (c) 2014年 babytree. All rights reserved.
//

/*
 TestHelper是将iConsole手机控制台同其它友好调试工具相结合的一个单例，主要思想是通过iConsole控制台输入一些预置好的命令(可以根据需要扩展), 调用相关调试功能:打印log，切换环境，发送log等，DEBUG标志用于条件编译.
 启用:
 1.将TestHelper目录拷贝到工程目录下
 2.在AppDelegate和XXX-Prefix.pch文件中 #import "TestHelper.h"
 3.在"- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions"中加入
 
 #ifdef DEBUG
 [TestHelper sharedInstance];
 #endif
 
 使用: 在任意界面调出console控制台，输入命令即可，命令可以在- (void)handleConsoleCommand:(NSString *)command方法中扩展
 */
#import <Foundation/Foundation.h>

/*
https://github.com/nicklockwood/iConsole
导入iConsole控制台，iConsole是一个隐藏控制台，通过在设备里三指上划和下滑或者摇动(可具体配置)来开启和隐藏，可以接收输入的命令，并执行相应代码.
注意! iConsle以及相关的GTMStackTrace均采用ARC，所以如果是非ARC工程，需要在target的Buld Phase里相应文件的Compiler Flags 加上-fobjc-arc参数
启用:
 在"- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions"中[TestHelper sharedInstance];将原来的self.window...替换为
 
#ifdef DEBUG
 self.window = [[[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
#else
 self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
#endif

 */
#import "iConsole.h"


/*
 MemoryWarning是检测内存使用情况并展示的工具，还可以发送memory warning.
 注意! 此功能函数为私有api，在提交应用之前应该注释掉
 */
#import "MemoryWarning.h"


@interface TestHelper : NSObject<iConsoleDelegate>

+ (TestHelper *)sharedInstance;
@property (retain, nonatomic) NSString *preCommand;

@end
