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

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ZXScanMusicQR.h"
#import <QuartzCore/QuartzCore.h>
#import "BBMusicViewController.h"

@interface ZXScanMusicQR ()

@property (nonatomic, strong) ZXCapture* capture;
@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, assign) BOOL      isProcessing;
@property (nonatomic, strong) UIAlertView    *currentAlert;
@property (nonatomic, strong) UIImageView *scanLine;
@end

@implementation ZXScanMusicQR

#pragma mark - View Controller Methods

-(void)viewDidLoad{
    
    //self.navigationItem.title
    [super viewDidLoad];
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
    self.currentAlert = [[UIAlertView alloc] initWithTitle:nil message:@"二维码不匹配" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];

}

- (void)addDescriptionLabel
{
    UIFont *font = [UIFont systemFontOfSize:16];
    NSString *description = @"";
    if([self.categoryInfo count]>0)
    {
        description = [self.categoryInfo stringForKey:@"scan_mark_description"];
    }
    CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(190.0, 60.0) withFont:font withString:description];
    CGRect frame = CGRectMake(65, 100 - size.height - 30, 190, size.height);
    UILabel *descriptionLable = [[UILabel alloc] initWithFrame:frame];
    descriptionLable.text = description;
    descriptionLable.font = font;
    descriptionLable.textColor = [UIColor whiteColor];
    descriptionLable.backgroundColor = [UIColor clearColor];
    descriptionLable.numberOfLines = 0;
    [self.view addSubview:descriptionLable];
    
   
}

- (void)viewWillAppear:(BOOL)animated {
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.capture.delegate = nil;
}
#pragma mark - IBAction Event

- (IBAction)backAction:(id)sender
{
    if (!self.isProcessing) {//防止push下层界面是盖层界面被pop掉
        [self.navigationController popViewControllerAnimated:YES];
        if (self.capture.layer.superlayer) {
            [self.capture.layer removeFromSuperlayer];
        }
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

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
    if (result) {
        if (!self.isProcessing) {
            self.isProcessing = YES;
            NSString *resultText = [result.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *url = [[self.categoryInfo stringForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([resultText isEqualToString:url]) {
                NSString *type = [self.categoryInfo stringForKey:@"type"];
                if([type isNotEmpty])
                {
                    if([type isEqualToString:@"1"])
                    {
                      [MobClick event:@"music_v2" label:@"激活数量-胎教音乐"];
                    }
                    else if([type isEqualToString:@"2"])
                    {
                      [MobClick event:@"music_v2" label:@"激活数量-早教音乐"];  
                    }
                }
                
                
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:self.navigationController.viewControllers];
                [array removeObjectAtIndex:[array count]-1];
                BBMusicViewController *musicController = [[BBMusicViewController alloc] init];
                musicController.musicTypeInfo = self.categoryInfo;
                [array addObject:musicController];                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:@"YES" forKey:url];
                [self.navigationController setViewControllers:array animated:NO];
            }else {
                self.isProcessing = NO;

                if (!self.currentAlert.isVisible) {
                    [self.currentAlert show];
                }
            }
        }
    }
}

- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height {
    
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
