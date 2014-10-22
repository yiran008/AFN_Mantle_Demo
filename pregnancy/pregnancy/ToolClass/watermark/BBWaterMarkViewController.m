//
//  BBWaterMarkViewController.m
//  pregnancy
//
//  Created by duyanqiu on 13-9-25.
//  Copyright (c) 2013年 Babytree.com. All rights reserved.
//

#import "BBWaterMarkViewController.h"
#import "BBAppConfig.h"
#import "UIImage+Category.h"
#import <QuartzCore/QuartzCore.h>
#import "BBTimeUtility.h"
#import "BBPregnancyInfo.h"
#import "MobClick.h"
#import "BBBabyAgeCalculation.h"
#define pageNum 5

@interface BBWaterMarkViewController ()

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableDictionary *dateDictionary;
@end

@implementation BBWaterMarkViewController

-(void)dealloc
{
    [_waterMarkScroll release];
    [_pageControl release];
    [_imageView release];
    [_dateDictionary release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor  blackColor];
        [self getPregnancyInfo];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initWaterMarkScroll];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView=[[[UIImageView alloc] init] autorelease];
    _imageView.frame=CGRectMake(0, (DEVICE_HEIGHT-20-DEVICE_WIDTH-44)/2, DEVICE_WIDTH, DEVICE_WIDTH);
    [self.view addSubview:_imageView];
    
    self.waterMarkScroll=[[[UIScrollView alloc] initWithFrame:CGRectMake(0, (DEVICE_HEIGHT-20-DEVICE_WIDTH-44)/2, DEVICE_WIDTH, DEVICE_WIDTH)] autorelease];
    
    self.pageControl =  [[[UIPageControl alloc] initWithFrame:CGRectMake(0, (DEVICE_HEIGHT-20-DEVICE_WIDTH-44)/2+320, DEVICE_WIDTH, 44)] autorelease];
}

-(void)viewDidUnloadBabytree
{
    self.imageView=nil;
    self.waterMarkScroll=nil;
    self.pageControl=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    IOS6_RELEASE_VIEW

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark PrivateMethod

//
//保存图像
//
-(void)saveAction
{
    //添加水印
    NSInteger pageIndex = self.waterMarkScroll.contentOffset.x / 320+1;
    
    if (pageIndex == 5) {
        [MobClick event:@"mood_v2" label:@"选择不加水印"];
    }else{
        [MobClick event:@"mood_v2" label:@"选择加水印"];
    }

    UIImageView *waterMarkView=(UIImageView*)[self.view viewWithTag:9000+pageIndex];
    UIImage *mergeImage=[_imageView.image imageWithWaterMask:waterMarkView.image inRect:CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height)];
    
    //保存进相册
    UIImageWriteToSavedPhotosAlbum(mergeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //回调函数
    if ([_delegate respondsToSelector:@selector(getWaterMarkImage:)]) {
        [_delegate getWaterMarkImage:mergeImage];
    }
    
    
}

//
//添加文字水印（主要为了清晰）
//
-(UIImage*)addWaterMarkText:(NSInteger)pageIndex
{
     UIImage *waterMarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"WaterMark_%d",pageIndex]];
    switch (pageIndex)
    {
        case 1:
        {
            waterMarkImage= [waterMarkImage imageWithStringWaterMarkAndShadow:[NSString stringWithFormat:@"%@ %@",[self.dateDictionary objectForKey:@"daysTag"],[self.dateDictionary objectForKey:@"days"]] inRect:CGRectMake(70, 480,  200,200) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:32]shadowcolor:[UIColor blackColor] shadowoffset:CGPointMake(0, 2)];
            waterMarkImage= [waterMarkImage imageWithStringWaterMarkAndShadow:[BBTimeUtility stringDateWithFormat:@"yyyy/MM/dd HH:mm"] inRect:CGRectMake(70, 530,  200,200) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:24]shadowcolor:[UIColor blackColor] shadowoffset:CGPointMake(0, 0)];
            return waterMarkImage;
        }
            break;
        case 2:
        {
            waterMarkImage= [waterMarkImage imageWithStringWaterMarkAndShadow:[NSString stringWithFormat:@"%@ %@",[self.dateDictionary objectForKey:@"daysTag"],[self.dateDictionary objectForKey:@"days"]] inRect:CGRectMake(50, 520,  200,200) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:32]shadowcolor:[UIColor blackColor] shadowoffset:CGPointMake(0, 2)];
            waterMarkImage= [waterMarkImage imageWithStringWaterMarkAndShadow:[BBTimeUtility stringDateWithFormat:@"yyyy/MM/dd HH:mm"] inRect:CGRectMake(50, 570,  200,200) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:24]shadowcolor:[UIColor blackColor] shadowoffset:CGPointMake(0, 0)];
            
            return waterMarkImage;
        }
            break;
        case 3:
        {
            waterMarkImage= [waterMarkImage imageWithStringWaterMarkAndShadow:[NSString stringWithFormat:@"%@ %@",[self.dateDictionary objectForKey:@"daysTag"],[self.dateDictionary objectForKey:@"days"]] inRect:CGRectMake(420, 30,  200,200) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:32]shadowcolor:[UIColor blackColor] shadowoffset:CGPointMake(0, 2)];
            waterMarkImage= [waterMarkImage imageWithStringWaterMarkAndShadow:[BBTimeUtility stringDateWithFormat:@"yyyy/MM/dd HH:mm"] inRect:CGRectMake(420, 80,  200,200) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:24]shadowcolor:[UIColor blackColor] shadowoffset:CGPointMake(0, 0)];
            
            return waterMarkImage;
        }
            break;
        case 4:
        {
            waterMarkImage= [waterMarkImage imageWithStringWaterMark:[NSString stringWithFormat:@"%@ %@",[self.dateDictionary objectForKey:@"daysTag"],[self.dateDictionary objectForKey:@"days"]] inRect:CGRectMake(400, 510,  200,200) color:[UIColor colorWithRed:23/255.0 green:12/255.0 blue:12/255.0 alpha:1.0] font:[UIFont boldSystemFontOfSize:32]];
            
            waterMarkImage= [waterMarkImage imageWithStringWaterMark:[BBTimeUtility stringDateWithFormat:@"yyyy/MM/dd HH:mm"] inRect:CGRectMake(400, 560,  200,200) color:[UIColor colorWithRed:23/255.0 green:12/255.0 blue:12/255.0 alpha:1.0] font:[UIFont systemFontOfSize:24]];
            return waterMarkImage;
        }
            break;
            default:
        {
            return waterMarkImage;
        }
            break;
    }
    
}

