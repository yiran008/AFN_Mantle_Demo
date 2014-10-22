/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#import "ZXScanWatchQR.h"


@interface ZXScanWatchQR ()

@property (nonatomic, strong) ZXCapture* capture;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) ASIFormDataRequest *bindWatchRequest;
@property (nonatomic, strong) NSString *bluetoothMac;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, assign) BOOL  isProcessing;
@property (nonatomic, strong) UIImageView *scanLine;
@end

@implementation ZXScanWatchQR

#pragma mark - View Controller Methods

- (void)dealloc
{
    [_bindWatchRequest clearDelegatesAndCancel];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
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
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    UIFont *font = [UIFont systemFontOfSize:16];
    NSString *description = @"扫描手表上的二维码与您的手表绑定";   
    CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(190.0, 60.0) withFont:font withString:description];
    CGRect frame = CGRectMake(65, 100 - size.height - 30, 190, size.height);
    UILabel *descriptionLable = [[UILabel alloc] initWithFrame:frame];
    descriptionLable.text = description;
    descriptionLable.font = font;
    descriptionLable.textColor = [UIColor whiteColor];
    descriptionLable.backgroundColor = [UIColor clearColor];
    descriptionLable.numberOfLines = 0;
    [self.view addSubview:descriptionLable];
    if ([BBUser smartWatchCode]!=nil) {
        if (![self.alertView isVisible]) {
            self.alertView.title = @"亲，您的账号已经被绑定，请解绑";
            [self.alertView show];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.capture.layer.superlayer == nil) {
        [self.view.layer insertSublayer:self.capture.layer atIndex:0];
    }
    self.capture.delegate = self;
    self.isProcessing = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isProcessing = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.capture.delegate = nil;
    [self.bindWatchRequest clearDelegatesAndCancel];
    [self.hud hide:YES];
}
#pragma mark - BBLogin Finish Delegate
- (void)loginFinish
{
    self.hud.labelText = @"处理中...";
    [self.hud show:YES];
    [self.bindWatchRequest clearDelegatesAndCancel];
    self.bindWatchRequest = [BBSmartRequest bindWatch:self.bluetoothMac];
    [self.bindWatchRequest setDidFinishSelector:@selector(bindFinish:)];
    [self.bindWatchRequest setDidFailSelector:@selector(bindFail:)];
    [self.bindWatchRequest setDelegate:self];
    [self.bindWatchRequest startAsynchronous];
}
#pragma mark - IBAction Event

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.capture.layer.superlayer) {
        [self.capture.layer removeFromSuperlayer];
    }
}
#pragma mark - Private Methods

- (NSString*)displayForResult:(ZXResult*)result {
    NSString *formatString;
    switch (result.barcodeFormat) {
        case kBarcodeFormatAztec:
            formatString = @"Aztec";
            break;
            
        case kBarcodeFormatCodabar:
            formatString = @"CODABAR";
            break;
            
        case kBarcodeFormatCode39:
            formatString = @"Code 39";
            break;
            
        case kBarcodeFormatCode93:
            formatString = @"Code 93";
            break;
            
        case kBarcodeFormatCode128:
            formatString = @"Code 128";
            break;
            
        case kBarcodeFormatDataMatrix:
            formatString = @"Data Matrix";
            break;
            
        case kBarcodeFormatEan8:
            formatString = @"EAN-8";
            break;
            
        case kBarcodeFormatEan13:
            formatString = @"EAN-13";
            break;
            
        case kBarcodeFormatITF:
            formatString = @"ITF";
            break;
            
        case kBarcodeFormatPDF417:
            formatString = @"PDF417";
            break;
            
        case kBarcodeFormatQRCode:
            formatString = @"QR Code";
            break;
            
        case kBarcodeFormatRSS14:
            formatString = @"RSS 14";
            break;
            
        case kBarcodeFormatRSSExpanded:
            formatString = @"RSS Expanded";
            break;
            
        case kBarcodeFormatUPCA:
            formatString = @"UPCA";
            break;
            
        case kBarcodeFormatUPCE:
            formatString = @"UPCE";
            break;
            
        case kBarcodeFormatUPCEANExtension:
            formatString = @"UPC/EAN extension";
            break;
            
        default:
            formatString = @"Unknown";
            break;
    }
    
    return formatString;
}


