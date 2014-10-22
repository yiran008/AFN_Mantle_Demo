//
//  BBKnowledgeLibVC.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBKnowledgeLibDetailVC.h"
#import "BBKonwlegdeDB.h"
#import "BBKownledgeWebView.h"
#import "BBKnowledgeRequest.h"
#import "ASIHTTPRequest.h"
#import "SDImageCache.h"
#import "BBShareContent.h"
#import "WebViewJavascriptBridge.h"
#import "BBSupportTopicDetail.h"
#import "HMTopicDetailVC.h"
#import "HMShowPage.h"

@interface BBKnowledgeLibDetailVC ()<ShareMenuDelegate,BBLoginDelegate,WebViewJavascriptBridgeDelegate,SDWebImageManagerDelegate>
@property(nonatomic,strong)NSString *curID;
@property(nonatomic,strong)ASIHTTPRequest *collectRequest;
@property BOOL isCurCollect;
//@property NSMutableDictionary *allCollects;
@property UIButton *collectButton;
@property ASIHTTPRequest *fecthCollectRequest;
@property (nonatomic,strong)BBKownledgeWebView *web;
@property (nonatomic,strong)NSArray * imgArr;
@property (nonatomic,strong)WebViewJavascriptBridge *javascriptBridge;
@property (nonatomic,assign)BOOL isFirstLoad;
@property(nonatomic,strong)MBProgressHUD *saveDueProgress;
@end

@implementation BBKnowledgeLibDetailVC

