//
//  BBSelectRegisterController.h
//  pregnancy
//
//  Created by whl on 13-10-23.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRegister.h"
#import "BBNumberRegister.h"


@protocol BBSelectRegisterDelegate <NSObject>

- (void)selectRegisterFinish;

@end

@interface BBSelectRegisterController : BaseViewController<BBRegisterDelegate,BBNumberRegisterDelegate>

@property(assign) id<BBSelectRegisterDelegate> delegate;

@end
