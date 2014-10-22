//
//  QBAssetsCollectionViewController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewController.h"

// Views
#import "QBAssetsCollectionViewCell.h"
#import "QBAssetsCollectionFooterView.h"

// add by DJ
#import "MBProgressHUD.h"
// add end

@interface QBAssetsCollectionViewController ()
// add by DJ
{
    NSIndexPath *s_LastAccessed;
}
// add end

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

// add by DJ
@property (nonatomic, strong) UIImageView *m_ToolBar;
@property (nonatomic, strong) UILabel *m_SelectedCountLabel;
@property (nonatomic, strong) MBProgressHUD *m_Progress;
// add end

@end

@implementation QBAssetsCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        // View settings
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        // Register cell class
        [self.collectionView registerClass:[QBAssetsCollectionViewCell class]
                forCellWithReuseIdentifier:@"AssetsCell"];
        [self.collectionView registerClass:[QBAssetsCollectionFooterView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:@"FooterView"];

        // add by DJ
        self.collectionView.height = UI_MAINSCREEN_HEIGHT - 44;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
        imageView.image = [UIImage imageNamed:@"imageshow__toolbar_bg"];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:imageView];
        self.m_ToolBar = imageView;
        UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.m_ToolBar addSubview:label];
        self.m_SelectedCountLabel = label;

        self.m_Progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.m_Progress];
        // add end

        // add by DJ
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanForSelection:)];
		[self.view addGestureRecognizer:pan];
        self.view.exclusiveTouch = YES;
        // add end
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Scroll to bottom --- iOS 7 differences
    CGFloat topInset;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        topInset = ((self.edgesForExtendedLayout && UIRectEdgeTop) && (self.collectionView.contentInset.top == 0)) ? (20.0 + 44.0) : 0.0;
    } else {
        topInset = (self.collectionView.contentInset.top == 0) ? (20.0 + 44.0) : 0.0;
        self.collectionView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0);
    }
    
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.frame.size.height + topInset)
                                 animated:NO];
    
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.imagePickerController.selectedAssetURLs.count];
    }

    // add by DJ
    [self.m_Progress hide:YES];
    [self showSelectedCount];
    // add end
}

// add by DJ
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.m_Progress hide:YES];
}
// add end

#pragma mark - Accessors

- (void)setFilterType:(QBImagePickerControllerFilterType)filterType
{
    _filterType = filterType;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Set title
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    // Get the number of photos and videos
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    self.numberOfPhotos = self.assetsGroup.numberOfAssets;
    
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
    self.numberOfVideos = self.assetsGroup.numberOfAssets;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
    
    // Load assets
    self.assets = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [weakSelf.assets addObject:result];
        }
    }];
    
    // Update view
    [self.collectionView reloadData];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (BOOL)allowsMultipleSelection
{
    return self.collectionView.allowsMultipleSelection;
}


#pragma mark - Actions

// modify by DJ
-(void)mustDone
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidFinishSelection:)]) {
        [self.delegate assetsCollectionViewControllerDidFinishSelection:self];
    }
}

- (void)done:(id)sender
{
    [self.m_Progress show:YES];

    [self performSelector:@selector(mustDone) withObject:nil afterDelay:0.1];

    // Delegate
//    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidFinishSelection:)]) {
//        [self.delegate assetsCollectionViewControllerDidFinishSelection:self];
//    }
}
// add end


#pragma mark - Managing Selection

- (void)selectAssetHavingURL:(NSURL *)URL
{
    for (NSInteger i = 0; i < self.assets.count; i++) {
        ALAsset *asset = [self.assets objectAtIndex:i];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        
        if ([assetURL isEqual:URL]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            return;
        }
    }
}


#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsGroup.numberOfAssets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetsCell" forIndexPath:indexPath];
    cell.showsOverlayViewWhenSelected = self.allowsMultipleSelection;
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    cell.asset = asset;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 46.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                  withReuseIdentifier:@"FooterView"
                                                                                         forIndexPath:indexPath];
    
    switch (self.filterType) {
        case QBImagePickerControllerFilterTypeNone:
            footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_photos_and_videos",
                                                                                              @"QBImagePickerController",
                                                                                              nil),
                                         self.numberOfPhotos,
                                         self.numberOfVideos
                                         ];
            break;
            
        case QBImagePickerControllerFilterTypePhotos:
            footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_photos",
                                                                                              @"QBImagePickerController",
                                                                                              nil),
                                         self.numberOfPhotos
                                         ];
            break;
            
        case QBImagePickerControllerFilterTypeVideos:
            footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_videos",
                                                                                              @"QBImagePickerController",
                                                                                              nil),
                                         self.numberOfVideos
                                         ];
            break;
    }
    
    return footerView;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(77.5, 77.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self validateMaximumNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didSelectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didSelectAsset:asset];
    }

    // add by DJ
    [self showSelectedCount];
    // add end
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count - 1)];
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didDeselectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didDeselectAsset:asset];
    }
    
    // add by DJ
    [self showSelectedCount];
    // add end
}

// add by DJ
- (void)showSelectedCount
{
    if (self.allowsMultipleSelection)
    {
        self.m_SelectedCountLabel.text = [NSString stringWithFormat:@"已选择%ld/%ld张图片", (long)self.imagePickerController.selectedAssetURLs.count, (long)self.maximumNumberOfSelection];
    }
}
// add end

// add by DJ
- (void)onPanForSelection:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];

    for (UICollectionViewCell *cell in self.collectionView.visibleCells)
	{
        if (CGRectContainsPoint(cell.frame, point))
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];

            if (s_LastAccessed != indexPath)
            {
                if (cell.isSelected)
                {
                    [self collectionView:self.collectionView didDeselectItemAtIndexPath:indexPath];
                    cell.selected = NO;
                }
                else if ([self collectionView:self.collectionView shouldSelectItemAtIndexPath:indexPath])
                {
                    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
                    cell.selected = YES;
                }
            }

            s_LastAccessed = indexPath;

            break;
        }
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        s_LastAccessed = nil;
        self.collectionView.scrollEnabled = YES;
    }
}
// add end

@end
