//
//  HMPopTitleListButton.m
//  lama
//
//  Created by songxf on 13-6-21.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMPopTitleListButton.h"
#import "UIView+Size.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMPopTitleListButton
@synthesize dataList;
@synthesize delegate;
@synthesize defaultControl;
@synthesize showTitleList;


- (id)init
{
    CGRect frame = CGRectMake((320-POPLIST_CELLWIDHT)/2, 20, POPLIST_CELLWIDHT, POPLIST_BUTTON_HEIGHT);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }
    return self;

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataList:(NSArray *)data
{
    return [self initWithFrame:frame dataList:data showList:data];
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        [self initView];
//        self.dataList = data;
//    }
//    return self;
//
}

- (id)initWithFrame:(CGRect)frame dataList:(NSArray *)data showList:(NSArray *)arr;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showTitleList = arr;
        [self initView];
        self.dataList = data;
    }
    return self;
}

- (void)initView
{
    self.exclusiveTouch = YES;
    self.userInteractionEnabled = YES;
    [self addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
    
    titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.frame = CGRectMake(0, 0, POPLIST_CELLWIDHT-20, UI_NAVIGATION_BAR_HEIGHT-5);
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    triangleImageView = [[UIImageView alloc] init];
    triangleImageView.image = [UIImage imageNamed:@"popList_triangle_icon"];
    triangleImageView.frame = CGRectMake(POPLIST_CELLWIDHT-20, (POPLIST_CELLHEIGHT-6)/2+2, 10, 6);
    triangleImageView.userInteractionEnabled = NO;
    [self addSubview:triangleImageView];

    listBgImageView = [[UIImageView alloc] init];
    listBgImageView.userInteractionEnabled = YES;
    [self addSubview:listBgImageView];
    UIImage *bgImage = [UIImage imageNamed:@"popList_background_image"];
    listBgImageView.image = [bgImage stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    [listBgImageView.layer setCornerRadius:5];

    listview = [[UITableView alloc] init];
    listview.backgroundColor = [UIColor clearColor];
    listview.dataSource = self;
    listview.separatorColor = [UIColor clearColor];
    listview.delegate = self;
    listview.rowHeight = POPLIST_CELLHEIGHT;
    [listBgImageView addSubview:listview];
    
    listBgImageView.frame = CGRectMake((self.frame.size.width-POPLIST_CELLWIDHT)/2, POPLIST_BUTTON_HEIGHT, POPLIST_CELLWIDHT, 0);
    listview.frame = CGRectMake(10, 12, POPLIST_CELLWIDHT-20, 0);
}

- (void)setDataList:(NSArray *)data
{
    dataList = data;
    [listview reloadData];
    
    if (showTitleList == nil)
    {
        self.showTitleList = data;
    }
}

- (void)setShowTitleList:(NSArray *)data
{
    showTitleList = data;
    titleLab.text = [showTitleList objectAtIndex:0];
    
    CGSize size = [titleLab.text sizeWithFont:titleLab.font constrainedToSize:titleLab.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat left = (POPLIST_CELLWIDHT-20-size.width)/2+size.width+10;
    triangleImageView.left = left;
}

- (void)changeState
{
    NSLog(@"changeState");

  //     [listview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:highLightIndex inSection:0]].backgroundView
    if (!isListShow)
    {
        [self showList];
    }
    else
    {
        [self dismissList];
    }
}

- (void)showList
{
    isListShow = !isListShow;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationWillStartSelector:@selector(startAnimations)];
    [UIView setAnimationDidStopSelector:@selector(endAnimations)];
    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, POPLIST_CELLWIDHT, POPLIST_BUTTON_HEIGHT +POPLIST_CELLHEIGHT*[dataList count]+14);
    
    self.height = POPLIST_BUTTON_HEIGHT +POPLIST_CELLHEIGHT*[dataList count]+14;

    listBgImageView.height = POPLIST_CELLHEIGHT*[dataList count]+20;
    listview.height = listBgImageView.frame.size.height-15;


    [UIView commitAnimations];
    /*start  将poplist改为选中项恒带背景*/
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 2, POPLIST_CELLWIDHT-20, POPLIST_CELLHEIGHT-4);
    bgView.backgroundColor = [UIColor colorWithHex:0x999999];
    bgView.tag=10000;
    [bgView.layer setCornerRadius:3.0];
    HMPopListCell * thisCell = (HMPopListCell *)[listview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:highLightIndex inSection:0]];
    thisCell.backgroundView = bgView;
    thisCell.titleLab.textColor = [UIColor whiteColor];
    for (NSInteger i=0; i<[dataList count]; i++)
    {
        if (i != highLightIndex) {
            HMPopListCell * cell = (HMPopListCell *)[listview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
            if( cell.backgroundView.tag == 10000)
            {
                cell.backgroundView  = nil;
            }
            cell.titleLab.textColor = [UIColor colorWithHex:0x999999];
        }
    }
    /*end   by hyy*/
    self.defaultControl = [[UIControl alloc] init];
    defaultControl.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    [defaultControl addTarget:self action:@selector(dismissList) forControlEvents:UIControlEventTouchUpInside];
    defaultControl.backgroundColor = [UIColor clearColor];
    [self.superview insertSubview:defaultControl belowSubview:self];
    triangleImageView.transform = CGAffineTransformMakeRotation(3.1415926);
}

