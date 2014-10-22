//
//  TestHelper.m
//  Home
//
//  Created by Heyanyang 2014-07-25
//  Copyright (c) 2014年 babytree. All rights reserved.
//  

#import "TestHelper.h"
#include <asl.h>
//此处需要引入api配置头文件
#import "BBConfigureAPI.h"


@implementation TestHelper
static TestHelper *sharedInstance = nil;

// 获取一个sharedInstance实例，如果有必要的话，实例化一个
+ (TestHelper *)sharedInstance {
    @synchronized (self)
    {
        if(sharedInstance == nil)
        {
            sharedInstance = [[super allocWithZone:NULL] init];
        }
    }
    return sharedInstance;
}
#pragma mark iConsole Delegate

- (void)handleConsoleCommand:(NSString *)command
{
    [iConsole log:@"\n==========================================="];
    NSMutableSet *test_set = [NSMutableSet set];

    [test_set addObject:@"www"];
    [test_set addObject:@"dev"];
    [test_set addObject:@"on"];
    
    if (![test_set containsObject:command])
    {
        if ([command rangeOfString:@"test"].length>0)
        {
            [test_set addObject:command];
        }
    }
    
    
    if ([command isEqualToString:@"version"])//显示app版本信息
	{
		[iConsole log:@"%@ version %@",
         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"],
         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
	}
    else if ([command isEqualToString:@"log"])//打印所有log
    {
        aslmsg q, m;
        int i;
        const char *key, *val;
        q = asl_new(ASL_TYPE_QUERY);
        asl_set_query(q, ASL_KEY_SENDER,"Home", ASL_QUERY_OP_EQUAL);
        aslresponse r = asl_search(NULL, q);
        
        while (NULL != (m = aslresponse_next(r)))
        {
            NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
            
            for (i = 0; (NULL != (key = asl_key(m, i))); i++)
            {
                NSString *keyString = [NSString stringWithUTF8String:(char *)key];
                if ([keyString isEqualToString:@"Message"])
                {
                    val = asl_get(m, key);
                    
                    NSString *string = val?[NSString stringWithUTF8String:val]:@"";
                    [tmpDict setObject:string forKey:keyString];
                }
                
            }
            [iConsole log:@"%@",[self getObjectDescription:tmpDict andIndent:0]];
            
        }
        aslresponse_free(r);
    }
    else if([command isEqualToString:@"mo"])//打开内存监视台
    {
        [[MemoryWarning shareInstance] open];
        [iConsole log:@"内存监视台已打开'"];
    }
    else if([command isEqualToString:@"mc"])//关闭内存监视台
    {
        [[MemoryWarning shareInstance] close];
        [iConsole log:@"内存监视台已关闭'"];
    }
    else if([command isEqualToString:@"ml"])//模拟内存警告
    {
        [[MemoryWarning shareInstance] sendMemoryWarning];
        [iConsole log:@"模拟收到内存警告'"];
    }
    else if ([command isEqualToString:@"api"])//查看API路径情况
    {
        NSString *test_id =[[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_TEST_SERVER_KEY];
        if (test_id !=nil && [test_id length]!= 0)
        {
            [iConsole log:@"当前www环境是'%@'",[BABYTREE_URL_SERVER stringByReplacingOccurrencesOfString:MOBILE_TESTER withString:@""]];
            [iConsole log:@"当前upload环境是'%@'",[BABYTREE_UPLOAD_SERVER stringByReplacingOccurrencesOfString:MOBILE_TESTER withString:@""]];
            [iConsole log:@"当前mall环境是'%@'",[BABYTREE_MALL_SERVER stringByReplacingOccurrencesOfString:MOBILE_TESTER withString:@""]];
        }
    }
    else if ([command isEqualToString:@"help"])//help命令
    {
        NSMutableString *helpStr =  [[NSMutableString alloc] init];
        [helpStr appendString:@"\n(01) 'help' 显示命令帮助文档\n"];
        [helpStr appendString:@"(02) 'version' 显示app版本\n"];
        [helpStr appendString:@"(03) 'clear' 清除控制台信息\n"];
        [helpStr appendString:@"(04) 'log' 打印所有NSLog\n"];
        
        [helpStr appendString:@"(05) 'api' 显示当前所处API环境信息\n"];
        [helpStr appendString:@"(06) 'X.test' 切换API环境到X.test\n"];
        [helpStr appendString:@"(07) 'www' 切换API环境到www\n"];
        [helpStr appendString:@"(08) 'on' 切换API环境到线上\n"];
        [helpStr appendString:@"(09) 'dev' 切换API环境到dev\n"];
        [helpStr appendString:@"(10) 'testX&dev' 切换API环境到testX且dev\n"];
        
        [helpStr appendString:@"(11) 'mo' 显示内存使用情况\n"];
        [helpStr appendString:@"(12) 'ml' 模拟内存警告\n"];
        [helpStr appendString:@"(13) 'mc' 关闭内存使用状态\n"];

        [iConsole log:helpStr];
    }
    else if ([command rangeOfString:@"email:"].length>0)//设置反馈邮件
    {
        
        [iConsole sharedConsole].logSubmissionEmail = [command stringByReplacingCharactersInRange:[command rangeOfString:@"email:"] withString:@""];
        [iConsole log:@"%@",[iConsole sharedConsole].logSubmissionEmail];
    }
    else if([command isEqualToString:@"on"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:DEBUG_DEV_SERVER_KEY];
        [iConsole log:@"当前api已经变更为线上'"];
    }
    else //if ([test_set containsObject:command]) //放入人名字分支名称，如 xiaoqiang.babytree-dev.com等
    {
        if([command isEqualToString:@"www"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:command forKey:DEBUG_TEST_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:DEBUG_UPLOAD_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:DEBUG_MALL_SERVER_KEY];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:DEBUG_DEV_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults]synchronize];

            [iConsole log:@"当前api已经变更为'%@'",command];

        }
        else if ([command isEqualToString:@"dev"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"-dev" forKey:DEBUG_DEV_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [iConsole log:@"当前api已经变更为'dev'"];
        }
        else
        {

            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",command] forKey:DEBUG_TEST_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@.",command] forKey:DEBUG_UPLOAD_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@.",command] forKey:DEBUG_MALL_SERVER_KEY];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [iConsole log:@"当前api已经变更为'%@'",command];
        }
    }
    
    self.preCommand=command;
}
/*
 该函数用于解析中文log，也可以提取出来作为工具使用
 */
