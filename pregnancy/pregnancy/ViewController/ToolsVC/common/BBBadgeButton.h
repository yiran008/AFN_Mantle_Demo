//
//  BBBadgeButton.h
//  pregnancy
//
//  Created by liumiao on 4/21/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBBadgeButton : UIButton

@property (nonatomic, strong)id m_IndexData;

- (void)setTipNumber:(NSString*)badgeCount;
- (void)setNewState:(BOOL)isNew;
@end
