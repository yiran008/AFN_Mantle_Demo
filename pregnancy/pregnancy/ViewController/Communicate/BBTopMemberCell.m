//
//  BBTopMemberCell.m
//  pregnancy
//
//  Created by whl on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBTopMemberCell.h"

@implementation BBTopMemberCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.m_RuleButton.exclusiveTouch = YES;

    }
    return self;
}

-(IBAction)clickedRuleButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickedTopMemberRule)])
    {
        [self.delegate clickedTopMemberRule];
    }
}

@end