#pragma mark - ZXCaptureDelegate Methods
- (void)bindFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，操作失败" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"]) {
        if ([BBUser smartWatchCode]==nil) {
            [MobClick event:@"watch_v2" label:@"配对成功"];
            [BBUser setSmartWatchCode:self.bluetoothMac];
            BBSmartMainPage *smartMainPage = [[BBSmartMainPage alloc]initWithNibName:@"BBSmartMainPage" bundle:nil];
            [self.navigationController pushViewController:smartMainPage animated:YES];
        }
        return;
    }else if ([[jsonData stringForKey:@"status"] isEqualToString:@"user_has_bind_watch"]) {
        if (![self.alertView isVisible]) {
            self.alertView.title = @"亲，您的账号已经被绑定，请解绑";
            [self.alertView show];
        }
    }else if ([[jsonData stringForKey:@"status"] isEqualToString:@"watch_has_bound"]) {
        if (![self.alertView isVisible]) {
            self.alertView.title = @"亲，您的手表已经被绑定，请解绑";
            [self.alertView show];
        }
    }
    [self.hud hide:YES];
}

- (void)bindFail:(ASIFormDataRequest *)request
{
    [self.hud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)isValidResult:(ZXResult *)result {
    if ([BBUser smartWatchCode]!=nil) {
        return NO;
    }
    NSArray *dataArray = [result.text componentsSeparatedByString:@"?"];
    NSArray *pramsArray = nil;
    if([dataArray count] >= 2){
        pramsArray = [[dataArray objectAtIndex:1] componentsSeparatedByString:@"&"];
        if ([pramsArray count]>=2) {
            NSArray *tempArray1 = [[pramsArray objectAtIndex:0] componentsSeparatedByString:@"="];
            NSArray *tempArray2 = [[pramsArray objectAtIndex:1] componentsSeparatedByString:@"="];
            if ([tempArray1 count]>=2) {
                if ([[tempArray1 objectAtIndex:0] isEqualToString:@"status"]) {
                    NSString *state = [tempArray1 objectAtIndex:1];
                    if (![state isEqualToString:@"2"]) {
                        if (![self.alertView isVisible]) {
                            self.alertView.title = @"亲，手表需要在wifi网络下才能绑定";
                            [self.alertView show];
                        }
                        return NO;
                    }
                }else{
                    return NO;
                }
            }else{
                return NO;
            }
            if ([tempArray2 count]>=2) {
                if ([[tempArray2 objectAtIndex:0] isEqualToString:@"wcode"]) {
                    self.bluetoothMac = [tempArray2 objectAtIndex:1];
                }else{
                    return NO;
                }
            }else{
                return NO;
            }
        }
    }else{
        return NO;
    }
    return YES;
}

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
    if (result) {
        if (!self.isProcessing) {
            self.isProcessing = YES;
            if (![self isValidResult:result]) {
                self.isProcessing = NO;
                return;
            }
            self.hud.labelText = @"处理中...";
            [self.hud show:YES];
            
            if (![BBUser isLogin]) {
#if USE_SMARTWATCH_MODEL
                BBLogin *loginController = [[BBLogin alloc] initWithNibName:@"BBLogin" bundle:nil];
                loginController.delegate = self;
                loginController.m_LoginType = BBPresentLogin;
                BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:loginController];
                [navCtrl setColorWithImageName:@"navigationBg"];
                [self.navigationController presentViewController:navCtrl animated:YES completion:^{}];
#endif
                            }else{
                
                [self.bindWatchRequest clearDelegatesAndCancel];
                self.bindWatchRequest = [BBSmartRequest bindWatch:self.bluetoothMac];
                [self.bindWatchRequest setDidFinishSelector:@selector(bindFinish:)];
                [self.bindWatchRequest setDidFailSelector:@selector(bindFail:)];
                [self.bindWatchRequest setDelegate:self];
                [self.bindWatchRequest startAsynchronous];
            }
        }
    }
}

- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height {
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isProcessing = NO;
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
