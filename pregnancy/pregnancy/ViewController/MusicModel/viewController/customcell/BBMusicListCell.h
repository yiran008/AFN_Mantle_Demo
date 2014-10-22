//
//  BBMusicListCell.h
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBMusicListDelegate;


typedef enum  {
    listCellType        = 0,
    downloadCellType    = 1
}CellType;

@interface BBMusicListCell : UITableViewCell
@property (nonatomic, assign) NSInteger     indexOfRow;
@property (nonatomic, assign) id<BBMusicListDelegate>delegate;
@property (nonatomic, retain) NSDictionary          *musicInfo;
@property (nonatomic, assign) CellType      cellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier musicInfo:(NSDictionary *)info;
- (void)resetCell;
- (void)changeStatusWith:(int)status;
- (void)setCellPlaying;
- (void)cancelCellPlaying;
@end

@protocol BBMusicListDelegate <NSObject>

- (void)downloadMusic:(BBMusicListCell *)listCell;
- (void)deleteMusic:(BBMusicListCell *)listCell;
@end
