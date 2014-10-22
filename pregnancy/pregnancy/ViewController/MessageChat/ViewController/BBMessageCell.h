//
//  BBMessageCell.h
//  pregnancy
//
//  Created by mac on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMessageCellLeftView.h"
#import "BBMessageCellRightView.h"
#import "BBMessageChatDelegate.h"
@interface BBMessageCell : UITableViewCell
{ 
}

@property(nonatomic,strong)BBMessageCellLeftView *chatLeftView;
@property(nonatomic,strong)BBMessageCellRightView *chatRightView;

- (void)setContent:(NSDictionary *)messageData withEditStatus:(BOOL)editStatus withSelectStatus:(BOOL)selectStatus withBBMessageChatDelegate:(id<BBMessageChatDelegate>)messageChatDelegate;

+ (CGFloat)calculateHeightWithContent:(NSDictionary *)messageData;
@end