-(NSMutableString*)getObjectDescription : (NSObject*)obj andIndent:(NSUInteger)level
{
    NSMutableString *str = [NSMutableString string];
    NSString * strIndent = @"";
    if (level>0){
        NSArray *indentAry = [self generateArrayWithFillItem:@"\t" andArrayLength:level];
        strIndent = [indentAry componentsJoinedByString:@""];
    }
    if ([obj isKindOfClass:NSString.class]){
        [str appendFormat:@"\n%@%@",strIndent,obj];
    }else if([obj isKindOfClass:NSArray.class]){
        [str appendFormat:@"\n%@(",strIndent];
        NSArray *ary = (NSArray *)obj;
        for(int i=0; i<ary.count; i++){
            NSString *s = [self getObjectDescription:ary[i] andIndent:level+1];
            [str appendFormat:@"%@ ,",s];
        }
        [str appendFormat:@"\n%@)",strIndent];
    }else if([obj isKindOfClass:NSDictionary.class]){
        [str appendFormat:@"\n%@{",strIndent];
        NSDictionary *dict = (NSDictionary *)obj;
        for (NSString *key in dict) {
            NSObject *val = dict[key];
            [str appendFormat:@"\n\t%@%@=",strIndent,key];
            NSString *s = [self getObjectDescription:val andIndent:level+2];
            [str appendFormat:@"%@ ;",s];
        }
        [str appendFormat:@"\n%@}",strIndent];
        
    }else{
        [str appendFormat:@"\n%@%@",strIndent,[obj debugDescription]];
    }
    
    return str;
}
-(NSMutableArray*)generateArrayWithFillItem:(NSObject*)fillItem andArrayLength:(int)length
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:length];
    for(int i=0; i<length; i++){
        [ary addObject:fillItem];
    }
    return ary;
}
-(void)setDebugServer
{
#ifdef DEBUG
    //初始化配置
    NSString *test_server_id = [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_TEST_SERVER_KEY];
    if (test_server_id == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:TEST_INIT forKey:DEBUG_TEST_SERVER_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    NSString *upload_server_id = [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_UPLOAD_SERVER_KEY];
    if (upload_server_id == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:UPLOAD_INIT forKey:DEBUG_UPLOAD_SERVER_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    NSString *mall_server_id = [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_MALL_SERVER_KEY];
    if (mall_server_id == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:MALL_INIT forKey:DEBUG_MALL_SERVER_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    NSString *dev_server_id = [[NSUserDefaults standardUserDefaults]objectForKey:DEBUG_DEV_SERVER_KEY];
    if (dev_server_id == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:DEV_INIT forKey:DEBUG_DEV_SERVER_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
#else
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DEBUG_TEST_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DEBUG_UPLOAD_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DEBUG_MALL_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DEBUG_DEV_SERVER_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
#endif
}
#pragma Singleton Methods
// 当第一次使用这个单例时，会调用这个init方法。
- (id)init
{
    self = [super init];
    
    if (self) {
        //iConsole初始化，deviceShakeToShow(摇动开启)默认设为NO，开启请设为YES
        [iConsole sharedConsole].delegate = self;
        [iConsole sharedConsole].deviceShakeToShow = YES;
        [self setDebugServer];
    }
    
    return self;
}


//-(void)dealloc
//{
//    [_preCommand release];
//    [super dealloc];
//}

// 通过返回当前的sharedInstance实例，就能防止实例化一个新的对象。
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil){
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

// 同样，不希望生成单例的多个拷贝。
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
