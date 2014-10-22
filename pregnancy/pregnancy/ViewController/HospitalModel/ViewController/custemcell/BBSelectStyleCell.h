//
//  BBSelectStyleCell.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSelectStyleCell : UITableViewCell{
    UILabel *titleLabel;
    UIImageView *arrowImageView;
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *arrowImageView;

- (BBSelectStyleCell *)setCellTietle:(NSString *)title;
@end