-(void)dealloc
{
    [_collectRequest clearDelegatesAndCancel];
    [_fecthCollectRequest clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithID:(NSString *)knowledgeID
{
    self = [super init];
    if (self)
    {
        self.curID = knowledgeID;
        self.m_ReadKnowledgeFromWebOnly = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"knowledge_lib_v2" label:@"知识详情页pv"];
    
    self.isFirstLoad = YES;
    
    //self.allCollects = [BBUser getKnowledgeCollects];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.collectButton setImage:[UIImage imageNamed:self.isCurCollect ?@"collected_icon" : @"collect_icon"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"collect_icon_pressed"] forState:UIControlStateHighlighted];
    [self.collectButton addTarget:self action:@selector(doCollect) forControlEvents:UIControlEventTouchUpInside];
    self.collectButton.exclusiveTouch = YES;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.exclusiveTouch = YES;
    [shareButton setFrame:CGRectMake(0, 0, 40, 30)];
    [shareButton setImage:[UIImage imageNamed:@"shareBarButton"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"shareBarButtonPressed"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareTopicClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.collectButton];
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[commitBarButton,shareBarButton];
    
    if (self.m_ReadKnowledgeFromWebOnly)
    {
        [self readKnowledgeFromWeb];
    }
    else
    {
        [self readKnowledgeFromLocalDBAndWeb];
    }
    
    self.javascriptBridge = [WebViewJavascriptBridge javascriptBridgeWithDelegate:self];
    self.web.delegate = self.javascriptBridge;
    
    [self.view addSubview:self.web];
    
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"知识详情" withWidth:(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?180:150)]];

    [self fecthCollectStatus];
    
    self.saveDueProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.saveDueProgress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)readKnowledgeFromWeb
{
    self.web = [[BBKownledgeWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.babytree.com/knowledge/detail.php?kid=%@&babytree-app-id=pregnancy",self.curID]]];
    [self.web loadRequest:request];
}

- (void)readKnowledgeFromLocalDBAndWeb
{
    BBKonwlegdeModel * mode = [BBKonwlegdeDB knowledgeByID:self.curID];
    if (mode && mode.content)
    {
        //给广告插入数据
        NSString *htmlStr = mode.content;
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"client_type_value" withString:@"ios"];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"bpreg_brithday_value" withString:[BBPregnancyInfo pregancyDateYMDByStringForAPI]];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"app_id_value" withString:@"pregnancy"];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"is_prepare_value" withString:[BBUser getNewUserRoleState]==BBUserRoleStatePrepare? @"1":@"0"];
        if (mode.ID)
        {
            htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"knowleage_id_value" withString:mode.ID];
        }
        self.web = [[BBKownledgeWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) htmlStr:htmlStr imagesStr:mode.imgArrStr];
        NSArray * imgArr = nil;
        if (mode.imgArrStr)
        {
            imgArr = [NSJSONSerialization JSONObjectWithData:[mode.imgArrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }
        self.imgArr = imgArr;
    }
    else
    {
        [self readKnowledgeFromWeb];
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)leftButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

////属性覆盖,获取当前页面是否已经收藏
//- (BOOL)isCurCollect
//{
//    if (!self.allCollects)
//    {
//        return NO;
//    }
//    if ([[self.allCollects stringForKey:self.curID]isEqualToString:@"1"])
//    {
//        return YES;
//    }
//    return NO;
//}
//
////属性覆盖,设置收藏属性
//- (void)setIsCurCollect:(BOOL)isCurCollect
//{
//    if (!self.allCollects)
//    {
//        self.allCollects = [[NSMutableDictionary alloc]init];
//    }
//    [self.allCollects setObject:isCurCollect ? @"1":@"0" forKey:self.curID];
//    [BBUser setKnowledgeCollects:self.allCollects];
//}

#pragma mark -
#pragma mark ShareMenuDelegate
-(void)shareTopicClicked
{
    [MobClick event:@"knowledge_lib_v2" label:@"分享"];
    
    // 分享给好友
    BBShareMenu *menu = [[BBShareMenu alloc] initWithType:2 title:@"分享"];
    menu.delegate = self;
    [menu show];
}

//点击分享
- (void)shareMenu:(BBShareMenu *)shareMenu clickItem:(BBShareMenuItem *)item
{
    BBKonwlegdeModel *obj = [BBKonwlegdeDB knowledgeByID:self.curID];
    if (obj)
    {
        UIImage *img = nil;
        if (obj.imgArrStr)
        {
            NSArray *imageArray = [NSJSONSerialization JSONObjectWithData:[obj.imgArrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *imageDict = [imageArray firstObject];
            NSString * url = [imageDict stringForKey:@"big_src"];
            if (url && url.length)
            {
                img = [[SDImageCache sharedImageCache]imageFromKey:url];
            }
        }
        
        [BBShareContent shareContent:item withViewController:self withShareText:[NSString stringWithFormat:@"【%@】%@",obj.title?obj.title:@"",obj.description?obj.description:@""] withShareOriginImage:img withShareWXTimelineTitle:obj.title withShareWXTimelineDescription:@"" withShareWXSessionTitle:obj.title withShareWXSessionDescription:obj.description withShareWebPageUrl:[NSString stringWithFormat:@"http://m.babytree.com/knowledge/detail.php?kid=%@",obj.ID]];
    }
    else if(self.sharedData)
    {
        [BBShareContent shareContent:item withViewController:self withShareText:[NSString stringWithFormat:@"【%@】%@",self.sharedData.knowledge_title ?self.sharedData.knowledge_title:@"",self.sharedData.knowledge_content?self.sharedData.knowledge_content:@""] withShareOriginImage:nil withShareWXTimelineTitle:self.sharedData.knowledge_title withShareWXTimelineDescription:@"" withShareWXSessionTitle:self.sharedData.knowledge_title withShareWXSessionDescription:self.sharedData.knowledge_content withShareWebPageUrl:[NSString stringWithFormat:@"http://m.babytree.com/knowledge/detail.php?kid=%@",self.sharedData.knowledgeID]];
    }
}

- (void)doCollect
{
    if([BBUser isLogin])
    {
        if (self.curID)
        {
            [MobClick event:@"knowledge_lib_v2" label:self.isCurCollect?@"取消收藏":@"收藏知识"];
            [self.collectRequest clearDelegatesAndCancel];
            self.collectRequest = [BBKnowledgeRequest collectKnowledgeWithID:self.curID isDelete:self.isCurCollect];
            [self.collectRequest setDidFinishSelector:@selector(collectFinished:)];
            [self.collectRequest setDidFailSelector:@selector(collectFailed:)];
            [self.collectRequest setDelegate:self];
            [self.collectRequest startAsynchronous];
            self.collectButton.userInteractionEnabled = NO;
        }
    }
    else
    {
        [MobClick event:@"knowledge_lib_v2" label:@"收藏知识"];
        BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
        [navCtrl setColorWithImageName:@"navigationBg"];
        login.delegate = self;
        [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];
    }

}

- (void)fecthCollectStatus
{
    if (self.curID)
    {
        [self.fecthCollectRequest clearDelegatesAndCancel];
        self.fecthCollectRequest = [BBKnowledgeRequest getCollectedWithID:self.curID];
        [self.fecthCollectRequest setDidFinishSelector:@selector(fecthCollectFinished:)];
        [self.fecthCollectRequest setDidFailSelector:@selector(fecthCollectFailed:)];
        [self.fecthCollectRequest setDelegate:self];
        [self.fecthCollectRequest startAsynchronous];
    }
}

#pragma mark -
#pragma mark httpDelegate
- (void)collectFinished:(ASIFormDataRequest *)request
{
    self.collectButton.userInteractionEnabled = YES;
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        self.isCurCollect = !self.isCurCollect;
        [self.collectButton setImage:[UIImage imageNamed:self.isCurCollect ?@"collected_icon" : @"collect_icon"] forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_PERSON_COLLECT object:nil];
        [self.saveDueProgress setLabelText:self.isCurCollect? @"已收藏":@"取消收藏"];
        self.saveDueProgress.animationType = MBProgressHUDAnimationFade;
        self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.saveDueProgress.mode = MBProgressHUDModeCustomView;
        [self.saveDueProgress show:YES];
        [self.saveDueProgress hide:YES afterDelay:1];
    }
}

- (void)collectFailed:(ASIFormDataRequest *)request
{
    self.collectButton.userInteractionEnabled = YES;
    [self.saveDueProgress setLabelText:self.isCurCollect? @"取消收藏失败":@"收藏失败"];
    self.saveDueProgress.animationType = MBProgressHUDAnimationFade;
    self.saveDueProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx"]];
    self.saveDueProgress.mode = MBProgressHUDModeCustomView;
    [self.saveDueProgress show:YES];
    [self.saveDueProgress hide:YES afterDelay:1];
}

- (void)fecthCollectFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        BOOL isFavor = [[[data dictionaryForKey:@"data"]stringForKey:@"is_favorite"]isEqualToString:@"1"];
        self.isCurCollect = isFavor;
        [self.collectButton setImage:[UIImage imageNamed:self.isCurCollect ?@"collected_icon" : @"collect_icon"] forState:UIControlStateNormal];
    }
}

