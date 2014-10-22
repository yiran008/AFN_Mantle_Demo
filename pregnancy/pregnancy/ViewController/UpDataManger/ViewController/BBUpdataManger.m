//
//  BBUpdataManger.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBUpdataManger.h"
#import "ASIHTTPRequest.h"
#import "BBUser.h"
#import "BBKonwlegdeDB.h"
#import "BBUpdataRequest.h"
//同步循环的最大次数
#define UPDATA_MAX_TIMES (10)

static int updata_cur_index = 0;

@interface BBUpdataManger()
@property(nonatomic,strong)ASIHTTPRequest  *s_updataRequest;
@end

@implementation BBUpdataManger

-(void)dealloc
{
    [_s_updataRequest clearDelegatesAndCancel];
}

+ (BBUpdataManger *)sharedManager {
    static BBUpdataManger *sharedAccountManagerInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    
    return sharedAccountManagerInstance;
}

-(NSString *)dirDoc
{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(void)initPregnancyKnowledgeDB
{
    NSString *documentsPath = [self dirDoc];
    NSString *sourceDirPath = [documentsPath stringByAppendingPathComponent:KNOWLEDGE_DB_DIR_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //创建数据库文件夹目录
    BOOL res=[fileManager createDirectoryAtPath:sourceDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (res)
    {
        //NSLog(@"数据库文件夹创建成功");
    }
    else
    {
        //NSLog(@"数据库文件夹创建失败");
    }
    
    //创建数据库文件
    NSString *desPath = [sourceDirPath stringByAppendingPathComponent:KNOWLEDGE_DB_FILE_NAME];
    NSError *err = nil;
    BOOL isExist = [fileManager fileExistsAtPath:desPath];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:KNOWLEDGE_DB_FILE_NAME ofType:nil];
    
    if (!isExist)
    {
        [fileManager copyItemAtPath:sourcePath toPath:desPath error:&err];
    }
    else
    {
        BOOL isDBConnectionGood = [BBKonwlegdeDB isDBConnectionGood];
        if (!isDBConnectionGood)
        {
            //替换不完整的数据库文件
            [fileManager removeItemAtPath:desPath error:nil];
            [fileManager copyItemAtPath:sourcePath toPath:desPath error:&err];
        }
    }
}

- (void)removeKnowledgeDirectory
{
    NSString *documentDirectory = [self dirDoc];
    NSString *dbFilePathForVersionFive = [documentDirectory stringByAppendingPathComponent:@"knowledge.db"];
    NSString *dbDirPathForVersionFiveLater = [documentDirectory stringByAppendingPathComponent:KNOWLEDGE_DB_DIR_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbDirPathForVersionFiveLater error:nil];
    [fileManager removeItemAtPath:dbFilePathForVersionFive error:nil];
}

//每次启动调用
- (void)startUpdate
{
    updata_cur_index = 0;
    [self initPregnancyKnowledgeDB];
    [self doUpdata];
}

- (void)doUpdata
{
    @synchronized(self)
    {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        
        if ([reachability currentReachabilityStatus] == ReachableViaWiFi)
        {
            [self.s_updataRequest clearDelegatesAndCancel];
            self.s_updataRequest = [BBUpdataRequest updataKnowledgeWithTS:[BBKonwlegdeDB getKnowledgeTS]];
            [self.s_updataRequest setDidFinishSelector:@selector(updataFinished:)];
            [self.s_updataRequest setDidFailSelector:@selector(updataFailed:)];
            [self.s_updataRequest setDelegate:self];
            [self.s_updataRequest startAsynchronous];
        }
    }
}



- (void)updataFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSDictionary * dic = [data dictionaryForKey:@"data"];
        if ([dic stringForKey:@"update_ts"])
        {
            [BBKonwlegdeDB setKnownledgeTS:[dic objectForKey:@"update_ts"]];
            NSLog(@"---%@",[dic objectForKey:@"update_ts"]);
        }
        NSArray * knowledgeArr = [dic arrayForKey:@"knowledge_list"];
        if (knowledgeArr) {
            [BBKonwlegdeDB upDataKnowledgeData:knowledgeArr];
        }
        if (knowledgeArr && knowledgeArr.count && updata_cur_index<UPDATA_MAX_TIMES)
        {
            updata_cur_index++;
            [self doUpdata];
        }
    }
}

- (void)updataFailed:(ASIFormDataRequest *)request
{
    
}

@end
