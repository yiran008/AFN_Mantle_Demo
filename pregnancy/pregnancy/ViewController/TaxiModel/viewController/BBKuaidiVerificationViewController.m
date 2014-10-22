//
//  BBKuaidiVerificationViewController.m
//  pregnancy
//
//  Created by MAYmac on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBKuaidiVerificationViewController.h"
#import "BBCallTaxiRequest.h"
#import "BBTaxiLocationData.h"
#import "BBTaxiPartnerView.h"
#import "BBTaxiLocationData.h"

typedef enum
{
    //未提交审核状态
    KuaidiVerificationTypesubmit = 4,
    //审核中状态
    KuaidiVerificationTypeOnReview = 0,
    //审核成功状态
    KuaidiVerificationTypeSuccess = 2,
    //审核被拒绝
    KuaidiVerificationTypereject = 1
}KuaidiVerificationType;

@interface BBKuaidiVerificationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    
}
@property(nonatomic,retain)IBOutlet UILabel * infoLabel;
//支付宝账号
@property(nonatomic,retain)IBOutlet UITextField * alipayAcountField;
//支付宝账号审核通过标记
@property(nonatomic,retain)IBOutlet UIImageView * alipayAcountReviewed;
//怀孕证明选择标签
@property(nonatomic,retain)IBOutlet UILabel * pregnancyIDSelector;
//孕检单审核中
@property(nonatomic,retain)IBOutlet UILabel * imageOnReview;
//孕检单审核通过标记
@property(nonatomic,retain)IBOutlet UIImageView * imageReviewed;
//怀孕证明缩略图片，或者启动按钮按钮
@property(nonatomic,retain)IBOutlet UIButton * pregnanyImageButton;
//提交或者取消按钮
@property(nonatomic,retain)IBOutlet UIButton * submitButton;
@property(nonatomic,retain)IBOutlet UIImageView * arrow;
//当前类型
@property(nonatomic,assign)KuaidiVerificationType type;
//摄像头获取的图片
@property(nonatomic,retain)UIImage * pickedImage;
//获取审核状态
@property(nonatomic,retain) ASIFormDataRequest * getInfoRequest;
//提交审核材料
@property(nonatomic,retain) ASIFormDataRequest * submitInfoRequest;
//取消审核
@property(nonatomic,retain) ASIFormDataRequest * cancelSubmitInfoRequest;
//存照片的类型,1,2,3
@property(nonatomic,retain) NSString * photoType;
//照片数据
@property(nonatomic,retain) NSData * photoData;
//阿里账号
@property(nonatomic,retain) NSString * alipayAccount;
//大图链接
@property(nonatomic,retain) NSString * bigUrl;
//小图链接
@property(nonatomic,retain) NSString * smallUrl;
//小图图片
@property(nonatomic,retain) UIImage * thumbImage;
@property(nonatomic,retain) MBProgressHUD * loadProgress;
@property(nonatomic,retain) UIActionSheet * cameraActionSheet;
@property(nonatomic,retain) UIImagePickerController * imagePicker;
@end

@implementation BBKuaidiVerificationViewController

