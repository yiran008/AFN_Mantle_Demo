//
//  HMPopTitleListButton.h
//  lama
//
//  Created by songxf on 13-6-21.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define POPLIST_BUTTON_HEIGHT  40
#define POPLIST_CELLHEIGHT  36
#define POPLIST_CELLWIDHT   199


@protocol HMPopTitleListDelegate <NSObject>

- (void)popTitleListDidSelectedRow:(NSInteger)row;

@end


@interface HMPopTitleListButton : UIButton
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    // 文字内容
    UILabel *titleLab;
    // 展示三角形图片
    UIImageView *triangleImageView;
    
    BOOL isListShow;
    
    // list背景图
    UIImageView *listBgImageView;
    // 展示title文字的TableView
    UITableView *listview;
    
    NSInteger highLightIndex;
    NSInteger selectIndexNum;
}

// 下来出来的标题  title数据
@property (nonatomic,strong) NSArray *dataList;

//
@property (nonatomic,strong) UIControl *defaultControl;
// 选中后的回调
@property (assign) id<HMPopTitleListDelegate> delegate;

// 显示出来的标题
@property (nonatomic,retain) NSArray *showTitleList;


- (id)initWithFrame:(CGRect)frame dataList:(NSArray *)data;
- (id)initWithFrame:(CGRect)frame dataList:(NSArray *)data showList:(NSArray *)arr;

@end


@interface HMPopListCell : UITableViewCell
{
    
}

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@end

