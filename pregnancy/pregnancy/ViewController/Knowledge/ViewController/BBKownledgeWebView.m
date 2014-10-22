//
//  KownledgeWebView.m
//  konwledge-v5
//
//  Created by ZHENGLEI on 14-4-1.
//  Copyright (c) 2014年 ZHENGLEI. All rights reserved.
//

#import "BBKownledgeWebView.h"
#import "SDWebImageManager.h"

@interface BBKownledgeWebView ()<SDWebImageManagerDelegate,UIWebViewDelegate>
@property (nonatomic,retain)NSArray * imgArr;
@end

@implementation BBKownledgeWebView

- (id)initWithFrame:(CGRect)frame htmlData:(NSMutableDictionary *)data
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSString * htmlStr = [data objectForKey:@"html"];
        [self loadHTMLString:htmlStr  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        NSLog(@"%@",[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]);
        self.imgArr = [data objectForKey:@"list"];
    }
    self.delegate = self;
    return self;
}

- (id)initWithFrame:(CGRect)frame htmlStr:(NSString *)htmlStr imagesStr:(NSString *)imagesStr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray * imgArr = nil;
        if (imagesStr)
        {
            imgArr = [NSJSONSerialization JSONObjectWithData:[imagesStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadHTMLString:htmlStr  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        });
        self.imgArr = imgArr;
    }
    self.delegate = self;
    return self;
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
    if (!result)
    {
        if (image)
        {
            [fileManager createFileAtPath:urlStr contents:UIImageJPEGRepresentation(image, (CGFloat)1.0) attributes:nil];
        }
    }
    if (mark && urlStr) {
        [self changeWebViewMark:self withMark:mark withMarkUrl:urlStr];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    for (NSMutableDictionary * dic in self.imgArr)
    {
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[dic stringForKey:@"big_src"]] delegate:self options:SDWebImageRetryFailed userInfo:dic];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