- (void)dealloc
{
    [_cameraActionSheet release];
    [_imagePicker release];
    [_infoStr release];
    [_alipayAccount release];
    [_bigUrl release];
    [_smallUrl release];
    [_getInfoRequest clearDelegatesAndCancel];
    [_getInfoRequest release];
    [_submitInfoRequest clearDelegatesAndCancel];
    [_submitInfoRequest release];
    [_cancelSubmitInfoRequest clearDelegatesAndCancel];
    [_cancelSubmitInfoRequest release];
    [_infoLabel release];
    [_alipayAcountField release];
    [_pregnancyIDSelector release];
    [_pregnanyImageButton release];
    [_photoType release];
    [_thumbImage release];
    [_loadProgress release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"准妈妈验证"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
        
    UITapGestureRecognizer *tapGr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]autorelease];
    tapGr.cancelsTouchesInView = NO;
    
    UIView *gestureView = [self.view viewWithTag:10001];
    [gestureView addGestureRecognizer:tapGr];
    
    self.photoType = @"1";
    
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
    
    if (!self.isApplied)
    {
        self.type = KuaidiVerificationTypesubmit;
        [self refreshVerificationStatus];
    }else
    {
        [self startFetchDataRequest];
    }
    
    [self setTaxiPartner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- classMethod
//提交审核材料
- (void)submit:(id)sender
{
    NSString * lat = [BBTaxiLocationData getCurrentLatitudeString];
    NSString * lng = [BBTaxiLocationData getCurrentLongitudeString];
    if (self.alipayAcountField.text
        &&([BBValidateUtility checkPhoneNumInput:self.alipayAcountField.text]||[BBValidateUtility isValidateEmail:self.alipayAcountField.text])
        && self.alipayAcountField.text.length > 0
        && self.photoData)
    {
        [self.submitInfoRequest clearDelegatesAndCancel];
        self.submitInfoRequest = [BBCallTaxiRequest postVerificaitionWithAlipayAccount:_alipayAcountField.text withPhotoType:self.photoType withPhotoData:self.photoData lat:lat lng:lng];
        [self.submitInfoRequest setDidFinishSelector:@selector(submitFinish:)];
        [self.submitInfoRequest setDidFailSelector:@selector(submitFailed:)];
        [self.submitInfoRequest setDelegate:self];
        [self.submitInfoRequest startAsynchronous];
        self.loadProgress.labelText = @"正在提交...";
        [self.loadProgress show:YES];
    }else
    {
        NSString *title = @"需要拍照或上传清晰怀孕证明";
        if(self.alipayAcountField.text.length == 0 || [[self.alipayAcountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || self.alipayAcountField.text == nil)
        {
            title = @"需要填写支付宝账号";
        }else if (!([BBValidateUtility checkPhoneNumInput:self.alipayAcountField.text]||[BBValidateUtility isValidateEmail:self.alipayAcountField.text])) {
            title = @"支付宝账号必须是手机号码或邮箱";
        }else if(!self.photoData)
        {
            title = @"需要拍照或上传清晰怀孕证明";
        }
        
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

//取消审核
- (void)cancelSubmit:(id)sender
{
    [self.cancelSubmitInfoRequest clearDelegatesAndCancel];
    self.cancelSubmitInfoRequest = [BBCallTaxiRequest cancelVerification];
    [self.cancelSubmitInfoRequest setDidFinishSelector:@selector(cancelSubmitFinish:)];
    [self.cancelSubmitInfoRequest setDidFailSelector:@selector(cancelSubmitFailed:)];
    [self.cancelSubmitInfoRequest setDelegate:self];
    [self.cancelSubmitInfoRequest startAsynchronous];
    self.loadProgress.labelText = @"正在取消审核...";
    [self.loadProgress show:YES];
}

//获取审核状态
- (void)startFetchDataRequest
{
    [self.getInfoRequest clearDelegatesAndCancel];
    self.getInfoRequest = [BBCallTaxiRequest fetchKuaidiVerificaition];

    [self.getInfoRequest setDidFinishSelector:@selector(fecthDataFinsh:)];
    [self.getInfoRequest setDidFailSelector:@selector(fetchFailed:)];
    [self.getInfoRequest setDelegate:self];
    [self.getInfoRequest startAsynchronous];
    self.loadProgress.labelText = @"正在获取审核状态...";
    [self.loadProgress show:YES];
}

- (void)selectIDType:(id)sender
{
    
}

- (NSString *)getPhotoNameByType:(int)type
{
    if (type == 1)
    {
        return @"孕检单";
    }else if (type == 2)
    {
        return @"B超单";
    }else if (type == 3)
    {
        return @"准生证";
    }
    return @"";
}

//刷新整个页面
- (void)refreshVerificationStatus
{
    self.infoLabel.text = [BBTaxiLocationData getAppleWordString];
    
    self.alipayAcountField.hidden = NO;
    self.pregnancyIDSelector.hidden = NO;
    self.arrow.hidden = YES;
    
    self.alipayAcountField.text = self.alipayAccount;
    if (!self.photoType)
    {
        self.pregnancyIDSelector.text = [self getPhotoNameByType:1];
    }else
    {
        self.pregnancyIDSelector.text = [self getPhotoNameByType:[self.photoType intValue]];
    }
    
    //先释放提交按钮绑定的方法
    [self.submitButton removeTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton removeTarget:self action:@selector(cancelSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pregnanyImageButton removeTarget:self action:@selector(startCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.pregnanyImageButton removeTarget:self action:@selector(showBigImage:) forControlEvents:UIControlEventTouchUpInside];
    
    //先清除B超单上的所有的手势
    for (UIGestureRecognizer * gesture in self.pregnancyIDSelector.gestureRecognizers)
    {
        [self.pregnancyIDSelector removeGestureRecognizer:gesture];
    }
    
    [self.pregnanyImageButton setImageWithURL:nil];
    
    if (self.thumbImage)
    {
        [self.pregnanyImageButton setBackgroundImage:self.thumbImage forState:UIControlStateNormal];
    }
    else
    {
        [self.pregnanyImageButton setBackgroundImage:[UIImage imageNamed:@"taxi_verification_add@2x.png"] forState:UIControlStateNormal];
    }
    
    switch (self.type)
    {
        //提交审核状态
        //审核被拒绝
        case KuaidiVerificationTypesubmit:
        case KuaidiVerificationTypereject:
            self.alipayAcountReviewed.hidden = YES;
            self.imageReviewed.hidden = YES;
            self.imageOnReview.hidden = YES;
            self.submitButton.hidden = NO;
            self.arrow.hidden = NO;
            self.alipayAcountField.enabled = YES;
            
            [self.submitButton setBackgroundImage:[[UIImage imageNamed:@"message_button"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
            self.submitButton.titleLabel.text = @"提交审核";
            [self.submitButton setTitleColor:[UIColor colorWithRed:255./255. green:83./255. blue:123./255. alpha:1]forState:UIControlStateNormal];
            //为B超单添加手势可以选择证明种类
            UITapGestureRecognizer *tapPhotoType = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTypeTapped:)]autorelease];
            tapPhotoType.cancelsTouchesInView = NO;
            [self.pregnancyIDSelector addGestureRecognizer:tapPhotoType];
            self.pregnancyIDSelector.userInteractionEnabled = YES;
            
            [self.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
            [self.pregnanyImageButton addTarget:self action:@selector(startCamera:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.alipayAccount)
            {
                self.alipayAcountField.text = self.alipayAccount;
            }
            break;
            
        //审核中状态
        case KuaidiVerificationTypeOnReview:
            self.alipayAcountReviewed.hidden = NO;
            self.imageReviewed.hidden = YES;
            self.imageOnReview.hidden = NO;
            self.submitButton.hidden = NO;
            self.alipayAcountField.enabled = NO;
            
            [self.submitButton setBackgroundImage:[[UIImage imageNamed:@"greyline_button"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
            [self.submitButton setTitleColor:[UIColor colorWithRed:136./255. green:136./255. blue:136./255. alpha:1]forState:UIControlStateNormal];
            self.submitButton.titleLabel.text = @"取消审核";

            [self.submitButton addTarget:self action:@selector(cancelSubmit:) forControlEvents:UIControlEventTouchUpInside];
            [self.pregnanyImageButton addTarget:self action:@selector(showBigImage:) forControlEvents:UIControlEventTouchUpInside];
                        
            //审核中显示服务器传回的小图片
            if (self.smallUrl)
            {
                [self.pregnanyImageButton setImageWithURL:[NSURL URLWithString:self.smallUrl]];
            }
            break;
            
        //审核成功状态
        case KuaidiVerificationTypeSuccess:
            self.alipayAcountField.enabled = NO;
            self.alipayAcountReviewed.hidden = NO;
            self.imageReviewed.hidden = NO;
            self.imageOnReview.hidden = YES;
            self.submitButton.hidden = YES;
            
            [self.pregnanyImageButton addTarget:self action:@selector(showBigImage:) forControlEvents:UIControlEventTouchUpInside];
            //审核中显示服务器传回的小图片
            if (self.smallUrl)
            {
                [self.pregnanyImageButton setImageWithURL:[NSURL URLWithString:self.smallUrl]];
            }
            break;
            
        default:
            break;
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_alipayAcountField resignFirstResponder];
}

-(void)photoTypeTapped:(UITapGestureRecognizer*)tapGr
{
    [_alipayAcountField resignFirstResponder];
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"选择怀孕证明种类" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"孕检单",@"B超单",@"准生证", nil] autorelease];
    [actionSheet showInView:self.view];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showBigImage:(id)sender
{
    
    CGRect rect = [self.pregnanyImageButton  convertRect:self.pregnanyImageButton.bounds toView:self.view ];
    PicReviewView *pView = [[[PicReviewView alloc] initWithRect:rect placeholderImage:self.pregnanyImageButton.imageView.image] autorelease];
    pView.shareTypeMark = BBShareTypeRecord;
    [pView loadUrl:[NSURL URLWithString:self.bigUrl]];
    [self.view addSubview:pView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)startCamera:(id)sender
{	
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        self.cameraActionSheet = [[[UIActionSheet alloc] initWithTitle:@"图片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil] autorelease];
        [self.cameraActionSheet showInView:self.view];
	}
	else
	{
        self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        [self.imagePicker setDelegate:self];
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
	}
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton setTag:[navigationController.viewControllers count]];
    [backButton addTarget:self action:@selector(cameraBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton]autorelease];
    [viewController.navigationItem setLeftBarButtonItem:backBarButton];
    
    UIView *nilView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)] autorelease];
    UIBarButtonItem *nilBarButton = [[[UIBarButtonItem alloc] initWithCustomView:nilView]autorelease];
    [viewController.navigationItem setRightBarButtonItem:nilBarButton];
    [viewController.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:viewController.navigationItem.title]];
    [viewController.navigationController setPregnancyColor];//设置导航栏颜色
    
}

- (void)cameraBackAction:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == 1)
    {
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    else
    {
        [self.imagePicker popViewControllerAnimated:YES];
        
    }
}

#pragma mark- httpMethod
- (void)fecthDataFinsh:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser * parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSMutableDictionary * data = (NSMutableDictionary *)[jsonDictionary dictionaryForKey:@"data"];
        self.alipayAccount = [data stringForKey:@"alipay_account"];
        self.photoType = [data stringForKey:@"photo_type"];
        self.bigUrl = [data stringForKey:@"big_url"];
        self.smallUrl = [data stringForKey:@"url"];
        self.type = [[data stringForKey:@"status"]intValue];
        if(self.type != KuaidiVerificationTypesubmit && self.delegate && [self.delegate respondsToSelector:@selector(verificationIsApply:)])
        {
            [self.delegate verificationIsApply:YES];
        }
        //刷新页面
        [self refreshVerificationStatus];
    }
    else if([[jsonDictionary stringForKey:@"status"] isEqualToString:@"failed"])
    {
        NSMutableDictionary * data = (NSMutableDictionary *)[jsonDictionary dictionaryForKey:@"data"];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[data stringForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)submitFinish:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser * parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSMutableDictionary * data = (NSMutableDictionary *)[jsonDictionary dictionaryForKey:@"data"];
        self.alipayAccount = [data stringForKey:@"alipay_account"];
        self.photoType = [data stringForKey:@"photo_type"];
        self.bigUrl = [data stringForKey:@"big_url"];
        self.smallUrl = [data stringForKey:@"url"];
        self.type = [[data stringForKey:@"status"]intValue];
        if(self.type != KuaidiVerificationTypesubmit && self.delegate && [self.delegate respondsToSelector:@selector(verificationIsApply:)])
        {
            [self.delegate verificationIsApply:YES];
        }
        //刷新页面
        [self refreshVerificationStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"activityStatusRefresh" object:nil userInfo:nil];
        if (self.type == KuaidiVerificationTypeOnReview)
        {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"审核成功后，将私信通知你" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alertView show];
        }
    }
    else if([[jsonDictionary stringForKey:@"status"] isEqualToString:@"failed"])
    {
        NSMutableDictionary * data = (NSMutableDictionary *)[jsonDictionary dictionaryForKey:@"data"];
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[data stringForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)setTaxiPartner
{
    //返回数据成功
    NSArray *list = [BBTaxiLocationData getTaxiPartnerData];
    if (list)
    {
        BBTaxiPartnerView *taxiPartnerView =[[[BBTaxiPartnerView alloc]initWithFrame:CGRectMake(0, IPHONE5_ADD_HEIGHT(416)-60, 320, 40) withDiction:list withPartnerTitle:[BBTaxiLocationData getTaxiPartnerTitle]]autorelease];
        [self.view addSubview:taxiPartnerView];
//        taxiPartnerView.userInteractionEnabled = NO;
    }
    //防止被推广商盖住按钮响应区域
    [self.view bringSubviewToFront:self.submitButton];
}

- (void)submitFailed:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

- (void)fetchFailed:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

- (void)cancelSubmitFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser * parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSDictionary * data = [jsonDictionary dictionaryForKey:@"data"];
        self.alipayAccount = [data stringForKey:@"alipay_account"];
        self.photoType = [data stringForKey:@"photo_type"];
        self.bigUrl = [data stringForKey:@"big_url"];
        self.smallUrl = [data stringForKey:@"url"];
        self.type = KuaidiVerificationTypesubmit;
        self.thumbImage = nil;
        self.photoData = nil;
        //刷新页面
        [self refreshVerificationStatus];
        
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"取消审核成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
    [self.loadProgress hide:YES];
}
- (void)cancelSubmitFailed:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];    
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark -
#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取照片实例
    //要压缩一下，释放之前的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)saveImage:(UIImage *)image
{
    UIImage *uplodeImage = [BBImageScale scaleAndRotateImage:image];
    self.thumbImage = [BBImageScale createThumbImage:uplodeImage size:CGSizeMake(80, 80) percent:0];
    [self.pregnanyImageButton setImageWithURL:nil];
    [self.pregnanyImageButton setBackgroundImage:self.thumbImage forState:UIControlStateNormal] ;
    self.photoData = UIImageJPEGRepresentation(uplodeImage, 0.5);
}
//取消相机
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark- actionSheet
//选择证明照片类型
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.cameraActionSheet)
    {
        UIImagePickerControllerSourceType sourceType = 0;
        if (buttonIndex == 0)
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if (buttonIndex == 1)
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else
        {
            return;
        }
        
        self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        [self.imagePicker setDelegate:self];
        [self.imagePicker setAllowsEditing:NO];
        [self.imagePicker setSourceType:sourceType];
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }else
    {
        if (buttonIndex == actionSheet.numberOfButtons - 1)
        {
            return;
        }
        int index = buttonIndex + 1;
        self.photoType = [NSString stringWithFormat:@"%d",index];
        self.pregnancyIDSelector.text = [self getPhotoNameByType:index];
    }
}

#pragma mark- textFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
