//
//  ZXSanQR.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-29.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "ZXSanQR.h"
#import "MBProgressHUD.h"
#import "BBMusicRequest.h"
#import "BBNavigationLabel.h"
#import "ASIFormDataRequest.h"
#import "BBApp.h"
#import "AlertUtil.h"
#import "SBJsonParser.h"
//#import "BBNewTopicDetail.h"
//#import "BBRecipeKnowledge.h"
#import "BBSelectHospitalArea.h"
#import "BBHospitalRequest.h"
#import "BBMusicViewController.h"
#import "MobClick.h"
#import "HMShowPage.h"
#import "BBSupportTopicDetail.h"

@interface ZXSanQR ()
@property (nonatomic, strong) MBProgressHUD * hud;
@property (atomic, assign) BOOL      isProcessing;
@property (nonatomic, strong) ZXCapture* capture;
@property (nonatomic, strong) ASIFormDataRequest    *scanDataRequest;
@property (nonatomic, strong) NSMutableArray        *scanDataArray;
@property (nonatomic, strong) UIAlertView           *currentAlertView;
@property (nonatomic, assign) BOOL                  hasScanData;
@property (nonatomic, strong) UIImageView *scanLine;
@end

@implementation ZXSanQR

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_scanDataRequest clearDelegatesAndCancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"扫描二维码"]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.rotation = 90.0f;
    // Use the back camera
    self.capture.camera = self.capture.back;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.animationType = MBProgressHUDAnimationFade;
    [self.view addSubview:self.hud];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    imageView.image = [UIImage imageNamed:@"scan_qr_mask"];
    [self.view addSubview:imageView];
    
    self.scanLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_qr_anline"]];
    self.scanLine.frame = CGRectMake(45,131,230,1.5);
    [self.view addSubview:self.scanLine];
    
    [self lineAnimate];
    [self addDescriptionLabel];
    
    self.currentAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"二维码不匹配" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.scanDataArray = (NSMutableArray *)[defaults arrayForKey:@"scanData"];
    
    if (self.scanDataArray && [self.scanDataArray count] > 0) {
        self.hasScanData = YES;
        self.isProcessing = NO;
        [self requestScanData];
    }else {
        [self.hud setLabelText:@"加载中..."];
        [self.hud show:YES];
        self.hasScanData = NO;
        self.isProcessing = YES;
        [self requestScanData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.capture.layer.superlayer == nil) {
        [self.view.layer insertSublayer:self.capture.layer atIndex:0];
    }
    //防止提前识别
    self.isProcessing = YES;
    self.capture.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //防止提前识别
    self.isProcessing = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.capture.delegate = nil;
    //重置状态
//    self.isProcessing = NO;
    if (self.hud.isShow) {
        [self.hud hide:YES];
    }
    [self.scanDataRequest clearDelegatesAndCancel];
}

- (void)addDescriptionLabel
{
    UIFont *font = [UIFont systemFontOfSize:16];
    NSString *description = @"扫描盒子里的二维码获取更多精彩内容";
    CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(190.0, 60.0) withFont:font withString:description];
    //[description sizeWithFont:font constrainedToSize:CGSizeMake(190, 60) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = CGRectMake(65, 100 - size.height - 30, 190, size.height);
    UILabel *descriptionLable = [[UILabel alloc] initWithFrame:frame];
    descriptionLable.text = description;
    descriptionLable.font = font;
    descriptionLable.textColor = [UIColor whiteColor];
    descriptionLable.backgroundColor = [UIColor clearColor];
    descriptionLable.numberOfLines = 0;
    [self.view addSubview:descriptionLable];
}

