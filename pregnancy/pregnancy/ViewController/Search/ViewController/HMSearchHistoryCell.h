//
//  HMSearchHistoryCell.h
//  lama
//
//  Created by songxf on 14-1-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMSearchHistoryCellDelegate <NSObject>
// 删除单条搜索历史记录，后续需根据需要添加字段
- (void)deleteHistory:(NSInteger)index;

@end

#define SEARCH_HISTORY_CELL_HEIGHT  36

@interface HMSearchHistoryCell : UITableViewCell

@property (nonatomic,retain) UILabel *contentLabel;
@property (nonatomic,retain) UIButton *deleteButton;
@property (nonatomic,assign) id<HMSearchHistoryCellDelegate> delegate;
// 记录删除的indexPath
@property (nonatomic,assign) NSInteger theIndexPath;

- (void)setContent:(NSString *)str isRubbish:(BOOL)rubbish;

@end
