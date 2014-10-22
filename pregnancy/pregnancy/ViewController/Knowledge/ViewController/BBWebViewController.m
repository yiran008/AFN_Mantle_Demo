//
//  BBWebViewController.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-5-6.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "BBSupportTopicDetail.h"

@interface BBWebViewController ()<UIWebViewDelegate,SDWebImageManagerDelegate,WebViewJavascriptBridgeDelegate>
@property (nonatomic,strong)NSArray * imgArr;
@property (nonatomic,strong)WebViewJavascriptBridge *javascriptBridge;
@property (nonatomic,assign)BOOL isFirstLoad;
@end

@implementation BBWebViewController

-(void)dealloc
{
    [self.webView stopLoading];
    self.webView.delegate = nil;
    self.webView = nil;
}

-(void)viewWillDisappear:(BOOL)animatedou
{
    [super viewWillDisappear:animatedou];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isFirstLoad = YES;
    
    self.htmlStr = [self.htmlStr stringByReplacingOccurrencesOfString:@"client_type_value" withString:@"ios"];
    self.htmlStr = [self.htmlStr stringByReplacingOccurrencesOfString:@"bpreg_brithday_value" withString:[BBPregnancyInfo pregancyDateYMDByStringForAPI]];
    self.htmlStr = [self.htmlStr stringByReplacingOccurrencesOfString:@"app_id_value" withString:@"pregnancy"];
    self.htmlStr = [self.htmlStr stringByReplacingOccurrencesOfString:@"is_prepare_value" withString:[BBUser getNewUserRoleState]==BBUserRoleStatePrepare? @"1":@"0"];
    if (self.ID) {
        self.htmlStr = [self.htmlStr stringByReplacingOccurrencesOfString:@"knowleage_id_value" withString:self.ID];
    }

    self.javascriptBridge = [WebViewJavascriptBridge javascriptBridgeWithDelegate:self];
    self.webView.delegate = self.javascriptBridge;
    [self.webView loadHTMLString:self.htmlStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    NSArray * imgArr = nil;
    if (self.imagesStr)
    {
        imgArr = [NSJSONSerialization JSONObjectWithData:[self.imagesStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }

    self.imgArr = imgArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)loadHtMLSTring
{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)changeWebViewMark:(UIWebView *)webView withMark:(NSString *)mark withMarkUrl:(NSString *)markurl
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
                                                     @"(function (name,localUrl){"
                                                     "	var list = document.getElementsByName(name);"
                                                     "	if (list.length == 0){return;};"
                                                     "	var slice = Array.prototype.slice;"
                                                     "	slice.call(list).forEach(function(v){v.src=localUrl;v.style.display='block';});"
                                                     "})('%@','%@');",mark,markurl]];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    NSString * mark = [info objectForKey:@"name"];
    NSString * urlStr = [imageManager getCachePathForKey:[info stringForKey:@"big_src"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:urlStr];
    if (result)
    {
        if (mark && urlStr)
        {
            [self changeWebViewMark:self.webView withMark:mark withMarkUrl:urlStr];
        }
    }
    
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithData:(NSData *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    if (image)
    {
        NSString * mark = [info objectForKey:@"name"];
        NSString * urlStr = [imageManager getCachePathForKey:[info stringForKey:@"big_src"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:urlStr contents:image attributes:nil];

        if (mark && urlStr) {
            [self changeWebViewMark:self.webView withMark:mark withMarkUrl:urlStr];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.isFirstLoad)
    {
        for (NSMutableDictionary * dic in self.imgArr)
        {
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[dic stringForKey:@"big_src"]] delegate:self options:SDWebImageRetryFailed userInfo:dic];
        }
        self.isFirstLoad = NO;
    }
    [webView  stringByEvaluatingJavaScriptFromString:@"(function(){"
     "var isAdded = document.getElementById(\"huishi\");"
     "var target;"
     "if(!isAdded){"
     "target = document.getElementById(\"ad3\");"
     "var xdd=document.createElement(\"div\");"
     "xdd.id=\"huishi\";"
     "var xa=document.createElement(\"a\");"
     "xa.style.color = \"#faabaa\";"
     "xa.href=\"javascript:void(0);retrun false;\";"
     "xa.onclick=function(){adAction('孕期专业呵护热线','http://r.babytree.com/equj2w');};"
     "xa.innerHTML=\"重磅推出新功能：免费拨打孕期专业呵护热线\";"
     "xdd.appendChild(xa);"
     "target.parentNode.insertBefore(xdd,target.previousSibling);}"
     "}());"];
 
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - WebViewJavascriptBridgeDelegate
-(void)adAction:(NSString *)title withUrl:(NSString *)url
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(adAction:withUrl:)])
    {
        [self.delegate adAction:title withUrl:url];
    }
}
- (void)topicInnerUrl:(NSString *)url
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(topicInnerUrl:)])
    {
        [self.delegate topicInnerUrl:url];
    }
}
@end
