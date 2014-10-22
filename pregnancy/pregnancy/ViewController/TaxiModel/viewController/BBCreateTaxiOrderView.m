//
//  BBCreateTaxiOrderView.m
//  pregnancy
//
//  Created by whl on 13-12-17.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBCreateTaxiOrderView.h"
#import "BBAcceptedTaxiOrders.h"
#import "BBCallTaxiRequest.h"

@implementation BBCreateTaxiOrderView

- (void)dealloc
{
    [_timer release];
    [_taxiRequest clearDelegatesAndCancel];
    [_taxiRequest release];
    [_cancelTaxiRequest clearDelegatesAndCancel];
    [_cancelTaxiRequest release];
    [_createTaxiRequest clearDelegatesAndCancel];
    [_createTaxiRequest release];
    [_orderID release];
    [_callDriverView release];
    [_callDriverLabel release];
    [_cancelCallView release];
    [_scrollTimer release];
    [_userPhone release];
    [_fromAddress release];
    [_toAddress release];
    [_currentLongitude release];
    [_currentlatitude release];
    [_cancelAlertView release];
    [_cancelFailView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 256, 150)]autorelease];
        [background setImage:[UIImage imageNamed:@"taxi_create_bg"]];
        [self addSubview:background];
        self.callDriverView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 256, 150)]autorelease];
        [self.callDriverView setBackgroundColor:[UIColor clearColor]];
        self.callDriverLabel = [[[OHAttributedLabel alloc] init] autorelease];
        [self.callDriverLabel setFont:[UIFont systemFontOfSize:18]];
        [self.callDriverLabel setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
        [self.callDriverLabel setBackgroundColor:[UIColor clearColor]];
        [self.callDriverLabel setFrame:CGRectMake(48, 40, 180, 44)];
        NSMutableAttributedString *topicTitleAttri2 = nil;
        NSString *str = [NSString stringWithFormat:@"%d",20];
        NSString *titleString2 = [NSString stringWithFormat:@"已经呼叫了%@个司机", str];
        topicTitleAttri2 = [NSMutableAttributedString attributedStringWithString:titleString2];
        [topicTitleAttri2 setTextIsUnderlined:NO];
        [topicTitleAttri2 setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
        [topicTitleAttri2 setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[titleString2 rangeOfString:str]];
        [topicTitleAttri2 setFont:[UIFont systemFontOfSize:18]];
        [self.callDriverLabel setAttributedText:topicTitleAttri2];

        
        self.cancelCallView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 256, 150)]autorelease];
        [self.cancelCallView setBackgroundColor:[UIColor clearColor]];
        UIButton *continueAlertbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        continueAlertbutton.exclusiveTouch = YES;
        [continueAlertbutton setFrame:CGRectMake(74, 98, 108, 36)];
        [continueAlertbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateNormal];
        [continueAlertbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateHighlighted];
        [continueAlertbutton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [continueAlertbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [continueAlertbutton setTitle:@"取消呼叫" forState:UIControlStateNormal];
        [continueAlertbutton addTarget:self action:@selector(applyCancelCall:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.callDriverView addSubview:self.callDriverLabel];
        [self.callDriverView addSubview:continueAlertbutton];
        [self addSubview:self.callDriverView];
        
        UILabel *contentlabel = [[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 180, 100)]autorelease];
        [contentlabel setFont:[UIFont systemFontOfSize:18]];
        [contentlabel setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
        [contentlabel setBackgroundColor:[UIColor clearColor]];
        [contentlabel setNumberOfLines:2];
        contentlabel.textAlignment = NSTextAlignmentCenter;
        contentlabel.text = @"暂时没有司机接单，是否继续叫车？";
        
        UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelbutton.exclusiveTouch = YES;
        [cancelbutton setFrame:CGRectMake(12, 98, 108, 36)];
        [cancelbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateNormal];
        [cancelbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateHighlighted];
        [cancelbutton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cancelbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelbutton setTitle:@"取消叫车" forState:UIControlStateNormal];
        [cancelbutton addTarget:self action:@selector(CancelCall:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *continuebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        continuebutton.exclusiveTouch = YES;
        [continuebutton setFrame:CGRectMake(136, 98, 108, 36)];
        [continuebutton setBackgroundImage:[UIImage imageNamed:@"taxi_red_button"] forState:UIControlStateNormal];
        [continuebutton setBackgroundImage:[UIImage imageNamed:@"taxi_red_button"] forState:UIControlStateHighlighted];
        [continuebutton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [continuebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [continuebutton setTitle:@"继续叫车" forState:UIControlStateNormal];
        [continuebutton addTarget:self action:@selector(continueCall:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.cancelCallView addSubview:contentlabel];
        [self.cancelCallView addSubview:cancelbutton];
        [self.cancelCallView addSubview:continuebutton];
        [self addSubview:self.cancelCallView];
        
        self.cancelAlertView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 256, 150)]autorelease];
        [self.cancelAlertView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *cancelAlertlabel = [[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 180, 100)]autorelease];
        [cancelAlertlabel setFont:[UIFont systemFontOfSize:18]];
        [cancelAlertlabel setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
        [cancelAlertlabel setBackgroundColor:[UIColor clearColor]];
        [cancelAlertlabel setNumberOfLines:2];
        cancelAlertlabel.textAlignment = NSTextAlignmentCenter;
        cancelAlertlabel.text = @"取消叫车？";
        
        UIButton *cancelAlertbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelAlertbutton.exclusiveTouch = YES;
        [cancelAlertbutton setFrame:CGRectMake(12, 98, 108, 36)];
        [cancelAlertbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateNormal];
        [cancelAlertbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateHighlighted];
        [cancelAlertbutton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cancelAlertbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelAlertbutton setTitle:@"不，谢谢" forState:UIControlStateNormal];
        [cancelAlertbutton addTarget:self action:@selector(cancelAlertGrey:) forControlEvents:UIControlEventTouchUpInside];
        self.callbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callbutton.exclusiveTouch = YES;
        [self.callbutton setFrame:CGRectMake(136, 98, 108, 36)];
        [self.callbutton setBackgroundImage:[UIImage imageNamed:@"taxi_red_button"] forState:UIControlStateNormal];
        [self.callbutton setBackgroundImage:[UIImage imageNamed:@"taxi_red_button"] forState:UIControlStateHighlighted];
        [self.callbutton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.callbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.callbutton setTitle:@"是" forState:UIControlStateNormal];
        [self.callbutton addTarget:self action:@selector(cancelAlertRed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cancelAlertView addSubview:cancelAlertlabel];
        [self.cancelAlertView addSubview:cancelAlertbutton];
        [self.cancelAlertView addSubview:self.callbutton];
        [self addSubview:self.cancelAlertView];
        
        self.cancelFailView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 256, 150)]autorelease];
        [self.cancelFailView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *cancelFaillabel = [[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 180, 100)]autorelease];
        [cancelFaillabel setFont:[UIFont systemFontOfSize:18]];
        [cancelFaillabel setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
        [cancelFaillabel setBackgroundColor:[UIColor clearColor]];
        [cancelFaillabel setNumberOfLines:2];
        cancelFaillabel.textAlignment = NSTextAlignmentCenter;
        cancelFaillabel.text = @"抱歉，你的订单已被司机接单。";
        
        UIButton *cancelFailbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelFailbutton.exclusiveTouch = YES;
        [cancelFailbutton setFrame:CGRectMake(74, 98, 108, 36)];
        [cancelFailbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateNormal];
        [cancelFailbutton setBackgroundImage:[UIImage imageNamed:@"taxi_grey_button"] forState:UIControlStateHighlighted];
        [cancelFailbutton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cancelFailbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelFailbutton setTitle:@"我知道了" forState:UIControlStateNormal];
        [cancelFailbutton addTarget:self action:@selector(cancelFailClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cancelFailView addSubview:cancelFaillabel];
        [self.cancelFailView addSubview:cancelFailbutton];
        [self addSubview:self.cancelFailView];
        
        [self.cancelCallView setHidden:YES];
        [self.cancelAlertView setHidden:YES];
        [self.cancelFailView setHidden:YES];
        [self.callDriverView setHidden:NO];
        self.isCall = YES;
        self.requestCount = 0;
        [self modifyRodom];
        [MobClick event:@"taxi_v2" label:@"派单弹层显示次数"];
    }
    return self;
}

-(void)modifyRodom
{
    self.receivedTaxi =20;
    self.randomTaxi = arc4random() % 150;
    self.remainTaxi = self.randomTaxi +30;
}

- (IBAction)applyCancelCall:(id)sender
{
    [self.cancelCallView setHidden:YES];
    [self.cancelAlertView setHidden:NO];
    [self.cancelFailView setHidden:YES];
    [self.callDriverView setHidden:YES];
    [MobClick event:@"taxi_v2" label:@"派单弹层取消按钮点击"];
}
- (IBAction)cancelAlertGrey:(id)sender
{
    [self.cancelCallView setHidden:YES];
    [self.cancelAlertView setHidden:YES];
    [self.cancelFailView setHidden:YES];
    [self.callDriverView setHidden:NO];
    [MobClick event:@"taxi_v2" label:@"取消叫车弹层拒绝点击"];
}
- (IBAction)cancelAlertRed:(id)sender
{
    [self.callbutton setEnabled:NO];
    [self cancelCallTaxiRequest];
    [MobClick event:@"taxi_v2" label:@"取消叫车弹层确认点击"];
}

- (IBAction)cancelFailClicked:(id)sender
{
    [self.cancelCallView setHidden:YES];
    [self.cancelAlertView setHidden:YES];
    [self.cancelFailView setHidden:YES];
    [self.callDriverView setHidden:NO];
}
- (IBAction)CancelCall:(id)sender
{
    [self.delegate cancelCreateTaxiOrderView];
    [MobClick event:@"taxi_v2" label:@"超时提示弹层取消叫车"];
}
- (IBAction)continueCall:(id)sender
{
    
    NSMutableAttributedString *topicTitleAttri2 = nil;
    NSString *str = [NSString stringWithFormat:@"%d",20];
    NSString *titleString2 = [NSString stringWithFormat:@"已经呼叫了%@个司机", str];
    topicTitleAttri2 = [NSMutableAttributedString attributedStringWithString:titleString2];
    [topicTitleAttri2 setTextIsUnderlined:NO];
    [topicTitleAttri2 setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
    [topicTitleAttri2 setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[titleString2 rangeOfString:str]];
    [topicTitleAttri2 setFont:[UIFont systemFontOfSize:18]];
    [self.callDriverLabel setAttributedText:topicTitleAttri2];
    [self createOrderRequest];
    self.requestCount = 0;
    [self.cancelCallView setHidden:YES];
    [self.cancelAlertView setHidden:YES];
    [self.cancelFailView setHidden:YES];
    [self.callDriverView setHidden:NO];
    self.isCall = YES;
    [MobClick event:@"taxi_v2" label:@"派单弹层显示次数"];
    [MobClick event:@"taxi_v2" label:@"超时提示弹层继续叫车"];
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)startTimerChangeLabel {
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTaxiAnimation) userInfo:nil repeats:YES];
}

- (void)stopChangeLabelTimer {
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

-(void)scrollTaxiAnimation
{
    if (self.remainTaxi>0) {
        self.receivedTaxi += self.remainTaxi;
        self.remainTaxi -= self.remainTaxi * 0.2;
        self.receivedTaxi -= self.remainTaxi;
    }else{
        self.receivedTaxi++;
    }
    
    NSMutableAttributedString *topicTitleAttri2 = nil;
    NSString *str = [NSString stringWithFormat:@"%d",self.receivedTaxi];
    NSString *titleString2 = [NSString stringWithFormat:@"已经呼叫了%@个司机", str];
    topicTitleAttri2 = [NSMutableAttributedString attributedStringWithString:titleString2];
    [topicTitleAttri2 setTextIsUnderlined:NO];
    [topicTitleAttri2 setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
    [topicTitleAttri2 setTextColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] range:[titleString2 rangeOfString:str]];
    [topicTitleAttri2 setFont:[UIFont systemFontOfSize:18]];
    [self.callDriverLabel setAttributedText:topicTitleAttri2];
}

- (void)changeText{
    self.requestCount++;
    if (self.requestCount < 20) {
        [self loadTaxiDataRequest];
    }else{
        [self modifyRodom];
        [self.cancelCallView setHidden:NO];
        [self.cancelAlertView setHidden:YES];
        [self.cancelFailView setHidden:YES];
        [self.callDriverView setHidden:YES];
        [MobClick event:@"taxi_v2" label:@"超时提示弹层"];
    }
}


-(void)loadTaxiDataRequest
{
    [self.taxiRequest clearDelegatesAndCancel];
    self.taxiRequest = [BBCallTaxiRequest taxiAcceptOrders:self.orderID];
    [self.taxiRequest setDidFinishSelector:@selector(loadTaxiDataFinish:)];
    [self.taxiRequest setDidFailSelector:@selector(loadTaxiDataFail:)];
    [self.taxiRequest setDelegate:self];
    [self.taxiRequest startAsynchronous];
    
}


- (void)loadTaxiDataFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
          [self.delegate cancelCreateTaxiOrderView];
        //返回数据成功
        NSDictionary *listDic = [jsonData dictionaryForKey:@"data"];
        BBAcceptedTaxiOrders *acceptedTaxiOrder = [[[BBAcceptedTaxiOrders alloc]initWithNibName:@"BBAcceptedTaxiOrders" bundle:nil]autorelease];
        acceptedTaxiOrder.driverInfo = listDic;
        [self.popViewController pushViewController:acceptedTaxiOrder animated:YES];
        [MobClick event:@"taxi_v2" label:@"接单页显示次数"];
    }
}

- (void)loadTaxiDataFail:(ASIFormDataRequest *)request
{
}

-(void)cancelCallTaxiRequest
{
    [self.cancelTaxiRequest clearDelegatesAndCancel];
    self.cancelTaxiRequest = [BBCallTaxiRequest taxiCancelOrders:self.orderID];
    [self.cancelTaxiRequest setDidFinishSelector:@selector(cancelTaxiFinish:)];
    [self.cancelTaxiRequest setDidFailSelector:@selector(cancelTaxiFail:)];
    [self.cancelTaxiRequest setDelegate:self];
    [self.cancelTaxiRequest startAsynchronous];
    
}


- (void)cancelTaxiFinish:(ASIFormDataRequest *)request
{
    [self.callbutton setEnabled:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
        //返回数据成功
        [self.delegate cancelCreateTaxiOrderView];
    }else if ([[jsonData stringForKey:@"status"] isEqualToString:@"failed"]){
        
        [self.cancelCallView setHidden:YES];
        [self.cancelAlertView setHidden:YES];
        [self.cancelFailView setHidden:NO];
        [self.callDriverView setHidden:YES];        
        [MobClick event:@"taxi_v2" label:@"已接单无法取消弹层"];
    }
}

- (void)cancelTaxiFail:(ASIFormDataRequest *)request
{
      [self.callbutton setEnabled:YES];
}

-(void)createOrderRequest
{
    [self.createTaxiRequest clearDelegatesAndCancel];
    self.createTaxiRequest = [BBCallTaxiRequest taxiCreateOrders:self.userPhone withFromAddress:self.fromAddress withToAddress:self.toAddress withFromLongitude:self.currentLongitude withFromLatitude:self.currentlatitude];
    [self.createTaxiRequest setDidFinishSelector:@selector(createOrderFinish:)];
    [self.createTaxiRequest setDidFailSelector:@selector(createOrderFail:)];
    [self.createTaxiRequest setDelegate:self];
    [self.createTaxiRequest startAsynchronous];
    
}


- (void)createOrderFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
        //返回数据成功
        NSDictionary *listDic = [jsonData dictionaryForKey:@"data"];
        self.orderID = [listDic stringForKey:@"order_id"];
        [self startTimer];
    }
}

- (void)createOrderFail:(ASIFormDataRequest *)request
{

}
@end
