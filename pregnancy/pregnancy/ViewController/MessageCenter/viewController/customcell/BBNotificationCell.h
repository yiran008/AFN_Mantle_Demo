//
//  BBTopicMessageCell.h
//  pregnancy
//
//  Created by Wang Jun on 12-11-20.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@interface BBNotificationCell : UITableViewCell {
    
}

@property (nonatomic, strong) OHAttributedLabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) UIImageView *cellLineImageView;
//@property (nonatomic,strong) UIImageView *selectedBg;
+ (CGFloat)heightForCellWithData:(NSDictionary *)theData;

- (void)setCellWithData:(NSDictionary *)theData;

@end
