//
//  BBShareConfig.m
//  pregnancy
//
//  Created by zhongfeng on 13-8-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBShareConfig.h"
#import "UMSocial.h"

@implementation BBShareConfig

+(NSMutableArray *)getShareData {
    static NSMutableArray *shareData = nil;
    if (shareData == nil) {
        shareData = [[NSMutableArray alloc] init];
        NSDictionary *shareToFriendCircle = [NSDictionary dictionaryWithObjectsAndKeys:@"朋友圈",@"title",@"share_pengyouquan",@"imageName",UMShareToWechatTimeline,@"shareTo", nil];
        NSDictionary *shareToWeixin = [NSDictionary dictionaryWithObjectsAndKeys:@"微信",@"title",@"share_weixin",@"imageName",UMShareToWechatSession,@"shareTo", nil];
        NSDictionary *shareToSina = [NSDictionary dictionaryWithObjectsAndKeys:@"新浪微博",@"title",@"share_sina",@"imageName",UMShareToSina,@"shareTo", nil];
        NSDictionary *shareToQQZone = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ空间",@"title",@"share_qqzone",@"imageName",UMShareToQzone,@"shareTo", nil];
        NSDictionary *shareToTencent = [NSDictionary dictionaryWithObjectsAndKeys:@"腾讯微博",@"title",@"share_tencent_weibo",@"imageName",UMShareToTencent,@"shareTo", nil];
       
        [shareData addObject:shareToFriendCircle];
        [shareData addObject:shareToWeixin];
         [shareData addObject:shareToSina];
        [shareData addObject:shareToQQZone];
        [shareData addObject:shareToTencent];
    }
    return shareData;
}

+(NSMutableArray *)getShareDataAddQQ {
    static NSMutableArray *shareData = nil;
    if (shareData == nil) {
        shareData = [[NSMutableArray alloc] init];
        NSDictionary *shareToFriendCircle = [NSDictionary dictionaryWithObjectsAndKeys:@"朋友圈",@"title",@"share_pengyouquan",@"imageName",UMShareToWechatTimeline,@"shareTo", nil];
        NSDictionary *shareToWeixin = [NSDictionary dictionaryWithObjectsAndKeys:@"微信",@"title",@"share_weixin",@"imageName",UMShareToWechatSession,@"shareTo", nil];
        NSDictionary *shareToQQ = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ好友",@"title",@"share_qq",@"imageName",UMShareToQQ,@"shareTo", nil];
        NSDictionary *shareToQQZone = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ空间",@"title",@"share_qqzone",@"imageName",UMShareToQzone,@"shareTo", nil];
        NSDictionary *shareToTencent = [NSDictionary dictionaryWithObjectsAndKeys:@"腾讯微博",@"title",@"share_tencent_weibo",@"imageName",UMShareToTencent,@"shareTo", nil];
        NSDictionary *shareToSina = [NSDictionary dictionaryWithObjectsAndKeys:@"新浪微博",@"title",@"share_sina",@"imageName",UMShareToSina,@"shareTo", nil];
        [shareData addObject:shareToFriendCircle];
        [shareData addObject:shareToWeixin];
        [shareData addObject:shareToQQ];
        [shareData addObject:shareToQQZone];
        [shareData addObject:shareToTencent];
        [shareData addObject:shareToSina];
    }
    return shareData;
}

+(NSMutableArray *)getShareDataAddAlbum
{
    static NSMutableArray *shareData = nil;
    if (shareData == nil) {
        shareData = [[NSMutableArray alloc] init];
        NSDictionary *shareToFriendCircle = [NSDictionary dictionaryWithObjectsAndKeys:@"朋友圈",@"title",@"share_pengyouquan",@"imageName",UMShareToWechatTimeline,@"shareTo", nil];
        NSDictionary *shareToWeixin = [NSDictionary dictionaryWithObjectsAndKeys:@"微信",@"title",@"share_weixin",@"imageName",UMShareToWechatSession,@"shareTo", nil];
        NSDictionary *shareToQQ = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ好友",@"title",@"share_qq",@"imageName",UMShareToQQ,@"shareTo", nil];
        NSDictionary *shareToQQZone = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ空间",@"title",@"share_qqzone",@"imageName",UMShareToQzone,@"shareTo", nil];
        NSDictionary *shareToTencent = [NSDictionary dictionaryWithObjectsAndKeys:@"腾讯微博",@"title",@"share_tencent_weibo",@"imageName",UMShareToTencent,@"shareTo", nil];
        NSDictionary *shareToSina = [NSDictionary dictionaryWithObjectsAndKeys:@"新浪微博",@"title",@"share_sina",@"imageName",UMShareToSina,@"shareTo", nil];
        NSDictionary *saveToAlbum = [NSDictionary dictionaryWithObjectsAndKeys:@"保存到相册",@"title",@"save_album",@"imageName",nil,@"shareTo", nil];
        [shareData addObject:shareToFriendCircle];
        [shareData addObject:shareToWeixin];
        [shareData addObject:shareToQQ];
        [shareData addObject:shareToQQZone];
        [shareData addObject:shareToTencent];
        [shareData addObject:shareToSina];
        [shareData addObject:saveToAlbum];
    }
    return shareData;
}

@end
