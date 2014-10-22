//
//  HMShowPage.m
//  lama
//
//  Created by babytree on 1/17/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "HMShowPage.h"
#import "HMTopicDetailVC.h"
#import "BBSupportTopicDetail.h"
#import "HMMoreCircleVC.h"
#import "HMCreateTopicViewController.h"
#import "HMCircleTopicVC.h"


@implementation HMShowPage

+ (void)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title
{
    [HMShowPage showWebView:pushVC url:url title:title showClose:NO];
}

+ (void)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showClose:(BOOL)showClose
{
    [HMShowPage showWebView:pushVC url:url title:title showClose:showClose showBackAlter:NO alterMessage:nil];
}

+ (void)showWebView:(UIViewController *)pushVC url:(NSString *)url title:(NSString *)title showClose:(BOOL)showClose showBackAlter:(BOOL)showBackAlter alterMessage:(NSString *)alterMessage
{

    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    if ([title isNotEmpty])
    {
        [exteriorURL.navigationItem setTitle:title];
    }
    exteriorURL.isShowCloseButton = NO;
    exteriorURL.hidesBottomBarWhenPushed = YES;
    //    exteriorURL.m_ShowClose = showClose;
    //    exteriorURL.m_ShowBackAlterClose = showBackAlter;
    //    exteriorURL.m_AlterMessage = alterMessage;
    exteriorURL.loadURL = url;
    [pushVC.navigationController pushViewController:exteriorURL animated:YES];

}

+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle
{
    if (![topicId isNotEmpty])
    {
        return;
    }
    
    HMTopicDetailVC *topicDetail = [[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:topicId topicTitle:topicTitle isTop:NO isBest:NO];
    topicDetail.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:topicDetail animated:YES];
}

+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle replyID:(NSString *)replyID
{
    [HMShowPage showTopicDetail:pushVC topicId:topicId topicTitle:topicTitle replyID:replyID showError:NO];
}

+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle replyID:(NSString *)replyID showError:(BOOL)showError
{
    if (![topicId isNotEmpty])
    {
        return;
    }
    
    HMTopicDetailVC *topicDetail = [[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:topicId topicTitle:topicTitle isTop:NO isBest:NO];
    topicDetail.m_ReplyID = replyID;
    topicDetail.m_ShowPositionError = showError;
    topicDetail.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:topicDetail animated:YES];
}

+ (void)showCollectedTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle;
{
    if (![topicId isNotEmpty])
    {
        return;
    }
    
    HMTopicDetailVC *topicDetail = [[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:topicId topicTitle:topicTitle isTop:NO isBest:NO];
    topicDetail.m_IsCollected = YES;
    topicDetail.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:topicDetail animated:YES];
}

+ (void)showTopicDetail:(UIViewController *)pushVC topicId:(NSString *)topicId topicTitle:(NSString *)topicTitle positionFloor:(NSInteger)positionFloor
{
    if (![topicId isNotEmpty])
    {
        return;
    }

    HMTopicDetailVC *topicDetail = [[HMTopicDetailVC alloc]initWithNibName:@"HMTopicDetailVC" bundle:nil withTopicID:topicId topicTitle:topicTitle isTop:NO isBest:NO];
    topicDetail.m_PositionFloor = positionFloor;
    topicDetail.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:topicDetail animated:YES];
}

