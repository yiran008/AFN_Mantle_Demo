//
//  BBKuaidiPlaceCell.h
//  pregnancy
//
//  Created by ZHENGLEI on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBKuaidiPlaceCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel * mainLabel;
@property(nonatomic,retain)IBOutlet UILabel * infoLabel;
@property(nonatomic,retain)IBOutlet UIImageView * icon;

- (void)setSugestData:(NSDictionary *)dic;
- (void)setGeoArrData:(NSDictionary *)dic;
- (void)setGeoStrData:(NSString *)str;

@end
