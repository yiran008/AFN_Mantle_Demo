//
//  BBHospitalCell.m
//  pregnancy
//
//  Created by mac on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalCell.h"
#import "BBHospitalRequest.h"
#import "HMShowPage.h"
#import "HMMyCircleList.h"
#import "HMCircleTopicVC.h"

@implementation BBHospitalCell

@synthesize nameLabel, postNumLabel, pregnanryNumLabel, itemData, myRequest, hud, button,jianDangGongLueBtn,viewCtrl;

- (void)dealloc
{
    [nameLabel release];
    [postNumLabel release];
    [pregnanryNumLabel release];
    [itemData release];
    [myRequest clearDelegatesAndCancel];
    [myRequest release];
    [hud release];
    [button release];
    [jianDangGongLueBtn release];
    [_myHospitalButton release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (IBAction)setMyHospitalAction:(id)sender
{
    [BBStatisticsUtil setEvent:@"wodeyiyuan"];
    if([BBUser isLogin]){
        [self requestSetMyHopital];
    }else{
        BBLogin *login = [[[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil]autorelease];
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[[BBCustomNavigationController alloc]initWithRootViewController:login]autorelease];
        [navCtrl setColorWithImageName:@"navigationBg"];
        login.delegate = self;
        [viewCtrl.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];
    }
}

- (void)requestSetMyHopital
{
    self.hud = [[[MBProgressHUD alloc] initWithView:self.viewCtrl.view] autorelease];
    [self.viewCtrl.view addSubview:hud];
    
    [hud setLabelText:@"加载中..."];
    [hud show:YES];
    
    if (self.myRequest != nil) {
        [self.myRequest clearDelegatesAndCancel];
    }
    self.myRequest = [BBHospitalRequest setHospitalWithName:nil withId:[NSString stringWithFormat:@"%@",[self.itemData stringForKey:@"id"]] withCityCode:nil];
    [myRequest setDelegate:self];
    [myRequest setDidFinishSelector:@selector(connectFinished:)];
    [myRequest setDidFailSelector:@selector(connectFail:)];
    [myRequest startAsynchronous];
}

#pragma mark - CallBack
- (void)callback
{
    [self requestSetMyHopital];
}

- (void)loginFinish
{
    [self requestSetMyHopital];
}

#pragma mark-- ASIFormDataRequest
- (void)connectFinished:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    NSLog(@"%@", parserData);
    if (error != nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    
    if ([[parserData stringForKey:@"status"] isEqualToString:@"success"])
    {
        //解决返回时间快于弹出对话框崩溃bug，增加一次retain，在代理里面释放
        [self retain];
        if (![[BBHospitalRequest getPostSetHospital] isNotEmpty])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_MORECIRCLE_LOGIN_STATE object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
        }
        
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"设置成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        
    } 
    else 
    {
        //测试
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[parserData stringForKey:@"status"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)connectFail:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //解决返回时间快于弹出对话框崩溃bug，增加一次retain，在代理里面释放
    if ([self retainCount]==1) {
        [self release];
        return;
    }
    [self release];
    //以上是解决返回时间快于弹出对话框崩溃bug，增加一次retain，在代理里面释放
    NSString *name = [self.itemData stringForKey:@"name"];
    NSString *hospitalId = [self.itemData stringForKey:@"id"];
    NSString *groupId = [self.itemData stringForKey:@"group_id"];
    NSDictionary *category = [[[NSDictionary alloc] initWithObjectsAndKeys:name, kHospitalNameKey, hospitalId, kHospitalHospitalIdKey, groupId, kHospitalGroupIdKey, nil] autorelease];
    [BBHospitalRequest setHospitalCategory:category];
    [BBHospitalRequest setAddedHospitalName:name];
    [BBHospitalRequest setPostSetHospital:@"1"];
    
    HMCircleClass *hospitalObj = [[[HMCircleClass alloc]init]autorelease];
    hospitalObj.m_HospitalID = hospitalId;
    hospitalObj.circleId     = groupId;
    hospitalObj.circleTitle  = name;
    HMCircleTopicVC *vc = [[[HMCircleTopicVC alloc] init]autorelease];
    vc.m_CircleClass = hospitalObj;
    vc.hidesBottomBarWhenPushed = YES;
    vc.isSetHospitial = YES;
    [self.viewCtrl.navigationController pushViewController:vc animated:YES];
}

#pragma mark - actionEvent
- (IBAction)checkStrategyAction:(id)sender
{
    NSDictionary *topicData = [self.itemData dictionaryForKey:@"topic_data"];
    [BBStatistic visitType:BABYTREE_TYPE_TOPIC_HOSPITAL_INFO contentId:[topicData stringForKey:@"id"]];
    [HMShowPage showTopicDetail:self.viewController topicId:[topicData stringForKey:@"id"]  topicTitle:[topicData stringForKey:@"title"]];

}

- (void)setData:(NSDictionary *)data
{
    self.itemData = data;
    self.nameLabel.text = [data stringForKey:@"name"];
    self.postNumLabel.text = [data stringForKey:@"topic_count"];
    self.pregnanryNumLabel.text = [NSString stringWithFormat:@"%@",[data stringForKey:@"user_count"]];
    if ([[data stringForKey:@"strategy_id"] isEqualToString:@"0"])
    {
        [self.jianDangGongLueBtn setHidden:YES];
    }
    else
    {
        [self.jianDangGongLueBtn setHidden:NO];
    }
    self.exclusiveTouch = YES;
    self.jianDangGongLueBtn.exclusiveTouch = YES;
    self.button.exclusiveTouch = YES;
    self.myHospitalButton.exclusiveTouch = YES;
}

- (IBAction)buttonClicked:(id)sender
{
    HMCircleClass *circleObj  = [[[HMCircleClass alloc]init]autorelease];
    circleObj.m_HospitalID = [self.itemData stringForKey:@"id"];
    circleObj.circleId = [self.itemData stringForKey:@"group_id"];
    circleObj.circleTitle = [self.itemData stringForKey:@"name"];
    [HMShowPage showCircleTopic:self.viewCtrl circleClass:circleObj];

}

@end
