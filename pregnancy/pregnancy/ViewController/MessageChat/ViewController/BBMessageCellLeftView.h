//
//  BBMessageLeftCell.h
//  pregnancy
//
//  Created by mac on 12-12-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTimeUtility.h"
#import "BBMessageChatDelegate.h"
@interface BBMessageCellLeftView : UIView

@property(nonatomic,strong)IBOutlet UILabel *dateLabel;
@property(nonatomic,strong)IBOutlet UILabel *contentLabel;
@property(nonatomic,strong)IBOutlet UIImageView *contentLabelBg;
@property(nonatomic,strong)IBOutlet UIButton *avtarButton;
@property(nonatomic,strong)IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UIButton *linkButton;
@property (strong, nonatomic) IBOutlet UIView *tipBackView;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property(nonatomic,strong)NSDictionary *data;
@property(assign)BOOL selectStatusValue;
@property(assign)id<BBMessageChatDelegate> messageChatDelegate;
- (IBAction)pressLinkButton:(id)sender;
-(void)setData:(NSDictionary *)commentData withEditStatus:(BOOL)editStatus withSelectStatus:(BOOL)selectStatus withBBMessageChatDelegate:(id<BBMessageChatDelegate>)delegate;
+ (CGFloat)calculateHeightWithContent:(NSDictionary *)messageData;
@end