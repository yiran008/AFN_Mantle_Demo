//
//  BBInvitePapaViewController.m
//  pregnancy
//
//  Created by mac on 13-5-27.
//  Copyright (c) 2013年 babytree. All rights reserved.
//
#import "BBInvitePapaViewController.h"
#import "MobClick.h"
#import "BBNavigationLabel.h"
#import "UMSocial.h"
#import "BBBandFatherRequest.h"
#import "BBFatherInfo.h"

#define UNBAND_ALERT_TAG 10

@interface BBInvitePapaViewController ()
@property (nonatomic, retain) NSMutableArray *shareData;

@end

@implementation BBInvitePapaViewController
@synthesize delegate;

@synthesize m_TitleLabel;
@synthesize m_ActivityIndicatorView;

@synthesize m_ContentView;
@synthesize m_CodeLabel;

@synthesize m_InviteBtn;
@synthesize m_UnbindBtn;
@synthesize m_FreshBtn;

@synthesize m_BindStatus;
@synthesize m_BindCode;

@synthesize m_IsFresh;

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
    [_m_Request clearDelegatesAndCancel];
    [_m_UnBandRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"邀请准爸爸";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.title]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];

    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    [self initShareData];
    
    if (IS_IPHONE5) {
        [self.m_InviteBg setImage:[UIImage imageNamed:@"inviteFatherBackground_iphone5"]];
        [self.m_TitleLabel setFrame:CGRectMake(self.m_TitleLabel.frame.origin.x, self.m_TitleLabel.frame.origin.y+40, self.m_TitleLabel.frame.size.width, self.m_TitleLabel.frame.size.height)];
        [self.m_ContentView setFrame:CGRectMake(self.m_ContentView.frame.origin.x, self.m_ContentView.frame.origin.y+40, self.m_ContentView.frame.size.width, self.m_ContentView.frame.size.height)];
        [self.m_InviteBtn setFrame:CGRectMake(self.m_InviteBtn.frame.origin.x, self.m_InviteBtn.frame.origin.y+40, self.m_InviteBtn.frame.size.width, self.m_InviteBtn.frame.size.height)];
        [self.m_UnbindBtn setFrame:CGRectMake(self.m_UnbindBtn.frame.origin.x, self.m_UnbindBtn.frame.origin.y+40, self.m_UnbindBtn.frame.size.width, self.m_UnbindBtn.frame.size.height)];
        [self.m_FreshBtn setFrame:CGRectMake(self.m_FreshBtn.frame.origin.x, self.m_FreshBtn.frame.origin.y+40, self.m_FreshBtn.frame.size.width, self.m_FreshBtn.frame.size.height)];
    }
    
    [self updateStatus];
//    [self refreshView];
    
    // 无邀请码时，刷新状态获取邀请码
    if (m_BindCode == nil)
    {
        [self freshPress:nil];
    }
    
    self.m_FreshBtn.exclusiveTouch = YES;
    self.m_InviteBtn.exclusiveTouch = YES;
    self.m_UnbindBtn.exclusiveTouch = YES;
    self.m_FreshBtn.hidden = YES;
    self.m_InviteBtn.hidden = YES;
    self.m_UnbindBtn.hidden = YES;

}

