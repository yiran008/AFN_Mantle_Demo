//
//  BBSelectHospitalAreaCell.h
//  pregnancy
//
//  Created by babytree babytree on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSelectHospitalAreaCell : UITableViewCell
{
    UILabel *text;
    UIImageView *rightImage;
}
@property(nonatomic,strong)IBOutlet UILabel *text;
@property(nonatomic,strong)IBOutlet UIImageView *rightImage;
@end
