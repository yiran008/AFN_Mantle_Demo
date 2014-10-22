//
//  BBShareContent.m
//  pregnancy
//
//  Created by yxy on 14-5-6.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBShareContent.h"
#import "BBImageScale.h"

// 分享渠道
typedef enum {
    ShareChannel_wx_timeline = 0,
    ShareChannel_wx_session,
    ShareChannel_qq_friend,
    ShareChannel_qq_zone,
    ShareChannel_qq_weibo,
    ShareChannel_sina_weibo,
} ShareChannel;

@implementation BBShareContent

+ (void)shareContent:(BBShareMenuItem *)item withViewController:(UIViewController *)controller withShareText:(NSString *)text withShareOriginImage:(UIImage *)image withShareWXTimelineTitle:(NSString *)timelineTitle withShareWXTimelineDescription:(NSString *)timelineDescription withShareWXSessionTitle:(NSString *)sessionTitle withShareWXSessionDescription:(NSString *)sessionDescription withShareWebPageUrl:(NSString *)url
{
    // 分享文字为空
    if(![text isNotEmpty])
    {
        text = @"宝宝树孕育";
    }
    
    // 分享图片为空 默认为快乐孕期logo
    if(image == nil)
    {
        image = [UIImage imageNamed:@"topic_share_icon"];
    }
    
    // 分享到微信朋友圈标题为空
    if(![timelineTitle isNotEmpty])
    {
        timelineTitle = @"";
    }
    
    // 分享微信朋友圈描述为空
    if(![timelineDescription isNotEmpty])
    {
        timelineDescription = @"";
    }
    
    // 分享到微信好友标题为空
    if(![sessionTitle isNotEmpty])
    {
        timelineTitle = @"";
    }
    
    // 分享微信好友描述为空
    if(![sessionDescription isNotEmpty])
    {
        timelineDescription = @"";
    }
    
    // 分享到微信点击跳转网页地址为空，默认跳转,需要再订
    if(![url isNotEmpty])
    {
        url = @"";
    }
    
    UIImage *smallImage = [BBImageScale imageScalingToSmallSize:image];
    // 分享到朋友圈，孕期logo
    UIImage *logoImage = [UIImage imageNamed:@"topic_share_icon"];
    UIImage *smallLogoImage = [BBImageScale imageScalingToSmallSize:logoImage];
    if(item.indexAtMenu == 0 || item.indexAtMenu == 1)
    {
        if(item.indexAtMenu == 0)
        {
            [MobClick event:@"share_v2" label:@"朋友圈图标点击"];
        }
        else
        {
            [MobClick event:@"share_v2" label:@"微信图标点击"];
        }
        if(![WXApi isWXAppInstalled])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有安装微信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    if (item.indexAtMenu == 0) {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:smallLogoImage];
        message.title = timelineTitle;
        message.description = timelineDescription;
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        
        // 目前微信图片点击后存在查看图片功能，有url时跳转wap
        if([url isNotEmpty])
        {
            WXWebpageObject *webPage= [[WXWebpageObject alloc] init];
            webPage.webpageUrl = [BBShareContent manageShareChannelFromWeburl:url withChannel:0];
            message.mediaObject = webPage;
        }
        else
        {
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = UIImageJPEGRepresentation(logoImage,0.8);
            message.mediaObject = imageObject;
            
        }
        
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
        return;
        
    }else if(item.indexAtMenu == 1) {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:smallImage];
        message.description = sessionDescription;
        message.title = sessionTitle;
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        
        // 目前微信图片点击后存在查看图片功能，有url时跳转wap
        if([url isNotEmpty])
        {
            WXWebpageObject *webPage= [[WXWebpageObject alloc] init];
            webPage.webpageUrl = [BBShareContent manageShareChannelFromWeburl:url withChannel:1];
            message.mediaObject = webPage;
        }
        else
        {
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = UIImageJPEGRepresentation(image,0.8);
            message.mediaObject = imageObject;
        }
        
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
        return;
    }
    
    
    [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@ %@",text,url];
    [UMSocialData defaultData].shareImage = image;
    
    NSString *snsType = UMShareToSina;
    
    // QQ，QQ空间分享必须设定url,默认为宝宝树网站首页
    if(![url isNotEmpty])
    {
        url = [NSString stringWithFormat:@"http://m.babytree.com/"];
    }
    
    if(item.indexAtMenu == 2) {
        [MobClick event:@"share_v2" label:@"QQ好友图标点击"];
        // QQ分享模式同分享到微信好友模式，相关文字提示同微信好友
        [UMSocialData defaultData].shareText = sessionDescription;
        [UMSocialData defaultData].extConfig.qqData.url = [BBShareContent manageShareChannelFromWeburl:url withChannel:2];
        [UMSocialData defaultData].extConfig.qqData.title = sessionTitle;
        if(![sessionDescription isNotEmpty])
        {
            [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@ %@",text,[BBShareContent manageShareChannelFromWeburl:url withChannel:2]];
        }
        
        snsType = UMShareToQQ;
    }else if(item.indexAtMenu == 3) {
        [MobClick event:@"share_v2" label:@"QQ空间图标点击"];
        // QQ空间分享模式同分享到微信好友模式，相关文字提示同微信好友
        [UMSocialData defaultData].extConfig.qzoneData.url = [BBShareContent manageShareChannelFromWeburl:url withChannel:3];
        [UMSocialData defaultData].extConfig.qzoneData.title = sessionTitle;
        [UMSocialData defaultData].shareText = sessionDescription;
        // QQ空间分享时图片尺寸大时，会提示手机QQ无法打开无法分享成功
        [UMSocialData defaultData].shareImage = [BBImageScale imageScalingToSmallSize:image];
        if(![sessionDescription isNotEmpty])
        {
            [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@ %@",text,[BBShareContent manageShareChannelFromWeburl:url withChannel:3]];
        }
        snsType = UMShareToQzone;
    }else if(item.indexAtMenu == 4) {
        [MobClick event:@"share_v2" label:@"腾讯微博图标点击"];
        snsType = UMShareToTencent;
        [UMSocialData defaultData].shareText = [BBShareContent shareTextToWeibo:text withUrl:url withChannel:4];
    }else if(item.indexAtMenu == 5) {
        [MobClick event:@"share_v2" label:@"新浪微博图标点击"];
        snsType = UMShareToSina;
        [UMSocialData defaultData].shareText = [BBShareContent shareTextToWeibo:text withUrl:url withChannel:5];
    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsType];
    snsPlatform.snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}

// 分享到腾讯微博 新浪微博文案，其中url及（分享自@快乐孕期）需要保留
+ (NSString *)shareTextToWeibo:(NSString *)text withUrl:(NSString *)url withChannel:(NSInteger)channel
{
    NSString *shareText = @"";
    NSString *webUrl = [BBShareContent manageShareChannelFromWeburl:url withChannel:channel];
    
    NSString *normalText = @"（分享自@宝宝树孕育）";
    NSInteger length = [webUrl length]/2 + [normalText length];
    NSRange range = NSMakeRange(0, 140 - (length >= 140 ? 140:length));
    if([text length] > range.length)
    {
        shareText = [NSString stringWithFormat:@"%@%@%@",[text substringWithRange:range],webUrl,normalText];
    }
    else
    {
        shareText = [NSString stringWithFormat:@"%@%@%@",text,webUrl,normalText];
    }
    return shareText;
}

// 处理url，统计分享渠道
+ (NSString *)manageShareChannelFromWeburl:(NSString *)webUrl withChannel:(NSInteger)channel
{
    NSString *fromChannel = @"mediaPlaceHolder";
    switch (channel) {
        case 0:
            fromChannel = @"wx_f_c";
            break;
        case 1:
            fromChannel = @"wx_f";
            break;
        case 2:
            fromChannel = @"qq_f";
            break;
        case 3:
            fromChannel = @"qq_z";
            break;
        case 4:
            fromChannel = @"qq_w";
            break;
        case 5:
            fromChannel = @"sina_w";
            break;
            
        default:
            break;
    }
    return [webUrl stringByReplacingOccurrencesOfString:@"mediaPlaceHolder" withString:fromChannel];
}
@end