//
//添加滚动水印层
//
- (void)initWaterMarkScroll
{
    _waterMarkScroll.contentSize = CGSizeMake(DEVICE_WIDTH * ((_pageNumber>0&&_outSet)?_pageNumber:pageNum), _waterMarkScroll.frame.size.height);
    _waterMarkScroll.showsHorizontalScrollIndicator = NO;
    _waterMarkScroll.showsVerticalScrollIndicator = NO;
    _waterMarkScroll.scrollsToTop = NO;
    _waterMarkScroll.pagingEnabled = YES;
    _waterMarkScroll.userInteractionEnabled=YES;
    _waterMarkScroll.backgroundColor = [UIColor clearColor];
    _waterMarkScroll.delegate=self;
    [self.view addSubview:_waterMarkScroll];
    
    _pageControl.numberOfPages = ((_pageNumber>0&&_outSet)?_pageNumber:pageNum);
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor  colorWithRed:64/255.0 green:72/255.0 blue:80/255.0 alpha:1.0];
    _pageControl.alpha=0.6;
    [self.view addSubview:_pageControl];
    
    [self makeScrollViewWaterMarks];
}

//
//添加水印效果
//
-(void)makeScrollViewWaterMarks
{
    if (!_outSet)
    {
        
        for (int i = 1; i < ((_pageNumber>0&&_outSet)?_pageNumber:pageNum)+1; i++)
        {
            UIImageView *imgMark= [[UIImageView alloc] init];
            imgMark.tag=9000+i;
            imgMark.frame = CGRectMake(320*(i-1), 0, 320,320);
            imgMark.image=[self addWaterMarkText:i];
            [_waterMarkScroll addSubview:imgMark];
            [imgMark release];
            
        }
        

    }
        
}

-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"save error");
        
    }
    else  
    {
        NSLog(@"save success");
    }
}

//获取孕期信息
- (void)getPregnancyInfo{
    if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
    {
        //育儿，水印显示宝宝年龄
        NSInteger bornDays = [BBPregnancyInfo daysOfPregnancy]-1;
        NSDate *stopData = [[BBPregnancyInfo dateOfPregnancy] dateByAddingTimeInterval:bornDays*24*3600];
        NSString *babyAge = [BBBabyAgeCalculation babyAgeWithStartDate:[BBPregnancyInfo dateOfPregnancy] withStopDate:stopData];
        
        NSString *content = [NSString stringWithFormat:@"%@%@",@"宝宝",babyAge];
        NSArray *contentArray = [content componentsSeparatedByString:@";"];
        
        NSString *contentText = [[[NSString alloc] initWithString:[contentArray componentsJoinedByString:@""]] autorelease];
        self.dateDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:contentText,@"daysTag",@"",@"days",@"倒计时",@"leftDaysTag",@"0天",@"leftDays", nil];
    }
    else
    {
        //孕期或其它（备孕状态已经在外部进行了控制，不显示水印），显示孕周
        if ([[BBPregnancyInfo currentDate] compare:[BBPregnancyInfo dateOfPregnancy]] != NSOrderedDescending)
        {
            NSInteger pregnancyDays = [BBPregnancyInfo daysOfPregnancy];
            pregnancyDays = (pregnancyDays>MAX_PREGMENT_DAYS) ? MAX_PREGMENT_DAYS : pregnancyDays;
            NSString *week1Text = nil;
            NSString *week2Text = nil;
            if(pregnancyDays/7 == 0)
            {
                week1Text = [NSString stringWithFormat:@"%d",pregnancyDays%7];
                week2Text = @"天";
            }
            else
            {
                week1Text = [NSString stringWithFormat:@"%d",pregnancyDays/7];
                if(pregnancyDays%7 == 0)
                {
                    week2Text = @"周";
                }
                else
                {
                    week2Text = [NSString stringWithFormat:@"周%d天",pregnancyDays%7];
                }
            }
            NSString *weekText = [[[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",week1Text,week2Text]] autorelease];
            self.dateDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"孕",@"daysTag",weekText,@"days",@"倒计时",@"leftDaysTag",[NSString stringWithFormat:@"%d天",MAX_PREGMENT_DAYS-pregnancyDays],@"leftDays", nil];
            
        }
        else
        {
            self.dateDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"我爱你",@"daysTag",@"宝贝",@"days",@"倒计时",@"leftDaysTag",@"0天",@"leftDays", nil];
            
        }
    }
    
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        
        return;
    }
	
    CGFloat pageWidth = _waterMarkScroll.frame.size.width;
    int page = floor((_waterMarkScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}


-(IBAction)cancelWaterMark:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

-(IBAction)completeWaterMark:(id)sender
{
    [self saveAction];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
