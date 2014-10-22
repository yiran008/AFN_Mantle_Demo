//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface MJPhotoBrowser () <MJPhotoViewDelegate>
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    MJPhotoToolbar *_toolbar;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
}
@end

@implementation MJPhotoBrowser

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissModalViewQuick) name:RECEIVE_AND_VIEW_REMOTENOTIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCurrentPhoto) name:DELETE_PHOTO_NOTIFICATION object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setHidden:NO];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
}

- (void)dismissModalViewQuick
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    // 移除工具条
    [_toolbar removeFromSuperview];
    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
}

- (void)show
{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    if (!window) {
//        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    }
//    [window addSubview:self.view];
//    [window.rootViewController addChildViewController:self];
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window.rootViewController.view addSubview:self.view];
    [window.rootViewController addChildViewController:self];

    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = 44;
    CGFloat barY = self.view.frame.size.height - barHeight;
    _toolbar = [[MJPhotoToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    [self.view addSubview:_toolbar];
    
    [self updateTollbarState];
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
    // 移除工具条
    [_toolbar removeFromSuperview];
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

    [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_NEEDFRESHPHOTO object:nil];
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

- (void)photoViewWillDisappear
{
    if (_currentPhotoIndex == _firstPhotoIndex)
    {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didChangedToPageAtIndex:)])
    {
        [_delegate photoBrowser:self didChangedToPageAtIndex:_currentPhotoIndex];
    }

    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowserClose)])
    {
        [_delegate photoBrowserClose];
    }
}

#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex)
        {
            if (photoView)
            {
                [_reusablePhotoViews addObject:photoView];
            }
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSInteger)index
{
//    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didChangedToPageAtIndex:)])
//    {
//        [_delegate photoBrowser:self didChangedToPageAtIndex:index];
//    }
    
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    MJPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    if (photoView)
    {
        [_visiblePhotoViews addObject:photoView];
        [_photoScrollView addSubview:photoView];
    }
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSInteger)index
{
    if (index > 0) {
        MJPhoto *photo = _photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    
    if (index < _photos.count - 1) {
        MJPhoto *photo = _photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MJPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
    [self updateTollbarState];
}

-(void)deleteCurrentPhoto
{
    @synchronized(self)
    {
        NSMutableArray *array = [_photos mutableCopy];
        if (_currentPhotoIndex < [array count])
        {
            [array removeObjectAtIndex:_currentPhotoIndex];
        }
        NSMutableArray *photoArrays = [NSMutableArray array];
        
        for (NSInteger i = 0; i<array.count; i++)
        {
            MJPhoto *photo = [array objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(photo.image, 1.0);
            [photoArrays addObject:imageData];
        }
        
        if ([self.delegate respondsToSelector:@selector(imageShowViewDidFinish:isChanged:)])
        {
            [self.delegate imageShowViewDidFinish:photoArrays isChanged:YES];
        }
        
        if ([array count]==0)
        {
            [_toolbar setCurrentPhotoIndex:0];
            [self dismissModalViewQuick];
        }
        else if([array count] > 0)
        {
            
            [_photoScrollView removeAllSubviews];
            
            if(_currentPhotoIndex == [_photos count]-1)
            {
                _currentPhotoIndex--;
            }
            _photos = [array copy];
            [self setCurrentPhotoIndex:_currentPhotoIndex];
            
            CGRect frame = self.view.bounds;
            frame.origin.x -= kPadding;
            frame.size.width += (2 * kPadding);
            _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
            _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
            
            MJPhoto *photo = _photos[_currentPhotoIndex];
            [photo.srcImageView removeFromSuperview];
            photo.srcImageView = [[UIImageView alloc]initWithImage:photo.image];
            [self showPhotoViewAtIndex:_currentPhotoIndex];
            
            _toolbar.photos = _photos;
            [_toolbar setCurrentPhotoIndex:_currentPhotoIndex];
        }
    }
}

@end