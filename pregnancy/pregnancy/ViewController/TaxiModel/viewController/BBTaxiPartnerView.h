//
//  BBTaxiPartnerView.h
//  pregnancy
//
//  Created by whl on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTaxiPartnerView : UIView

@property(assign)NSInteger patrnerCount;

- (id)initWithFrame:(CGRect)frame withDiction:(NSArray*)partnerArray withPartnerTitle:(NSString*)partnerTitle;

@end