- (IBAction)backAction:(id)sender
{
    if (!self.isProcessing) {//防止push下层界面是盖层界面被pop掉
        [self.navigationController popViewControllerAnimated:YES];
        if (self.capture.layer.superlayer) {
            [self.capture.layer removeFromSuperlayer];
        }
    }
}
- (void)requestScanData
{

    [self.scanDataRequest clearDelegatesAndCancel];
    self.scanDataRequest = [BBMusicRequest getScanMap];
    [self.scanDataRequest setDidFinishSelector:@selector(getScanDataFinish:)];
    [self.scanDataRequest setDidFailSelector:@selector(getScanDataFail:)];
    [self.scanDataRequest setDelegate:self];
    [self.scanDataRequest startAsynchronous];
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
    if (result) {
        if([self.hud isShow])
            return;
        if (!self.isProcessing) {
            self.isProcessing = YES;
            for (int i = 0; i < [self.scanDataArray count]; i++) {
                NSDictionary *dic = [self.scanDataArray objectAtIndex:i];
                
                NSString *url = [[dic stringForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *resultText = [result.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if ([resultText isEqualToString:url]) {
                    if ([[dic stringForKey:@"type"] isEqualToString:@"topic_id"]) {
                        NSString *topic_id = [dic objectForKey:@"value"];
                        if (topic_id.isNotEmpty) {
                            [self skipToTopicWithID:topic_id];
                        }
                    }else if ([[dic stringForKey:@"type"] isEqualToString:@"url"]) {
                        if ([url isEqualToString:@"http://r.babytree.com/pslgct"]) {
                            [self gotoUrl:@"http://m.haodou.com/app/recipe/act/kuaileyunqi.php&&title=孕期食谱"];
                        }else if ([url isEqualToString:@"http://r.babytree.com/lsq51w"]) {
                            NSDictionary *hospitalData = [BBHospitalRequest getHospitalCategory];
                            if (hospitalData != nil)
                            {
                                [HMShowPage showCircleTopic:self circleClass:nil];
                                
                            }
                            else
                            {
                                BBSelectHospitalArea *selectHospitalArea = [[BBSelectHospitalArea alloc] initWithNibName:@"BBSelectHospitalArea" bundle:nil];
                                [self.navigationController pushViewController:selectHospitalArea animated:YES];
                            }
                        }
                    }else if ([[dic stringForKey:@"type"] isEqualToString:@"music"]) {
                        if ([[dic stringForKey:@"need_check"] isEqualToString:@"1"]) {
                            if ([[dic stringForKey:@"valid"] isEqualToString:@"1"]) {
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setValue:@"YES" forKey:resultText];
                            }
                            
                        }else {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setValue:@"YES" forKey:resultText];
                        }
                        BBMusicViewController *musicController = [[BBMusicViewController alloc] init];
                        musicController.musicTypeInfo = dic;
                        [self.navigationController pushViewController:musicController animated:YES];
                        
                    }
                    
                    return;
                }
            }
            
            self.isProcessing = NO;
            if (!self.currentAlertView.isVisible) {
                [self.currentAlertView show];
            }
        }
    }
}
-(void)gotoUrl:(NSString*)url
{
    if(url == nil || [url length]==0)
    {
        return;
    }
    NSArray *dataArray = [url componentsSeparatedByString:@"&&"];
    NSString *realUrl = [dataArray objectAtIndex:0];
    NSString *realTitle = @"";
    for (int i =1;i< [dataArray count];i++)
    {
        NSString *param = [dataArray objectAtIndex:i];
        NSArray *titleArray = [param componentsSeparatedByString:@"="];
        if ([titleArray count]>1) {
            if ([[titleArray objectAtIndex:0]isEqualToString:@"title"])
            {
                realTitle = [titleArray objectAtIndex:1];
                break;
            }
        }
    }
    realUrl = [realUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    realTitle = [realTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self openSupportTopicURL:realUrl title:realTitle];
}
-(void)openSupportTopicURL:(NSString*)url title:(NSString*)title
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:url];
    [exteriorURL setTitle:title];
    exteriorURL.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:exteriorURL animated:YES];
}
- (void)skipToTopicWithID:(NSString *)topicID
{
    [BBStatistic visitType:BABYTREE_TYPE_TOPIC_SCAN contentId:topicID];
    [HMShowPage showTopicDetail:self topicId:topicID topicTitle:nil];
}

- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height {
    
}

- (void)getScanDataFinish:(ASIFormDataRequest *)request
{

    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *submitReplyData = [parser objectWithString:responseString error:&error];
    if (error != nil) {

    }
    if ([[submitReplyData stringForKey:@"status"] isEqualToString:@"success"]) {
        self.scanDataArray = (NSMutableArray *)[[submitReplyData dictionaryForKey:@"data"] arrayForKey:@"scan_map"];
        if ([self.scanDataArray count] > 0) {
            if (self.hud.isShow) {
                [self.hud hide:YES];
            }
            if (!self.hasScanData) {
                self.isProcessing = NO;
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults safeSetContainer:self.scanDataArray forKey:@"scanData"];
            [defaults synchronize];
        }

        
    }
}

- (void)getScanDataFail:(ASIFormDataRequest *)request
{

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lineAnimate
{
    //(45,131,230,3);
    [UIView animateWithDuration:2 animations:^{
        
        CGRect R = self.scanLine.frame;
        R.origin.y += 230-1.5;
        [self.scanLine setFrame:R];
        
    } completion:^(BOOL finished) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:2];
     
            CGRect R = self.scanLine.frame;
            R.origin.y -= 230-1.5;
            [self.scanLine setFrame:R];
        
        [UIView commitAnimations];
        [self performSelector:@selector(lineAnimate) withObject:self afterDelay:2];
        
    }];
}
@end
