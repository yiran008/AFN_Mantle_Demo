//
//  BBCreateTaxiOrderView.h
//  pregnancy
//
//  Created by whl on 13-12-17.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBCreateTaxiorderDelegate <NSObject>

-(void)cancelCreateTaxiOrderView;

@end

@interface BBCreateTaxiOrderView : UIView

@property (nonatomic, strong)  NSTimer  *timer;
@property (nonatomic, strong) ASIFormDataRequest *taxiRequest;
@property (nonatomic, strong) ASIFormDataRequest *cancelTaxiRequest;
@property (nonatomic, strong) ASIFormDataRequest *createTaxiRequest;

@property (nonatomic, strong) NSString *orderID;
@property (assign) BOOL isCall;

@property (nonatomic, strong)  UIView *callDriverView;
@property (nonatomic, strong)  OHAttributedLabel * callDriverLabel;

@property (nonatomic, strong)  UIView *cancelCallView;
@property (nonatomic, strong)  UIButton *callbutton;


@property(assign) NSInteger requestCount;

@property(nonatomic,strong) NSTimer *scrollTimer;
@property(assign) int receivedTaxi ;
@property(assign) int randomTaxi ;
@property(assign) int remainTaxi ;

@property (assign) UINavigationController *popViewController;
@property (assign) id<BBCreateTaxiorderDelegate> delegate;

@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *fromAddress;
@property (nonatomic, strong) NSString *toAddress;
@property (nonatomic, strong) NSString *currentLongitude;
@property (nonatomic, strong) NSString *currentlatitude;

@property (nonatomic, strong) UIView *cancelAlertView;
@property (nonatomic, strong) UIView *cancelFailView;






- (void)startTimer;

- (void)stopTimer;

- (void)startTimerChangeLabel;

- (void)stopChangeLabelTimer;

@end

