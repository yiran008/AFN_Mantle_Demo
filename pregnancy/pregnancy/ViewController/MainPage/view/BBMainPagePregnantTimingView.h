//
//  BBMainPagePregnantTimingView.h
//  BBProgressView
//
//  Created by liumiao on 5/12/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMainPagePregnantTimingView : UIView
@property (assign)BOOL m_HasDisplayedProgressAnimation;
-(void)displayProgressAnimation;
-(void)reload;
-(void)addButtonActionWithTarget:(id)target selector:(SEL)selector;
@end



