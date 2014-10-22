//
//  BBMessageListUserListCell.h
//  pregnancy
//
//  Created by babytree on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMessageListUserListCell : UITableViewCell
@property (nonatomic, strong)  UIImageView *avtarImageView;
@property (nonatomic, strong)  UILabel *username;
@property (nonatomic, strong)  UILabel *unreadMessageCount;
@property (nonatomic, strong)  UILabel *messageContent;

- (void)setCellWithData:(NSDictionary *)theData;
@end
