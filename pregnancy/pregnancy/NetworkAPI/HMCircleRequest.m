//
//  HMCircleRequest.m
//  lama
//
//  Created by Heyanyang on 13-6-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMApiRequest.h"

@implementation HMApiRequest (HMCircleRequest)

// 分类的更多圈子
+ (ASIFormDataRequest *)circleListwithStart:(NSInteger)page withClassId:(NSString *)theClassID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/new_more_group_list", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
    [request setGetValue: theClassID ? theClassID : @"-2" forKey:@"class_id"];
    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    [request setGetValue:[NSString stringWithFormat:@"%.0f", [[BBPregnancyInfo dateOfPregnancy] timeIntervalSince1970]] forKey:@"birthday_ts"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 某人已加入的帮
+ (ASIFormDataRequest *)myCircleListwithStart:(NSInteger)page WithUserID:(NSString *)theUserID
{ 
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/user_group_list_v2", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //翻页各种字段名
    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"page"];
    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"pg"];
    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"start"];
    [request setGetValue:[NSString stringWithFormat:@"%ld", (long)page] forKey:@"current_page"];
    if ([BBUser isLogin]) {
        [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
        [request setGetValue:theUserID forKey:@"enc_user_id"];
    }
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare) {
        [request setGetValue:@"1" forKey:@"is_prepare"];
    }
    if ([BBPregnancyInfo pregancyDateByYMString] && [BBPregnancyInfo pregancyDateByYMString].length > 0) {
        [request setGetValue:[BBPregnancyInfo pregancyDateByYMString] forKey:@"birthday_ts"];
    }

    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

// ppp
// 加入和退出推荐圈子
+ (ASIFormDataRequest *)addTheCircleWithGroupIDS:(NSString *)theGroupIDS andQuitGroups:(NSString *)quitStr
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/join_group", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    if (theGroupIDS && theGroupIDS.length)
    {
        [request setGetValue:theGroupIDS forKey:@"group_id"];
    }
    
    if (quitStr && quitStr.length)
    {
        [request setGetValue:quitStr forKey:@"quit_unselect"];
    }
    
    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];

    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 加入圈子
+ (ASIFormDataRequest *)addTheCircleWithGroupID:(NSString *)theGroupID
{
    [MobClick event:@"discuz_v2" label:@"加入圈子"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/join_group", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setGetValue:[NSString stringWithFormat:@"%@", theGroupID] forKey:@"group_id"];
    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];

    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 退出圈子
+ (ASIFormDataRequest *)quitTheCircleWithGroupID:(NSString *)theGroupID
{
    [MobClick event:@"discuz_v2" label:@"取消加入"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/quit_group", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setGetValue:theGroupID forKey:@"group_id"];
    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    
    if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
    {
        [request setGetValue:@"1" forKey:@"is_prepare"];
    }
    else
    {
        [request setGetValue:@"0" forKey:@"is_prepare"];
    }

    ASI_DEFAULT_INFO_GET
    
    return request;
}

// 圈子置顶
+ (ASIFormDataRequest *)setCircleTop:(NSString *)theGroupID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/set_group_top_v2", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    [request setGetValue:theGroupID forKey:@"group_id"];

    ASI_DEFAULT_INFO_GET

    return request;
}

+ (ASIFormDataRequest *)setCircleAdminList:(NSString *)groupID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_group_admin_list", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin])
    {
        [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    }
    [request setGetValue:groupID forKey:@"group_id"];
    ASI_DEFAULT_INFO_GET
    
    return request;
}


+ (ASIFormDataRequest *)setCircleTopMemberList:(NSString *)groupID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_group_member_rank", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin])
    {
        [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    }
    [request setGetValue:groupID forKey:@"group_id"];
    ASI_DEFAULT_INFO_GET
    return request;
}

+ (ASIFormDataRequest *)setCircleDisMemberList:(NSString *)groupID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_group_member_lbs_rank", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin])
    {
        [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    }
    [request setGetValue:groupID forKey:@"group_id"];
    ASI_DEFAULT_INFO_GET
    return request;
}


+ (ASIFormDataRequest *)setCircleAgeMemberList:(NSString *)groupID
{
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/mobile_community/get_group_member_by_age", BABYTREE_URL_SERVER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([BBUser isLogin])
    {
        [request setGetValue:[BBUser getLoginString] forKey:@"login_string"];
    }
    [request setGetValue:groupID forKey:@"group_id"];
    
    ASI_DEFAULT_INFO_GET
    
    return request;
}

@end