- (void)dismissList
{
    isListShow = !isListShow;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationWillStartSelector:@selector(startAnimations)];
    [UIView setAnimationDidStopSelector:@selector(endAnimations)];
    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, POPLIST_CELLWIDHT, POPLIST_BUTTON_HEIGHT);
    
    self.height = POPLIST_BUTTON_HEIGHT;

    listBgImageView.height = 0;
    listview.height = 0;
    [UIView commitAnimations];
    
    [defaultControl removeFromSuperview];
    self.defaultControl = nil;
    triangleImageView.transform = CGAffineTransformIdentity;

}

- (void)startAnimations
{
    self.window.userInteractionEnabled = NO;
}

- (void)endAnimations
{
    self.window.userInteractionEnabled = YES;
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    HMPopListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HMPopListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.titleLab.text = [dataList objectAtIndex:[indexPath row]];
   // cell.titleLab.backgroundColor = [UIColor blueColor];
    cell.titleLab.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissList];
    
    if (highLightIndex == indexPath.row)
    {
        return;
    }
    
    highLightIndex = indexPath.row;
    titleLab.text = [showTitleList objectAtIndex:highLightIndex];
    
    CGSize size = [titleLab.text sizeWithFont:titleLab.font constrainedToSize:titleLab.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat left = (POPLIST_CELLWIDHT-20-size.width)/2+size.width+10;
    triangleImageView.left = left;

    
    if ([delegate respondsToSelector:@selector(popTitleListDidSelectedRow:)])
    {
        [delegate popTitleListDidSelectedRow:highLightIndex];
    }
}

@end



@implementation HMPopListCell
@synthesize titleLab;
@synthesize bgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 2, POPLIST_CELLWIDHT-20, POPLIST_CELLHEIGHT-4);
        [self.contentView addSubview:bgView];
        [bgView.layer setCornerRadius:3.0];

        UILabel *lab = [[UILabel alloc] init];
        self.titleLab = lab;
        lab.frame = CGRectMake(0, 2, POPLIST_CELLWIDHT-20, POPLIST_CELLHEIGHT-4);
        [titleLab setFont:[UIFont systemFontOfSize:19]];
        [self.contentView addSubview:lab];
        titleLab.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted)
    {
       // bgView.backgroundColor = [UIColor colorWithRed:244/255.0 green:150/255.0 blue:143/255.0 alpha:1.0];
        bgView.backgroundColor = [UIColor colorWithHex:0x999999];
        titleLab.textColor = [UIColor whiteColor];
    }
    else
    {
        bgView.backgroundColor = [UIColor clearColor];
        /*start  将poplist改为选中项恒带背景*/
        if (self.backgroundView.tag != 10000)
        {
            titleLab.textColor = [UIColor colorWithHex:0x999999];
        }
        /*end   by hyy*/
    }
    
}


@end
