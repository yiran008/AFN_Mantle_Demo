//
//  BBFeedCell.h
//  pregnancy
//
//  Created by liumiao on 9/10/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFeedClass.h" 
@interface BBFeedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *userAvatarButton;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *babyAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTSLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicSummuryLabel;
@property (strong, nonatomic) IBOutlet UILabel *circleLabel;
@property (strong, nonatomic) IBOutlet UILabel *responceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *responceIcon;
@property (strong, nonatomic) IBOutlet UIImageView *picIcon;
@property (strong, nonatomic) IBOutlet UIImageView *eliteIcon;
@property (strong, nonatomic) IBOutlet UIImageView *helpIcon;
- (void)setCellWithData:(BBFeedClass *)feedClass;
@end
