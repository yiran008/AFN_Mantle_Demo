//
//  BBSign.h
//  pregnancy
//
//  Created by babytree on 12-11-30.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "BBBandInfomation.h"
#import "BBCustomsAlertView.h"

typedef enum
{
    BBPushSign,
    BBPresentSign,
}BBSignType;

@interface BBSign : BaseViewController
<
  BBBandInfomationDelegate,BBCustomsAlertViewDelegate
>

@property(nonatomic,strong)IBOutlet UIImageView *treeImageView;
@property(nonatomic,strong)IBOutlet UIImageView *progressImageView;
@property (strong, nonatomic) ASIFormDataRequest *signRequest;
@property (strong, nonatomic) ASIFormDataRequest *userInfoRequest;
@property (strong, nonatomic) ASIFormDataRequest *popLayerRequest;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSDictionary *userPrizeInfo;
@property(nonatomic,strong)IBOutlet UILabel *preValueLabel;
@property (nonatomic,strong) OHAttributedLabel *signLabel1;
@property (nonatomic,strong) OHAttributedLabel *signLabel2;
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)IBOutlet UIButton *signButton;
@property(nonatomic,strong)IBOutlet UILabel *gradeDescLabel;
@property(nonatomic,strong) UIScrollView *badgeScrollView;

@property (retain, nonatomic) IBOutlet UILabel *papaLabel1;
@property (retain, nonatomic) IBOutlet UILabel *papaLabel2;

@property (nonatomic, strong) IBOutlet OHAttributedLabel *presentLabel;
@property (nonatomic, strong) OHAttributedLabel *papaLabel;
@property (assign) BBSignType m_SignType;

-(UIView*)getBadgeImages:(UIImage*)imageName;
-(void)deriveImage:(int)currentPrevalue;
@end