- (void)initShareData {
    self.shareData = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *shareToWeixin = [NSDictionary dictionaryWithObjectsAndKeys:@"微信",@"title",@"share_weixin",@"imageName",UMShareToWechatSession,@"shareTo", nil];
    NSDictionary *shareToSms = [NSDictionary dictionaryWithObjectsAndKeys:@"短信",@"title",@"share_sms",@"imageName",UMShareToSms,@"shareTo", nil];
    [self.shareData addObject:shareToSms];
    [self.shareData addObject:shareToWeixin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView
{
    if (m_IsFresh)
    {
        // 刷新中
        m_TitleLabel.text = @"正在获取数据，请稍后...";
        [m_ActivityIndicatorView startAnimating];
        
        m_ContentView.hidden = YES;
        m_InviteBtn.hidden = YES;
        m_UnbindBtn.hidden = YES;
        
        m_FreshBtn.hidden = NO;
        m_FreshBtn.enabled = NO;
        
        m_IsFresh = NO;
    }
    else if (m_BindCode == nil)
    {
        // 无邀请码
        m_TitleLabel.text = @"获取数据失败，请重新获取";
        [m_ActivityIndicatorView stopAnimating];
        
        m_ContentView.hidden = YES;
        m_InviteBtn.hidden = YES;
        m_UnbindBtn.hidden = YES;
        
        m_FreshBtn.hidden = NO;
        m_FreshBtn.enabled = YES;
    }
    else if (m_BindStatus)
    {
        // 已绑定
        m_TitleLabel.text = @"您已邀请了爸爸。";
        [m_ActivityIndicatorView stopAnimating];
                m_ContentView.hidden = NO;
        m_CodeLabel.text = m_BindCode;
        m_InviteBtn.left = 41;
        [m_InviteBtn setTitle:@"重发邀请" forState:UIControlStateNormal];
        m_InviteBtn.hidden = NO;
        m_UnbindBtn.hidden = NO;
        
        m_FreshBtn.hidden = YES;
    }
    else
    {
        // 未绑定
        m_TitleLabel.text = @"让准爸爸了解一些孕期知识，还可以为您增加孕气。";
        [m_ActivityIndicatorView stopAnimating];
        
        m_ContentView.hidden = NO;
        m_CodeLabel.text = m_BindCode;
        m_InviteBtn.left = 107;
        [m_InviteBtn setTitle:@"发送邀请" forState:UIControlStateNormal];
        m_InviteBtn.hidden = NO;
        m_UnbindBtn.hidden = YES;
        
        m_FreshBtn.hidden = YES;
    }
}

#pragma mark - Method

- (IBAction)backAction:(id)sender
{
//    [delegate InvitePapaViewControllerClose];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)invitePress:(id)sender
{
    BBShareMenu *menu = [[BBShareMenu alloc] initWithType:0 dataArray:self.shareData title:@"邀请准爸爸"];
    menu.delegate = self;
    [menu show];
    
}

- (IBAction)unbindPress:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"解除绑定后，准爸爸将不能再给你加孕气了！"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = UNBAND_ALERT_TAG;
    [alert show];
}

#pragma alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == UNBAND_ALERT_TAG) {
        if (buttonIndex == 1) {
            [self.m_UnBandRequest clearDelegatesAndCancel];
            
            self.m_UnBandRequest = [BBBandFatherRequest unBind];
            [self.m_UnBandRequest setDidFinishSelector:@selector(unBindRequestFinish:)];
            [self.m_UnBandRequest setDidFailSelector:@selector(unBindRequestFail:)];
            self.m_UnBandRequest.delegate = self;
            [self.m_UnBandRequest startAsynchronous];
            // 取消绑定
            m_IsFresh = YES;
            [self refreshView];
        }
    }
}


#pragma mark - unBindRequest Delegate Method

- (void)unBindRequestFinish:(ASIFormDataRequest *)request
{
    BOOL needFresh = NO;
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    
    // 解除绑定结果
    if ([[parserData stringForKey:@"status"] isEqualToString:@"success"])
    {
        m_BindStatus = NO;
        [BBUser setBandFatherStatus:m_BindStatus];
        NSDictionary *data = [parserData dictionaryForKey:@"data"];
        if (data != nil && (NSNull *)data != [NSNull null])
        {
            // 新邀请码
            NSString *bind_code = [data stringForKey:@"code"];
            if (!stringIsEmpty(bind_code))
            {
                self.m_BindCode = bind_code;
                [BBFatherInfo setPapaBindCode:bind_code];
            }
            else
            {
                self.m_BindCode = nil;
            }
        }
        else
        {
            self.m_BindCode = nil;
        }
    }
    else if ([[parserData stringForKey:@"status"] isEqualToString:@"father_edition_no_bind"])
    {
        m_BindStatus = NO;
        [BBUser setBandFatherStatus:m_BindStatus];
    }
    
    if (needFresh)
    {
        [self updateStatus];
    }
    [self refreshView];

}

