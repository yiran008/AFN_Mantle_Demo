//
//  BBWeiLoginShare.h
//  pregnancy
//
//  Created by babytree babytree on 12-11-7.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import <CoreLocation/CoreLocation.h>



@protocol BBWeiLoginShareDelegate <NSObject>

- (void)weiLoginShareFinish;

@end

@interface BBWeiLoginShare : BaseViewController{
    UIButton *selectBtn;
    NSInteger weiboState;
    UIImageView *bg;
    CLLocationManager *_locationManager;
}

@property(nonatomic,strong)IBOutlet UIButton *selectBtn;
@property(weak) id<BBWeiLoginShareDelegate> delegate;
@property(assign) NSInteger weiboState;
@property(nonatomic,strong)IBOutlet UIImageView *bg;
@property(nonatomic,strong)IBOutlet UILabel *shareTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *followWeiBoButton;
@property (retain, nonatomic) IBOutlet UILabel *followWeiboLabel;

- (IBAction)clickedCancelFollow:(id)sender;

@end
