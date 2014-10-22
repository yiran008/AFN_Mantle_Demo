//
//  MemoryWarning.m
//  Childcare
//  状态栏内存查看类
//  Created by duyanqiu on 13-9-2.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "MemoryWarning.h"
#import <mach/mach.h>

#define WarningTime 1.5
#define MemoryLable 101
#define K	(1024)
#define M	(K * 1024)
#define G	(M * 1024)

@implementation MemoryWarning
@synthesize memoryWindow=_memoryWindow;
@synthesize timer=_timer;
@synthesize manualBytes = _manualBytes;
@synthesize manualBlocks = _manualBlocks;

static MemoryWarning *memoryWarning = nil;

+(MemoryWarning *)shareInstance{
    if (memoryWarning == nil) {
        memoryWarning = [[self alloc]init];
    }
    return memoryWarning;
}

#pragma mark 方法
-(void)statusBarLoad
{
    _manualBlocks = [[NSMutableArray alloc] init];
    
    [self addView];
    
    [self addGesture];
    
    [self freshMemory];
  
}

//更新内存使用情况
-(void)freshMemory
{
    //定时器
    [_timer invalidate];
    _timer=nil;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1
                                            target:self selector:@selector(showStatusInfo)
                                          userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    //接收内存警告通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didMemoryWarning)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}
//手势操作
-(void)addGesture
{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(sendMemoryWarning)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_memoryWindow addGestureRecognizer: singleTap];
    [singleTap release];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] init];
    [rightSwipe addTarget:self action:@selector(addMemory)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [rightSwipe setNumberOfTouchesRequired:1];
    [_memoryWindow addGestureRecognizer:rightSwipe];
    
    [rightSwipe release];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] init];
    [leftSwipe addTarget:self action:@selector(freeMemory)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe setNumberOfTouchesRequired:1];
    [_memoryWindow addGestureRecognizer:leftSwipe];
    
    [leftSwipe release];
    
    _memoryWindow.exclusiveTouch = YES;

}

//加载视图
-(void)addView
{
    self.memoryWindow=[[[UIWindow alloc] init] autorelease];
//    _memoryWindow.frame = [UIApplication sharedApplication].statusBarFrame;//statusBar为hidden = YES时受影响
    _memoryWindow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    _memoryWindow.windowLevel = UIWindowLevelStatusBar+1.0f;
    _memoryWindow.backgroundColor=[UIColor blackColor];
    _memoryWindow.hidden=NO;
    _memoryWindow.alpha=1;
    
    UIButton *memory=[[UIButton alloc] initWithFrame:CGRectMake(10, 2, 70, 16)];
    memory.exclusiveTouch = YES;
    memory.backgroundColor=[UIColor clearColor];
    memory.titleLabel.textAlignment=NSTextAlignmentCenter;
    memory.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [memory setTitle:@"Memory" forState:UIControlStateNormal];
    [memory setTitleColor:[UIColor colorWithRed:247/255.0 green:109/255.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    memory.userInteractionEnabled=NO;
    [_memoryWindow addSubview:memory];
    
    UILabel *memoryChangeLable=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, 230, 20)];
    memoryChangeLable.tag=MemoryLable;
    memoryChangeLable.textColor=[UIColor grayColor];
    memoryChangeLable.backgroundColor=[UIColor clearColor];
    memoryChangeLable.textAlignment=NSTextAlignmentLeft;
    memoryChangeLable.font=[UIFont boldSystemFontOfSize:16];
    [_memoryWindow addSubview:memoryChangeLable];
    [memory release];
    [memoryChangeLable release];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.exclusiveTouch = YES;
    closeButton.showsTouchWhenHighlighted = YES;
    closeButton.frame = CGRectMake(300, 0, 20, 20);
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    closeButton.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButton.userInteractionEnabled=YES;
    [_memoryWindow addSubview:closeButton];

}

//私有API
//发送内存警告
-(void)sendMemoryWarning
{
    #ifdef DEBUG
    [[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];
    #endif
}
-(void)_performMemoryWarning{}
//显示StatusBar信息
-(void)showStatusInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *memoryLable=(UILabel*)[self.memoryWindow viewWithTag:MemoryLable];
        if (memoryLable) {
            memoryLable.text=[NSString stringWithFormat:@"Used:%.02fM Free:%.02fM",[[self class] usedMemory],[[self class] freeMemory]];
            
        }
        
    });
}

//监测剩余内存大小：
+ (double)freeMemory{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

//监测app使用内存的情况：
+ (double)usedMemory{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

//内存警告显示绿色背景条
-(void)didMemoryWarning
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.memoryWindow.backgroundColor==[UIColor blackColor])
        {
            self.memoryWindow.backgroundColor=[UIColor greenColor];
            [self performSelector:@selector(didMemoryWarning) withObject:nil afterDelay:WarningTime];
        }else
        {
            self.memoryWindow.backgroundColor=[UIColor blackColor];
        }
        
    });
    
}

//关闭内存信息条
-(void)close
{
    [_timer invalidate];
    _timer=nil;
    self.memoryWindow.hidden=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];

}

//打开内存信息
-(void)open
{
    if (self.memoryWindow)
    {
        self.memoryWindow.hidden=NO;
        [self freshMemory];
        
    }else
    {
        [self statusBarLoad];
    }
}

//增加内存
- (void)addMemory
{
    void * block = NSZoneCalloc( NSDefaultMallocZone(), 50, M );
    if ( nil == block )
    {
        block = NSZoneMalloc( NSDefaultMallocZone(), 50 * M );
    }
    
    if ( block )
    {
        _manualBytes += 50 * M;
        [_manualBlocks addObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)block]];
    }
	
}
//减少内存
- (void)freeMemory
{
	NSNumber * block = [_manualBlocks lastObject];
	if ( block )
	{
		void * ptr = (void *)[block unsignedLongLongValue];
		NSZoneFree( NSDefaultMallocZone(), ptr );
		
		[_manualBlocks removeLastObject];
	}
	
}

#pragma mark 单例设置
+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (memoryWarning == nil){
            memoryWarning = [super allocWithZone:zone];
            return memoryWarning;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (unsigned)retainCount
{
    return UINT_MAX;
}
- (oneway void)release
{
}
- (id)autorelease
{
    return self;
}

@end
