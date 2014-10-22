//
//  BBUmengAdView.m
//  pregnancy
//
//  Created by babytree babytree on 12-8-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBUmengAdView.h"
#import "BBApp.h"

@implementation BBUmengAdView

- (void)dealloc
{
    _mTableView.dataLoadDelegate = nil;
    [_mTableView release];
    [_mLoadingStatusLabel release];
    [_mLoadingActivityIndicator release];
    [_mNoNetworkImageView release];
    [_mLoadingWaitView release];
    
    _mLoadingWaitView = nil;
    
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame withKeywords:(NSString *)keywords withIsAtuoFill:(BOOL)isAtuoFill
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *appKey = nil;
        
//        if ([[BBApp getProjectCategory] isEqualToString:@"1"]) {
//            appKey =@"5045cd255270155e4400023c";
//        } else {
        appKey =@"4f8e312a52701573c9000041";
//        }
        
        _mTableView = [[UMUFPTableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain appkey:appKey slotId:nil currentViewController:nil];
        _mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mTableView.separatorColor = [UIColor lightGrayColor];
        _mTableView.mAutoFill = isAtuoFill;
        if (keywords != nil) {
            _mTableView.mKeywords = keywords;
        }
        _mTableView.dataLoadDelegate = (id<UMUFPTableViewDataLoadDelegate>)self;
        
        [self addSubview:_mTableView];
        [self setExtraCellLineHidden:_mTableView];
       
        //如果设置了tableview的dataLoadDelegate，请在viewController销毁时将tableview的dataLoadDelegate置空，这样可以避免一些可能的delegate问题，虽然我有在tableview的dealloc方法中将其置空
        
        _mLoadingWaitView = [[UIView alloc] initWithFrame:self.bounds];
        _mLoadingWaitView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        _mLoadingWaitView.autoresizesSubviews = YES;
        _mLoadingWaitView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _mLoadingStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width-300)/2, 210, 300, 21)];
        _mLoadingStatusLabel.backgroundColor = [UIColor clearColor];
        _mLoadingStatusLabel.textColor = [UIColor darkGrayColor];
        _mLoadingStatusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        _mLoadingStatusLabel.text = @"努力加载数据中...";
        _mLoadingStatusLabel.textAlignment = NSTextAlignmentCenter;
        _mLoadingStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_mLoadingWaitView addSubview:_mLoadingStatusLabel];
        
        _mLoadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _mLoadingActivityIndicator.backgroundColor = [UIColor clearColor];
        _mLoadingActivityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _mLoadingActivityIndicator.frame = CGRectMake((self.bounds.size.width-30)/2, 170, 30, 30);
        [_mLoadingWaitView addSubview:_mLoadingActivityIndicator];
        
        [_mLoadingActivityIndicator startAnimating];
        
        [self insertSubview:_mLoadingWaitView aboveSubview:_mTableView];
        
        [_mTableView requestPromoterDataInBackground];
    }
    return self;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

#pragma mark - UITableViewDataSource Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!_mTableView.mIsAllLoaded && [_mTableView.mPromoterDatas count] > 0)
    {
        return [_mTableView.mPromoterDatas count] + 1;
    }
    else if (_mTableView.mIsAllLoaded && [_mTableView.mPromoterDatas count] > 0)
    {
        return [_mTableView.mPromoterDatas count];
    }
    else 
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UMUFPTableViewCell";
    
    if (indexPath.row < [_mTableView.mPromoterDatas count])
    {
        UMTableViewCell *cell = (UMTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UMTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        NSDictionary *promoter = [_mTableView.mPromoterDatas objectAtIndex:indexPath.row];
        cell.textLabel.text = [promoter valueForKey:@"title"];
        cell.detailTextLabel.text = [promoter valueForKey:@"ad_words"];
        [cell setImageURL:[promoter valueForKey:@"icon"]];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        return cell;
    }
    else
    {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"UMUFPTableViewCell2"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UMUFPTableViewCell2"] autorelease];
//            UIView *bgimageSel = [[UIView alloc] initWithFrame:cell.bounds];
//            bgimageSel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.4];
//            cell.selectedBackgroundView = bgimageSel;
//            [bgimageSel release];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        for (UIView *view in cell.subviews)
        {
            [view removeFromSuperview];
        }
        if (indexPath.row>5) {
            UILabel *addMoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 20, 120, 30)] autorelease];
            addMoreLabel.backgroundColor = [UIColor clearColor];
            addMoreLabel.textAlignment = NSTextAlignmentCenter;
            addMoreLabel.font = [UIFont boldSystemFontOfSize:14];
            addMoreLabel.textColor = [UIColor darkGrayColor];
            addMoreLabel.text = @"加载中...";
            [cell addSubview:addMoreLabel];
            
            UIActivityIndicatorView *loadingIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            loadingIndicator.backgroundColor = [UIColor clearColor];
            loadingIndicator.frame = CGRectMake(115, 20, 30, 30);
            [loadingIndicator startAnimating];
            [cell addSubview:loadingIndicator];
        }
        return cell;
    }    
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [_mTableView.mPromoterDatas count])
    {
        NSDictionary *promoter = [_mTableView.mPromoterDatas objectAtIndex:indexPath.row];
        [_mTableView didClickPromoterAtIndex:promoter index:indexPath.row];
    }
}

#pragma mark - UMTableViewDataLoadDelegate methods

- (void)removeLoadingMaskView {
    
    if ([_mLoadingWaitView superview])
    {        
        [_mLoadingWaitView removeFromSuperview];
    }
}

- (void)loadDataFailed {
    
    _mLoadingActivityIndicator.hidden = YES;
    
    if (!_mNoNetworkImageView)
    {
        UIImage *image = [UIImage imageNamed:@"um_no_network.png"];
        CGSize imageSize = image.size;
        _mNoNetworkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_mLoadingWaitView.bounds.size.width - imageSize.width) / 2, 80, imageSize.width, imageSize.height)];
        _mNoNetworkImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _mNoNetworkImageView.image = image;
    }
    
    if (![_mNoNetworkImageView superview])
    {
        [_mLoadingWaitView addSubview:_mNoNetworkImageView];
    }
    
    _mLoadingStatusLabel.text = @"亲，您的网络不给力啊";
}

- (void)UMUFPTableViewDidLoadDataFinish:(UMUFPTableView *)tableview promoters:(NSArray *)promoters {
    
    if ([promoters count] > 0)
    {
        [self removeLoadingMaskView];
        
        [_mTableView reloadData];
    }  
    else if ([_mTableView.mPromoterDatas count])
    {
        [_mTableView reloadData];
    }
    else 
    {
        [self loadDataFailed];
    }
    [_mTableView requestMorePromoterInBackground];
}

- (void)UMUFPTableView:(UMUFPTableView *)tableview didLoadDataFailWithError:(NSError *)error {
    
    if ([_mTableView.mPromoterDatas count])
    {
        [_mTableView reloadData];
    }
    else 
    {
        [self loadDataFailed];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize contentSize = scrollView.contentSize;
    UIEdgeInsets contentInset = scrollView.contentInset;
    
    float y = contentOffset.y + bounds.size.height - contentInset.bottom;
    if (y > contentSize.height-30) 
    {
        if (!_mTableView.mIsAllLoaded)
        {
            [_mTableView requestMorePromoterInBackground];
        }
    }    
}

@end
