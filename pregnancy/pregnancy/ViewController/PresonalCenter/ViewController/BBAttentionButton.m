//
//  BBAttentionButton.m
//  pregnancy
//
//  Created by MacBook on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBAttentionButton.h"

@interface BBAttentionButton()

@property (nonatomic, strong)NSDictionary *s_ButtonStateImageNameDict;

@end

@implementation BBAttentionButton

- (void)dealloc
{
    [_addAttentionRequest clearDelegatesAndCancel];
    [_cancelAttentionRequest clearDelegatesAndCancel];
}

- (id)initWithFrame:(CGRect)frame withType:(AttentionType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
    
        [self freshAttentionStatus:type];
        
    }
    return self;
}

- (void)initAttentionButton
{
    self.exclusiveTouch = YES;
    
    self.hidden = NO;
    NSString *own_uid = [BBUser getEncId];
    if(![self.u_id isNotEmpty] || [self.u_id isEqualToString:own_uid])
    {
        self.hidden = YES;
    }
    [self addTarget:self action:@selector(changeAttentionStatus:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeButtonStateImageWithDict:(NSDictionary*)dict
{
    self.s_ButtonStateImageNameDict = [[NSDictionary alloc]initWithDictionary:dict];
}

- (void)freshAttentionStatus:(AttentionType)type
{
    [self initAttentionButton];
    currentAttentionType = type;
    
    if (![self.s_ButtonStateImageNameDict isNotEmpty])
    {
        self.s_ButtonStateImageNameDict = [[NSDictionary alloc]init];
    }
    
    NSString *normal = @"";
    NSString *pressed = @"";
    if(type == AttentionType_Add_Attention || type == AttentionType_Be_Attention)
    {
        normal = [self.s_ButtonStateImageNameDict stringForKey:STATE_ADD_NORMAL defaultString:@"personal_addAttention"];
        pressed = [self.s_ButtonStateImageNameDict stringForKey:STATE_ADD_PRESSED defaultString:@"personal_addAttention_pressed"];
    }
    else if(type == AttentionType_Had_Attention)
    {
        normal = [self.s_ButtonStateImageNameDict stringForKey:STATE_HAD_NORMAL defaultString:@"personal_hadAttention"];
        pressed = [self.s_ButtonStateImageNameDict stringForKey:STATE_HAD_PRESSED defaultString:@"personal_hadAttention_pressed"];
    }
    else if(type == AttentionType_Both_Attention)
    {
        normal = [self.s_ButtonStateImageNameDict stringForKey:STATE_BOTH_NORMAL defaultString:@"personal_bothAttention"];
        pressed = [self.s_ButtonStateImageNameDict stringForKey:STATE_BOTH_PRESSED defaultString:@"personal_bothAttention_pressed"];
    }
    [self setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:pressed] forState:UIControlStateSelected | UIControlStateHighlighted];
}



- (void)sendAttentionRequestWithType:(AttentionType)type
{
    if (self.addAttentionRequest != nil)
    {
        [self.addAttentionRequest clearDelegatesAndCancel];
    }
    
    if(self.cancelAttentionRequest != nil)
    {
        [self.cancelAttentionRequest clearDelegatesAndCancel];
    }
    
    if(![self.u_id isNotEmpty] || [self.u_id isEqualToString:[BBUser getEncId]])
    {
        self.hidden = YES;
        return;
    }
    
    if(currentAttentionType == AttentionType_Add_Attention ||currentAttentionType == AttentionType_Be_Attention)
    {
        self.addAttentionRequest = [BBAttentionRequest addFollow:self.u_id];
        [self.addAttentionRequest setDidFinishSelector:@selector(changeAttentionFinished:)];
        [self.addAttentionRequest setDidFailSelector:@selector(changeAttentionFail:)];
        [self.addAttentionRequest setDelegate:self];
        [self.addAttentionRequest startAsynchronous];
    }
    else if(currentAttentionType == AttentionType_Had_Attention || currentAttentionType == AttentionType_Both_Attention)
    {
        self.cancelAttentionRequest = [BBAttentionRequest cancelFollow:self.u_id];
        [self.cancelAttentionRequest setDidFinishSelector:@selector(changeAttentionFinished:)];
        [self.cancelAttentionRequest setDidFailSelector:@selector(changeAttentionFail:)];
        [self.cancelAttentionRequest setDelegate:self];
        [self.cancelAttentionRequest startAsynchronous];
    }
}


- (void)changeAttentionStatus:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(shouldAddAttention)])
    {
        if([self.delegate shouldAddAttention])
        {
            [self sendAttentionRequestWithType:currentAttentionType];
        }
    }
}

#pragma mark -
#pragma mark - AddAttention result
- (void)changeAttentionFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
    if (![dictData isDictionaryAndNotEmpty])
    {
        return ;
    }
    if ([[dictData objectForKey:@"status"] isEqualToString:@"success"])
    {
        NSString *follow_status = [[dictData dictionaryForKey:@"data"] stringForKey:@"follow_status"];
        if([follow_status isEqualToString:@"1"])
        {
            [MobClick event:@"my_center_v2" label:@"成功关注数"];
            currentAttentionType = AttentionType_Both_Attention;
        }
        else if([follow_status isEqualToString:@"2"])
        {
            [MobClick event:@"my_center_v2" label:@"成功关注数"];
            currentAttentionType = AttentionType_Had_Attention;
        }
        else if([follow_status isEqualToString:@"3"])
        {
            [MobClick event:@"my_center_v2" label:@"成功取消关注数"];
            currentAttentionType = AttentionType_Be_Attention;
        }
        else if([follow_status isEqualToString:@"4"])
        {
            [MobClick event:@"my_center_v2" label:@"成功取消关注数"];
            currentAttentionType = AttentionType_Add_Attention;
        }
        [self freshAttentionStatus:currentAttentionType];
        
        if ([self.delegate respondsToSelector:@selector(changeAttentionStatusFinish:withAttentionType:)])
        {
            [self.delegate changeAttentionStatusFinish:self withAttentionType:currentAttentionType];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(changeAttentionStatusFail:withAttentionType:)])
        {
            [self.delegate changeAttentionStatusFail:self withAttentionType:currentAttentionType];
        }
    }
}


- (void)changeAttentionFail:(ASIFormDataRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(changeAttentionStatusFail:withAttentionType:)])
    {
        [self.delegate changeAttentionStatusFail:self withAttentionType:currentAttentionType];
    }
}



@end
