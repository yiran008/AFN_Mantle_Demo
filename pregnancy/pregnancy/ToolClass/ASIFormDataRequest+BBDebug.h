//
//  ASIFormDataRequest+BBDebug.h
//  pregnancy
//
//  Created by Wang Jun on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "ASIFormDataRequest.h"

@interface ASIFormDataRequest (BBDebug)

- (void)logUrlPrama;

#ifdef DEBUG

- (void)startSynchronous;

- (void)startAsynchronous;
#endif
@end