- (void)fecthCollectFailed:(ASIFormDataRequest *)request
{
    
}

-(void)loginFinish
{
    [self doCollect];
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
            [self changeWebViewMark:self.web withMark:mark withMarkUrl:urlStr];
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
            [self changeWebViewMark:self.web withMark:mark withMarkUrl:urlStr];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.isFirstLoad )
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

#pragma mark- AdTapDelegate
-(void)adAction:(NSString *)title withUrl:(NSString *)url
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    [exteriorURL.navigationItem setTitle:title];
    [exteriorURL setLoadURL:url];
    [self.navigationController pushViewController:exteriorURL animated:YES];
}
- (void)topicInnerUrl:(NSString *)url
{
    if ([url hasPrefix:@"http://www.babytree.com/community/topic_mobile.php"]) {
        NSArray *pramsArray = [url componentsSeparatedByString:@"?"];
        NSArray *dataArray = nil;
        NSArray *tempArray = nil;
        if([pramsArray count]>1){
            dataArray= [[pramsArray objectAtIndex:1] componentsSeparatedByString:@"&"];
        }
        NSString *topicID = @"1";
        if([dataArray count]>0){
            tempArray = [[dataArray objectAtIndex:0] componentsSeparatedByString:@"="];
        }
        if([tempArray count]>1){
            topicID  = [tempArray objectAtIndex:1];
        }
        if (![topicID isNotEmpty])
        {
            return;
        }
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_KNOWLEDGE contentId:topicID];
        [MobClick event:@"knowledge_daily_v2" label:@"帖子点击"];
        [HMShowPage showTopicDetail:self topicId:topicID topicTitle:nil];
    } else {
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        [exteriorURL.navigationItem setTitle:@"详情页"];
        [exteriorURL setLoadURL:url];
        exteriorURL.isShowCloseButton = NO;
        [self.navigationController pushViewController:exteriorURL animated:YES];
    }
}
@end
