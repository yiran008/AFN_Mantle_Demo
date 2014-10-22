//
//  BBShareContent.h
//  pregnancy
//
//  Created by yxy on 14-5-6.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialQQHandler.h"

@interface BBShareContent : NSObject

/*
 分享参数说明:
 item:区分各分享平台
 controller：当前viewController，传值self
 shareText: 分享到手机QQ QQ空间 腾讯微博 新浪微博对应的文字
 shareOriginImage:分享是所需图片 UIImage类型
 shareWXTimelineTitle:分享到微信朋友圈的标题
 shareWXTimelineDescription:分享到微信朋友圈对应的正文
 shareWXSessionTile:分享到微信好友的标题
 shareWXSessionDescription:分享到微信好友正文
 shareWebPageUrl:分享到微信后跳转Wap页地址，分享到其他平台对应链接地址
 */
+ (void)shareContent:(BBShareMenuItem *)item withViewController:(UIViewController *)controller withShareText:(NSString *)text withShareOriginImage:(UIImage *)image withShareWXTimelineTitle:(NSString *)timelineTitle withShareWXTimelineDescription:(NSString *)timelineDescription withShareWXSessionTitle:(NSString *)sessionTitle withShareWXSessionDescription:(NSString *)sessionDescription withShareWebPageUrl:(NSString *)url;



@end