- (void)unBindRequestFail:(ASIFormDataRequest *)request
{
    [self refreshView];
}


- (IBAction)freshPress:(id)sender
{
    // 刷新数据
    m_IsFresh = YES;
    [self refreshView];
    [self updateStatus];
}

// 获取绑定状态
- (void)updateStatus
{
    [self.m_Request clearDelegatesAndCancel];
    self.m_Request = [BBBandFatherRequest bindStatus];
    [self.m_Request setDidFinishSelector:@selector(getBindStatusRequestFinish:)];
    [self.m_Request setDidFailSelector:@selector(getBindStatusRequestFail:)];
    self.m_Request.delegate = self;
    [self.m_Request startAsynchronous];
}

#pragma mark - getBandStateRequest Delegate Method

- (void)getBindStatusRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    
    if ([[parserData stringForKey:@"status"] isEqualToString:@"success"])
    {
        NSDictionary *data = [parserData dictionaryForKey:@"data"];
        if (data != nil && (NSNull *)data != [NSNull null])
        {
            // 状态
            NSString *bind_status = [data stringForKey:@"bind_status"];
            if (stringIsEmpty(bind_status))
            {
                m_BindStatus = NO;
            }
            else
            {
                m_BindStatus = [bind_status isEqualToString:@"1"];
                if ([[data stringForKey:@"bind_status"] isEqualToString:@"1"]) {
                    [NoticeUtil cancelCustomLocationNoti:@"BBMotherBindingNoti"];
                }
                
                // 邀请码
                NSString *bind_code = [data stringForKey:@"code"];
                if (!stringIsEmpty(bind_code))
                {
                    self.m_BindCode = bind_code;
                    [BBFatherInfo setPapaBindCode:bind_code];
                    [BBUser setPapaBindCode:bind_code];
                }
                else
                {
                    self.m_BindCode = nil;
                }
            }
            
            [BBFatherInfo setPapaBindStatus:m_BindStatus];
//            self.hidden = m_BindStatus;
        }
        [BBUser setUserLevel:[data stringForKey:@"level_num"]];
    }
    
    [self refreshView];
}

- (void)getBindStatusRequestFail:(ASIFormDataRequest *)request
{
    self.m_BindCode = nil;
    [self refreshView];
}

#pragma mark -
#pragma mark ShareMenuDelegate
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item {
    
    if (item.indexAtMenu == 0) {
        [MobClick event:@"invite_husband_v2" label:@"邀请准爸爸-发送邀请-短信"];
        //判断当前设备是否可以发送短信息
        BOOL canSendSMS = [MFMessageComposeViewController canSendText];
        BBLog(@"can send SMS [%d]",canSendSMS);
        
        if(canSendSMS)
        {
            MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
            //设置委托
            mc.messageComposeDelegate = self;
            //短信内容
            mc.body = [NSString stringWithFormat:@"亲爱哒，装一下这个宝宝树孕育(下载地址%@ )，我记不住的你要提醒我哈，我的邀请码是%@。爱你呦。",SHARE_DOWNLOAD_URL,m_BindCode];
            //短信接收者，可设置多个
            [self presentViewController:mc animated:YES completion:^{
                
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"您使用的设备不能发送短信"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }else if (item.indexAtMenu == 1) {
        [MobClick event:@"invite_husband_v2" label:@"邀请准爸爸-发送邀请-微信"];
        [MobClick event:@"share_v2" label:@"微信图标点击"];
        if(![WXApi isWXAppInstalled])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有安装微信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = [NSString stringWithFormat:@"亲爱哒，装一下这个宝宝树孕育(下载地址%@ )，我记不住的你要提醒我哈，我的邀请码是%@。爱你呦。",SHARE_DOWNLOAD_URL, m_BindCode];
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }
    
    
}

#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch(result)
    {
        case MessageComposeResultFailed:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信发送失败"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
            
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;            
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
