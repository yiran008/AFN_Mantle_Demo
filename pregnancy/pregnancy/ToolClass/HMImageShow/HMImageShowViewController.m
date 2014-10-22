//
//  HMImageShowViewController.m
//  lama
//
//  Created by mac on 13-10-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMImageShowViewController.h"

#define HMImageShow_ImageGap 2

@interface HMImageShowViewController ()

@end

@implementation HMImageShowViewController
@synthesize delegate;

@synthesize m_ScrollView;
@synthesize m_ToolBar;

@synthesize m_ImageDataArray;
@synthesize m_ImageViewArray;

@synthesize m_Index;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isDeleted = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.view.height = UI_SCREEN_HEIGHT;
    m_ScrollView.top = 0;
    m_ScrollView.height = self.view.height - 44;
    m_ToolBar.top = self.view.height - 44;
    
    [self showImages:m_ImageDataArray atIndex:self.m_Index];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    self.view.exclusiveTouch = YES;
    
    self.m_CancleBtn.exclusiveTouch = YES;
    self.m_DeleteBtn.exclusiveTouch = YES;
    self.m_OkBtn.exclusiveTouch = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.m_Index = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    NSLog(@"%ld", (long)self.m_Index);
}


- (void)showImages:(NSArray *)imageDataArray atIndex:(NSInteger)index
{
    if (![imageDataArray isNotEmpty])
    {
        return;
    }
    
    if (index < 0 || index >= imageDataArray.count)
    {
        return;
    }
    
    self.m_ImageDataArray = [NSMutableArray arrayWithArray:imageDataArray];
    self.m_ImageViewArray = [NSMutableArray arrayWithCapacity:0];
    
    m_ScrollView.contentSize = CGSizeMake(self.m_ImageDataArray.count * self.view.width, m_ScrollView.height);
    
    [m_ScrollView removeAllSubviews];
    
    for(NSInteger i = 0; i < self.m_ImageDataArray.count; i++)
    {
        NSData *imageData = [self.m_ImageDataArray objectAtIndex:i];
        UIImage *image = [UIImage imageWithData:imageData];
        
        float width = image.size.width;
        float height = image.size.height;
        
        float divWidth = width/(UI_SCREEN_WIDTH-HMImageShow_ImageGap*2);
        float divheight = height/(m_ScrollView.height-HMImageShow_ImageGap*2);
        
        float divMax = divWidth > divheight ? divWidth : divheight;
        
//        if (divMax < 1)
//        {
//            divMax = 1;
//        }
        
        width = width/divMax;
        height = height/divMax;

        UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        ImageView.image = image;
        ImageView.userInteractionEnabled = YES;
        
        CGRect rect = CGRectMake(i * UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, m_ScrollView.height);
        [ImageView centerInRect:rect];
        
        [m_ScrollView addSubview:ImageView];
        
        [m_ImageViewArray addObject:ImageView];
    }
    
    m_Index = index;
    
    m_ScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH*index, 0);
}


- (IBAction)cancleClick:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate imageShowViewCancle];
}

- (IBAction)OkClick:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate imageShowViewDidFinish:m_ImageDataArray isChanged:_isDeleted];
}

- (IBAction)deleteClick:(id)sender
{
    _isDeleted = YES;
    
    NSInteger index = self.m_Index;
    
    if (index == self.m_ImageDataArray.count - 1)
    {
        if (self.m_ImageDataArray.count == 1)
        {
            self.m_ImageDataArray = nil;
            
            [self OkClick:nil];
            
            return;
        }
        
        UIImageView *imageView = [m_ImageViewArray lastObject];
        [m_ImageViewArray removeLastObject];
        [m_ImageDataArray removeLastObject];
        
        [UIView animateWithDuration:0.5 animations:^{
            imageView.top = 0-imageView.height;
            m_ScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH*(index-1), 0);
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            m_ScrollView.contentSize = CGSizeMake(m_ImageDataArray.count * self.view.width, m_ScrollView.height);
        }];
    }
    else
    {
        UIImageView *imageView = [m_ImageViewArray objectAtIndex:index];
        [m_ImageViewArray removeObjectAtIndex:index];
        [m_ImageDataArray removeObjectAtIndex:index];
        
        [UIView animateWithDuration:0.5 animations:^{
            imageView.top = 0-imageView.height;
            
            for (NSInteger i = index; i < m_ImageViewArray.count; i++)
            {
                UIImageView *imageView = [m_ImageViewArray objectAtIndex:i];
                imageView.left -= self.view.width;
            }
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            m_ScrollView.contentSize = CGSizeMake(m_ImageDataArray.count * self.view.width, m_ScrollView.height);
        }];
    }
}


#pragma mark - UIGestureRecognizer Delegate

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = [m_ImageViewArray objectAtIndex:m_Index];
    
    CGPoint location = [gestureRecognizer locationInView:imageView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        s_GesturePoint = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //if (fabs(location.y - s_GesturePoint.y) >= 50)
        if (s_GesturePoint.y - location.y > 50)
        {
            [self deleteClick:nil];
        }
    }
}

@end
