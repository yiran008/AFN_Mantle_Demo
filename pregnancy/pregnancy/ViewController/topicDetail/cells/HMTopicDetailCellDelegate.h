//
//  HMTopicDetailCellDelegate.h
//  lama
//
//  Created by 王 鸿禄 on 13-5-9.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMTopicDetailCellClass;

@protocol HMTopicDetailCellDelegate <NSObject>

@required
- (void)replyFloorDelegate:(NSString *)replyFloor withReplyID:(NSString *)replyFloorID;
- (void)deleteTopicClicked;

- (void)pressLoveButton;

- (void)hideBackButtom;

- (void)setFloorWithPicIndex:(NSInteger)index;
- (void)setFloorWithTopicId:(NSString *)topicId floor:(NSInteger)floor;

- (NSString *)theTopicIdAboutDetail;

- (void)closeMJPhotoShow;

@optional
//- (void)topicClicked:(NSDictionary *)detailData isLongClick:(BOOL)isLongClick;
- (void)topicClicked:(HMTopicDetailCellClass *)detailData isLong:(BOOL)isLong;

- (void)adClicked:(NSString *)adUrl title:(NSString *)adTitle;

@end
