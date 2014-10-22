//
//  BBRollCycleView.m
//  pregnancy
//
//  Created by whl on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBRollCycleView.h"

@implementation BBRollCycleView

- (void)dealloc {
    [_rollFristLabel release];
    [_rollSecondLabel release];
    [_contentArray release];
    [_timer release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rollFristLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, frame.size.height)]autorelease];
        [_rollFristLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_rollFristLabel setTextColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]];
        [self addSubview:_rollFristLabel];
        _rollSecondLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height, 220, frame.size.height)]autorelease];
        [_rollSecondLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_rollSecondLabel setTextColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]];
        [_rollFristLabel setBackgroundColor:[UIColor clearColor]];
        [_rollSecondLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rollSecondLabel];
        _isRoll = NO;
        self.clipsToBounds = YES;
        self.indexCount =0;
    }
    return self;
}

- (void)resetTimer
{
    [self stopTimer];
    [self changeText];
    [self startTimer];
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)changeText {
    
    if ([self.contentArray count]>0) {
        if (_rollFristLabel.frame.origin.y==0) {
            if (self.indexCount < [self.contentArray count] ) {
                
                [_rollSecondLabel setText:[NSString stringWithFormat:@"公告：%@ 获得打车返现%@元",[BBStringLengthByCount subStringByCount:[[self.contentArray objectAtIndex:self.indexCount]stringForKey:@"nickname"] withCount:10],[[self.contentArray objectAtIndex:self.indexCount]stringForKey:@"money"]]];
            }
            self.indexCount++;
            if (self.indexCount == [self.contentArray count]) {
                self.indexCount = 0;
            }
        }else{
            if (self.indexCount < [self.contentArray count] ) {
                [_rollFristLabel setText:[NSString stringWithFormat:@"公告：%@ 获得打车返现%@元",[BBStringLengthByCount subStringByCount:[[self.contentArray objectAtIndex:self.indexCount]stringForKey:@"nickname"] withCount:10],[[self.contentArray objectAtIndex:self.indexCount]stringForKey:@"money"]]];
            }
            self.indexCount++;
            if (self.indexCount == [self.contentArray count]) {
                self.indexCount = 0;
            }
        }

    }
    else if (self.strArray && [self.strArray count]>0)
    {
        _rollFristLabel.frame = CGRectMake(_rollFristLabel.frame.origin.x, _rollFristLabel.frame.origin.y, self.frame.size.width, self.frame.size.height);
        _rollSecondLabel.frame = CGRectMake(_rollSecondLabel.frame.origin.x, _rollSecondLabel.frame.origin.y, self.frame.size.width, self.frame.size.height);
        if (self.indexCount < [self.strArray count] )
        {
            [_rollFristLabel setText:[self.strArray objectAtIndex:self.indexCount]];
            _rollFristLabel.textColor = [UIColor whiteColor];
        }
        self.indexCount++;
        if (self.indexCount == [self.strArray count])
        {
            self.indexCount = 0;
        }
        if (self.indexCount < [self.strArray count] )
        {
            [_rollSecondLabel setText:[self.strArray objectAtIndex:self.indexCount]];
            _rollSecondLabel.textColor = [UIColor whiteColor];
        }
        self.indexCount++;
        if (self.indexCount == [self.strArray count]) {
            self.indexCount = 0;
        }
    }
    
    if (!self.isRoll) {
        self.isRoll = YES;
        [UIView animateWithDuration:.5 animations:^{
            [_rollSecondLabel setFrame:CGRectMake(_rollSecondLabel.frame.origin.x, 0, _rollSecondLabel.frame.size.width, _rollSecondLabel.frame.size.height)];
            [_rollFristLabel setFrame:CGRectMake(_rollFristLabel.frame.origin.x, -20, _rollFristLabel.frame.size.width, _rollFristLabel.frame.size.height)];
        }completion:^(BOOL finished) {
            [_rollFristLabel setFrame:CGRectMake(_rollFristLabel.frame.origin.x, _rollFristLabel.frame.size.height, _rollFristLabel.frame.size.width, _rollFristLabel.frame.size.height)];
        }];
    }else{
        self.isRoll = NO;
        [UIView animateWithDuration:.5 animations:^{
            [_rollFristLabel setFrame:CGRectMake(_rollFristLabel.frame.origin.x, 0, _rollFristLabel.frame.size.width, _rollFristLabel.frame.size.height)];
            [_rollSecondLabel setFrame:CGRectMake(_rollSecondLabel.frame.origin.x, -20, _rollSecondLabel.frame.size.width, _rollSecondLabel.frame.size.height)];
        }completion:^(BOOL finished) {
            [_rollSecondLabel setFrame:CGRectMake(_rollSecondLabel.frame.origin.x, _rollSecondLabel.frame.size.height, _rollSecondLabel.frame.size.width, _rollSecondLabel.frame.size.height)];
        }];
    }
}

@end
