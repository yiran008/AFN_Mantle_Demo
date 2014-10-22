//
//  BBFeedClass.m
//  pregnancy
//
//  Created by liumiao on 9/10/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBFeedClass.h"


@implementation BBFeedClass

- (id)init
{
    self = [super init];
    if (self)
    {
        _m_CellHeight = 0;
    }
    return self;
}

-(CGFloat)cellHeight
{
    CGFloat height = 8+8+40+10+14+8;
    if ([self.m_Summary isNotEmpty])
    {
        height += (18+5);
    }
    if ([self.m_Title isNotEmpty])
    {
        NSString *title = [self.m_Title copy];
        if (self.m_HasPic)
        {
            title = [NSString stringWithFormat:@"%@%@",ICON_HOLDER_STRING,title];
        }
        if (self.m_IsElite)
        {
            title = [NSString stringWithFormat:@"%@%@",ICON_HOLDER_STRING,title];
        }
        if (self.m_IsHelp)
        {
            title = [NSString stringWithFormat:@"%@%@",ICON_HOLDER_STRING,title];
        }
        CGSize onelineSize = [title calcSizeWithFont:[UIFont systemFontOfSize:16]];
        if (onelineSize.width > 296)
        {
            height += (40+5);
        }
        else
        {
            height += (20+5);
        }
    }
    return height;
}
@end