+ (void)showMoreCircle:(UIViewController *)pushVC categoryId:(NSString *)categoryId
{
    HMMoreCircleVC *vc = [[HMMoreCircleVC alloc] init];
    if ([categoryId isNotEmpty])
    {
        vc.m_CircleIdFromOutSide = categoryId;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showDiscover:(UIViewController *)pushVC
{
//    HMDiscoveryVC *vc = [[[HMDiscoveryVC alloc] init] autorelease];
//    vc.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showDaren:(UIViewController *)pushVC
{
//    HMDarenVC *darenVC = [[[HMDarenVC alloc] init] autorelease];
//    darenVC.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:darenVC animated:YES];
}

+ (void)showPersonalCenter:(UIViewController *)pushVC userEncodeId:(NSString *)userEncodeId
{
//    HMUserCenterVC * personVC = [[[HMUserCenterVC alloc]initWithNibName:@"HMUserCenterVC" bundle:nil] autorelease];
//    personVC.m_UserID = userEncodeId;
//    personVC.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:personVC animated:YES];
}

+ (void)showPersonalCenter:(UIViewController *)pushVC userEncodeId:(NSString *)userEncodeId vcTitle:(NSString *)userName
{
//    HMUserCenterVC * personVC = [[[HMUserCenterVC alloc]initWithNibName:@"HMUserCenterVC" bundle:nil] autorelease];
//    personVC.m_UserID = userEncodeId;
//    personVC.title = title;
//    personVC.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:personVC animated:YES];
    
    BBPersonalViewController *personVC = [[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil];
    personVC.userEncodeId = userEncodeId;
    personVC.userName = userName;
    personVC.hidesBottomBarWhenPushed = YES;
    if ([userEncodeId isNotEmpty])
    {
        [pushVC.navigationController pushViewController:personVC animated:YES];
    }
}

+ (void)showPersonalCenter:(UIViewController *)pushVC listFollowType:(NSInteger)listFollowType userEncodeId:(NSString *)userEncodeId vcTitle:(NSString *)title
{
//    HMUserCenterVC * personVC = [[[HMUserCenterVC alloc]initWithNibName:@"HMUserCenterVC" bundle:nil] autorelease];
//    personVC.m_FollowType = listFollowType;
//    personVC.m_UserID = userEncodeId;
//    personVC.title = title;
//    personVC.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:personVC animated:YES];
}

+ (void)showEliteTopic:(UIViewController *)pushVC
{
//    HMEliteTopicVC *vc = [[[HMEliteTopicVC alloc] init] autorelease];
//    vc.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showHuodong:(UIViewController *)pushVC
{
//    HMHuodongVC *vc = [[[HMHuodongVC alloc] init] autorelease];
//    vc.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showBabyBoxFeedBackTopic:(UIViewController *)pushVC
{    
    HMCreateTopicViewController *editNewVC = [[HMCreateTopicViewController alloc]initWithNibName:@"HMCreateTopicViewController" bundle:nil];
    HMCircleClass *item = [[HMCircleClass alloc] init];
    item.circleId = @"36694";
    item.circleTitle = @"Babybox 交流圈";
    editNewVC.m_CircleInfo = item;
    editNewVC.title = @"Babybox反馈";
    editNewVC.tip = @"请填写您遇到的问题";
    editNewVC.topicTitle = @"意见反馈";
    editNewVC.m_IsCustomCreateTopic = YES;
    editNewVC.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:editNewVC animated:YES];

}

+ (void)showCircleTopic:(UIViewController *)pushVC circleId:(NSString *)circleId
{
    HMCircleClass *class = [[HMCircleClass alloc] init];
    class.circleId = circleId;
    [self showCircleTopic:pushVC circleClass:class];
}

+ (void)showCircleTopic:(UIViewController *)pushVC circleClass:(HMCircleClass *)circleClass
{
    HMCircleTopicVC *vc = [[HMCircleTopicVC alloc] init];
    vc.m_CircleClass = circleClass;
    vc.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:vc animated:YES];
}

+ (void)showCreateTopic:(UIViewController *)pushVC circleId:(NSString *)circleId
{
    HMCreateTopicViewController *editNewVC = [[HMCreateTopicViewController alloc]initWithNibName:@"HMCreateTopicViewController" bundle:nil];
    HMCircleClass *item = [[HMCircleClass alloc] init];
    item.circleId = circleId;
    editNewVC.m_CircleInfo = item;
    [pushVC.navigationController pushViewController:editNewVC animated:YES];
}

+ (void)showCreateTopic:(UIViewController *)pushVC circleId:(NSString *)circleId  circleName:(NSString *)circleName
{
    HMCreateTopicViewController *editNewVC = [[HMCreateTopicViewController alloc]initWithNibName:@"HMCreateTopicViewController" bundle:nil];
    HMCircleClass *item = [[HMCircleClass alloc] init];
    item.circleId = circleId;
    item.circleTitle = circleName;
    editNewVC.m_CircleInfo = item;
    editNewVC.hidesBottomBarWhenPushed = YES;
    [pushVC.navigationController pushViewController:editNewVC animated:YES];
}

+ (void)showCreateTopic:(UIViewController *)pushVC circleInfo:(HMCircleClass *)circleInfo
{
    HMCreateTopicViewController *editNewVC = [[HMCreateTopicViewController alloc]initWithNibName:@"HMCreateTopicViewController" bundle:nil];
    editNewVC.m_CircleInfo = circleInfo;
    [pushVC.navigationController pushViewController:editNewVC animated:YES];
}

+ (void)showCreateTopic:(UIViewController *)pushVC delegate:(id)delegate draft:(HMDraftBoxData *)draft
{
    HMCreateTopicViewController *createTopic = [[HMCreateTopicViewController alloc]initWithNibName:@"HMCreateTopicViewController" bundle:nil];
    createTopic.delegate = delegate;
    [createTopic setMessageWithDraft:draft];
    [pushVC.navigationController pushViewController:createTopic animated:YES];
}

+ (void)showImageShow:(UIViewController *)pushVC delegate:(id)delegate iamges:(NSMutableArray *)images index:(NSInteger)index
{
    HMImageShowViewController *imageShowViewController = [[HMImageShowViewController alloc] initWithNibName:@"HMImageShowViewController" bundle:nil];
    imageShowViewController.delegate = delegate;
    imageShowViewController.m_ImageDataArray = images;
    imageShowViewController.m_Index = index;
    [pushVC.navigationController pushViewController:imageShowViewController animated:NO];
}

+ (void)showMessageChat:(UIViewController *)pushVC title:(NSString *)title userEncodeId:(NSString *)userEncodeId
{
//    HMMessageChat *messageChat = [[[HMMessageChat alloc]initWithNibName:@"HMMessageChat" bundle:nil]autorelease];
//    messageChat.title= title;
//    messageChat.userEncodeId = userEncodeId;
//    messageChat.hidesBottomBarWhenPushed = YES;
//    [pushVC.navigationController pushViewController:messageChat animated:YES];
}

+ (void)showSelectRegist:(UIViewController *)pushVC delegate:(id)delegate
{
//    HMSelectRegisterController * selectRegistVC = [[[HMSelectRegisterController alloc] init] autorelease];
//    selectRegistVC.delegate = delegate;
//    [pushVC.navigationController pushViewController:selectRegistVC animated:YES];
}

+ (void)showRegist:(UIViewController *)pushVC delegate:(id)delegate isRegist:(BOOL)isRegist
{
//    HMRegistViewController *registViewController = [[[HMRegistViewController alloc] initWithNibName:@"HMRegistViewController" bundle:nil] autorelease];
//    registViewController.delegate = delegate;
//    registViewController.m_IsRegist = isRegist;
//    [pushVC.navigationController pushViewController:registViewController animated:YES];
}

+ (void)showUserInfoHospital:(UIViewController *)pushVC delegate:(id)delegate
{
//    HMUserInfoHospitalViewController *userInfoHospitalViewController = [[[HMUserInfoHospitalViewController alloc] initWithNibName:@"HMUserInfoHospitalViewController" bundle:nil] autorelease];
//    userInfoHospitalViewController.delegate = delegate;
//    [pushVC.navigationController pushViewController:userInfoHospitalViewController animated:YES];
}

@end
