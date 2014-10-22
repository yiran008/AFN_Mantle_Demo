//
//  ASIFormDataRequest+BBDebug.m
//  pregnancy
//
//  Created by Wang Jun on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "ASIFormDataRequest+BBDebug.h"
#ifdef DEBUG
#import "BBConfigureAPI.h"
#endif
@implementation ASIFormDataRequest (BBDebug)

- (void)logUrlPrama
{
    NSMutableString *str = [[[NSMutableString alloc] initWithCapacity:0] autorelease];

    for (NSDictionary *item in postData)
    {
        NSString *key = [item objectForKey:@"key"];
        NSString *value = [item objectForKey:@"value"];

        if (str.length == 0)
        {
            [str appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        else
        {
            [str appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }
    }

    if (str.length==0) {
        NSLog([[url absoluteString] rangeOfString:@"?"].location == NSNotFound ? @"%@?%@" : @"%@%@", [url absoluteString], str);
    }else{
        NSLog([[url absoluteString] rangeOfString:@"?"].location == NSNotFound ? @"%@?%@" : @"%@&%@", [url absoluteString], str);
    }
}



#ifdef DEBUG
- (void)startSynchronous
{
    [super startSynchronous];
    if (API_URL_PRAMA_AVAILABLE)
    {
        [self logUrlPrama];
    }
}

- (void)startAsynchronous
{
    [super startAsynchronous];
    if (API_URL_PRAMA_AVAILABLE)
    {
        [self logUrlPrama];
    }
}
#endif
@end
