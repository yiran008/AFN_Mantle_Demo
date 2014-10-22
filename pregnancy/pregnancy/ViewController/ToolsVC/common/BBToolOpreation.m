//
//  BBToolsKit.m
//  pregnancy
//
//  Created by liumiao on 7/27/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBToolOpreation.h"
#import "BBUser.h"
#import "BBLogin.h"

#import "BBKnowledgeFirstLevelVC.h"
#import "BBRecordMainPage.h"
#import "BBTaxiMainPage.h"
#import "BBMusicTypeListController.h"
#import "BBSupportTopicDetail.h"
#import "BBVaccineVC.h"

#define USER_TOOL_PAGE_ACTION_DATA (@"userToolPageActionData")
#define USER_MAIN_PAGE_TOOL_DATA (@"userMainPageToolData")
#define TOOL_PAGE_TOOL_STATE (@"toolPageToolState")
//孕期热线 0，专家在线 0，孕期食谱 1，知识库 2，心情记录 3，快乐打车 4，胎教音乐 5，孕育问答 6，Baby Box 7，孕期手表 8,扫一扫 9, 疫苗时间表 10
#define TOOL_TYPE_WEB @"0"
#define TOOL_TYPE_RECIPE @"1"
#define TOOL_TYPE_KNOWLEDGE @"2"
#define TOOL_TYPE_MOOD @"3"
#define TOOL_TYPE_TAXI @"4"
#define TOOL_TYPE_MUSIC @"5"
#define TOOL_TYPE_QA @"6"
#define TOOL_TYPE_BOX @"7"
#define TOOL_TYPE_WATCH @"8"
#define TOOL_TYPE_SCAN @"9"
#define TOOL_TYPE_VACCINE @"10"

@interface BBToolOpreation ()
<
    BBLoginDelegate
>

@property (nonatomic,weak)id<BBToolOpreationDelegate> toolActionTarget;
@property (nonatomic,strong)BBToolModel *toolActionModel;

@end

@implementation BBToolOpreation

+ (NSDictionary *)getToolActionDataOfType:(ToolPageType)type
{
    NSDictionary *localActionDataDict = nil;
    BOOL fromPlist= NO;
    if (type == ToolPageTypeMain)
    {
        localActionDataDict = [[NSUserDefaults standardUserDefaults]dictionaryForKey:USER_MAIN_PAGE_TOOL_DATA];
    }
    else if(type == ToolPageTypeTool)
    {
        localActionDataDict = [[NSUserDefaults standardUserDefaults]dictionaryForKey:USER_TOOL_PAGE_ACTION_DATA];
    }
    if (localActionDataDict == nil || [localActionDataDict count]== 0 || [[localActionDataDict arrayForKey:@"tool_list"]count]==0)
    {
        if (type == ToolPageTypeMain)
        {
            fromPlist = YES;
            localActionDataDict = [self getToolList:@"main_default"];
        }
        else if(type == ToolPageTypeTool)
        {
            fromPlist = YES;
            localActionDataDict = [self getToolList:@"tools_default"];
        }
        if ([localActionDataDict isDictionaryAndNotEmpty])
        {
            [self setToolActionData:localActionDataDict ofType:type];
        }
    }
    if ([localActionDataDict isDictionaryAndNotEmpty])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:localActionDataDict];
        [dict setBool:fromPlist forKey:@"from_plist"];
        return dict;
    }
    return nil;
}

+(NSDictionary*)getToolList:(NSString*)listName;
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:listName ofType:@"plist"];
    if (plistPath)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        return data;
    }
    return nil;
}

+ (void)setToolActionData:(NSDictionary *)actionData ofType:(ToolPageType)type
{
    if (type == ToolPageTypeMain)
    {
        [[NSUserDefaults standardUserDefaults]safeSetContainer:actionData forKey:USER_MAIN_PAGE_TOOL_DATA];
    }
    else if(type == ToolPageTypeTool)
    {
        [[NSUserDefaults standardUserDefaults]safeSetContainer:actionData forKey:USER_TOOL_PAGE_ACTION_DATA];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)clearToolActionDataOfType:(ToolPageType)type
{
    NSDictionary *data = [self getToolActionDataOfType:type];
    if([data isDictionaryAndNotEmpty])
    {
        NSMutableDictionary *newData = [[NSMutableDictionary alloc]initWithDictionary:data];
        NSArray *list = [newData arrayForKey:@"tool_list"];
        if ([list isNotEmpty])
        {
            NSMutableArray *newList = [[NSMutableArray alloc]init];
            for (NSDictionary *aTool in list)
            {
                NSMutableDictionary *newTool = [[NSMutableDictionary alloc]initWithDictionary:aTool];
                [newTool setString:@"0" forKey:@"badge_count"];
                [newList addObject:newTool];
            }
            [newData setObject:newList forKey:@"tool_list"];
            [self setToolActionData:newData ofType:type];
        }
    }
}

//返回YES表示有新工具，返回NO表示没有新工具
+ (BOOL)compareOldTools:(NSArray *)oldList withNewTools:(NSArray*)newList
{
    BOOL hasNewTool = NO;
    NSMutableSet *oldToolsNameSet = [[NSMutableSet alloc]init];
    for (id aTool in oldList)
    {
        if ([aTool isKindOfClass:[NSDictionary class]])
        {
            [oldToolsNameSet addObject:[(NSDictionary*)aTool stringForKey:@""]];
        }
        else if([aTool isMemberOfClass:[BBToolModel class]])
        {
            [oldToolsNameSet addObject:((BBToolModel*)aTool).name];
        }
    }
    for (id aTool in newList)
    {
        NSString *name = nil;
        if ([aTool isKindOfClass:[NSDictionary class]])
        {
            name = [(NSDictionary*)aTool stringForKey:@"name"];
        }
        else if([aTool isMemberOfClass:[BBToolModel class]])
        {
            name = ((BBToolModel*)aTool).name;
        }
        if (![oldToolsNameSet containsObject:name])
        {
            [self setToolsState:YES forTool:name];
            hasNewTool = YES;
        }
    }
    return hasNewTool;
}

+ (void)setToolsState:(BOOL)state forTool:(NSString*)toolName
{
    NSDictionary *defaultDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:TOOL_PAGE_TOOL_STATE];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if (defaultDict)
    {
        [dict addEntriesFromDictionary:defaultDict];
    }
    [dict setBool:state forKey:toolName];
    [[NSUserDefaults standardUserDefaults]safeSetContainer:dict forKey:TOOL_PAGE_TOOL_STATE];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSDictionary*)toolsState
{
    return [[NSUserDefaults standardUserDefaults]dictionaryForKey:TOOL_PAGE_TOOL_STATE];
}

+ (NSArray *)getCurrentVersionSupportedToolsArray:(NSArray*)originArray
{
    NSSet *supportedTypesSet = [self currentSupportedToolsTypeSet];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (id item in originArray)
    {
        NSString *type = nil;
        BOOL isAlreadyModel = NO;
        if ([item isKindOfClass:[NSDictionary class]])
        {
            type = [(NSDictionary*)item stringForKey:@"type"];
        }
        else if([item isMemberOfClass:[BBToolModel class]])
        {
            isAlreadyModel = YES;
            type = ((BBToolModel*)item).type;
        }
        if ([supportedTypesSet containsObject:type])
        {
            if (isAlreadyModel)
            {
                [resultArray addObject:item];
            }
            else
            {
                [resultArray addObject:[self modelFromDict:item]];
            }
        }
    }
    return resultArray;
}

+ (NSSet*)currentSupportedToolsTypeSet
{
    NSSet* supportedTypesSet = [[NSSet alloc]initWithObjects:TOOL_TYPE_WEB,TOOL_TYPE_RECIPE,TOOL_TYPE_KNOWLEDGE,TOOL_TYPE_MOOD,TOOL_TYPE_TAXI,TOOL_TYPE_MUSIC,TOOL_TYPE_QA,TOOL_TYPE_BOX,TOOL_TYPE_WATCH,TOOL_TYPE_SCAN,TOOL_TYPE_VACCINE, nil];
    return supportedTypesSet;
}

+ (BBToolModel*)modelFromDict:(NSDictionary*)dict
{
    BBToolModel *model = [[BBToolModel alloc]init];
    model.name = [dict stringForKey:@"name"];
    model.img = [dict stringForKey:@"img"];
    model.type =[dict stringForKey:@"type"];
    model.badgeCount = [dict stringForKey:@"badge_count"];
    model.url = [dict stringForKey:@"url"];
    model.holderImg = [self getHolderImageForItem:dict];
    model.toolKind = [dict stringForKey:@"tool_type_name"];
    return model;
}

+(NSString*)getHolderImageForItem:(NSDictionary*)item
{
    NSString *type = [item objectForKey:@"type"];
    NSString *holderImageName = nil;
    if ([type isEqualToString:TOOL_TYPE_WEB])
    {
        NSString *url = [item objectForKey:@"url"];
        
        if ([url rangeOfString:@"expert_online.php"].location != NSNotFound)
        {
            //expert_online.php 专家在线
            holderImageName = @"tool_doctor_icon";
        }
        else if ([url rangeOfString:@"wlywgq"].location != NSNotFound)
        {
            //wlywgq 孕期热线
            holderImageName = @"tool_phone_icon";
        }
        else if ([url rangeOfString:@"mobile_toolcms/yuezicang"].location != NSNotFound)
        {
            //月子餐
            holderImageName = @"tool_yuezican_icon";
        }
        else if ([url rangeOfString:@"mobile_toolcms/can_eat"].location != NSNotFound)
        {
            //能不能吃
            holderImageName = @"tool_chi_icon";
        }
        else if ([url rangeOfString:@"mobile_toolcms/fusi"].location != NSNotFound)
        {
            //宝宝辅食
            holderImageName = @"tool_bbfushi_icon";
        }
        else if ([url rangeOfString:@"mobile_toolcms/bchao"].location != NSNotFound)
        {
            //B超单
            holderImageName = @"tool_bchao_icon";
        }
        else if ([url rangeOfString:@"2014jbopenclass"].location != NSNotFound)
        {
            //成长宝典
            holderImageName = @"tool_baodian_icon";
        }
        else if ([url rangeOfString:@"tfldwu"].location != NSNotFound)
        {
            //好运小天使
            holderImageName = @"tool_tianshi_icon";
        }
    }
    else if([type isEqualToString:TOOL_TYPE_RECIPE])
    {
        //孕期食谱列表
        holderImageName = @"tool_food_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_KNOWLEDGE])
    {
        //知识库列表
        holderImageName = @"tool_knowledge_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_MOOD])
    {
        //心情记录
        holderImageName = @"tool_xinqingjilu_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_TAXI])
    {
        //打车
        holderImageName = @"tool_dache_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_MUSIC])
    {
        //胎教音乐
        holderImageName = @"tool_music_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_QA])
    {
        //孕育问答
        holderImageName = @"tool_ask_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_BOX])
    {
        //Baby Box
        holderImageName = @"tool_babybox_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_WATCH])
    {
        //孕期手表
        holderImageName = @"tool_watch_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_SCAN])
    {
        //孕期手表
        holderImageName = @"tool_scan_icon";
    }
    else if([type isEqualToString:TOOL_TYPE_VACCINE])
    {
        //疫苗时间表
        holderImageName = @"tool_yimiao_icon";
    }
    return holderImageName;
    
}

- (void)performActionOfTool:(BBToolModel*)tool target:(id<BBToolOpreationDelegate>)target
{
    if (![tool isNotEmpty] || target == nil)
    {
        return;
    }
    //孕期热线 0，专家在线 0，孕期食谱 1，知识库 2，心情记录 3，快乐打车 4，胎教音乐 5，孕育问答 6，Baby Box 7，孕期手表 8
    self.toolActionTarget = target;
    self.toolActionModel = tool;
    
    UIViewController *vc = (UIViewController*)target;
    
    if ([tool.type isEqualToString:TOOL_TYPE_WEB])
    {
        if ([tool.url rangeOfString:@"expert_online.php"].location != NSNotFound)
        {
            [self mobclickLabel:@"工具-专家在线"];
        }
        else if ([tool.url rangeOfString:@"wlywgq"].location != NSNotFound)
        {
            [self mobclickLabel:@"工具-孕期热线"];
        }
        else
        {
            if ([tool.name isNotEmpty])
            {
                [MobClick event:@"tool_v2" label:tool.name];
            }
        }
        [self gotoUrl:tool.url];
    }
    else if([tool.type isEqualToString:TOOL_TYPE_RECIPE])
    {
        //孕期食谱列表
        [MobClick event:@"tool_v2" label:@"孕期食谱"];
        [self gotoUrl:@"http://m.haodou.com/app/recipe/act/kuaileyunqi.php&&title=孕期食谱"];
    }
    else if([tool.type isEqualToString:TOOL_TYPE_KNOWLEDGE])
    {
        //知识库列表
        [self mobclickLabel:@"工具-知识库"];
        BBKnowledgeFirstLevelVC *knowledgeFirstLevelVC = [[BBKnowledgeFirstLevelVC alloc]init];
        knowledgeFirstLevelVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:knowledgeFirstLevelVC animated:YES];
    }
    else if([tool.type isEqualToString:TOOL_TYPE_MOOD])
    {
        [MobClick event:@"tool_v2" label:@"心情记录"];
        if ([BBUser isLogin]) {
            BBRecordMainPage *recordMainPage = [[BBRecordMainPage alloc] initWithNibName:@"BBRecordMainPage" bundle:nil];
            recordMainPage.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:recordMainPage animated:YES];
        }else{
            [self presentLoginWithLoginType:LoginRecordMainPage];
        }
        return;    }
    else if([tool.type isEqualToString:TOOL_TYPE_TAXI])
    {
        [MobClick event:@"tool_v2" label:@"快乐打车"];
        if ([BBUser isLogin]) {
            BBTaxiMainPage *taxiMainPage = [[BBTaxiMainPage alloc] initWithNibName:@"BBTaxiMainPage" bundle:nil];
            taxiMainPage.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:taxiMainPage animated:YES];
        }else{
            [self presentLoginWithLoginType:LoginKuaiDi];
        }
        return;
    }
    else if([tool.type isEqualToString:TOOL_TYPE_MUSIC])
    {
        
        [MobClick event:@"tool_v2" label:@"胎教音乐"];
        if ([BBUser isLogin]) {
            BBMusicTypeListController *musicList = [[BBMusicTypeListController alloc] init];
            musicList.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:musicList animated:YES];
        }else{
            [self presentLoginWithLoginType:LoginMusic];
        }
        return;
    }
    else if([tool.type isEqualToString:TOOL_TYPE_QA])
    {
        [self mobclickLabel:@"工具-孕育问答"];
        //孕育问答
        //暂时为医院圈入口
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        exteriorURL.isShowCloseButton = NO;
        [exteriorURL setLoadURL:[NSString stringWithFormat:@"%@/app/ask/index.php",BABYTREE_URL_SERVER]];
        exteriorURL.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:exteriorURL animated:YES];
        return;
    }
    else if([tool.type isEqualToString:TOOL_TYPE_BOX])
    {
        //Baby Box
        [MobClick event:@"tool_v2" label:@"免费试用"];
        if ([BBUser isLogin])
        {
            [self openSupportTopicURL:@"http://m.babytree.com/babybox/index_new.php?show=app" title:@"免费试用"];
        }else
        {
            [self presentLoginWithLoginType:LoginBabyBox];
        }
    }
    else if([tool.type isEqualToString:TOOL_TYPE_WATCH])
    {
        [MobClick event:@"tool_v2" label:@"孕期手表"];
        //孕期手表http://www.babytree.com/watch/mpay.php&&setTitle:==孕期手表 B-smart
        if ([BBUser isLogin]&&[BBUser smartWatchCode] != nil)
        {
            BBSmartMainPage *smartMainPage = [[BBSmartMainPage alloc]initWithNibName:@"BBSmartMainPage" bundle:nil];
            smartMainPage.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:smartMainPage animated:YES];
        }
        else
        {
            [self openSupportTopicURL:@"http://www.babytree.com/watch/mpay.php" title:@"孕期手表 B-smart"];
        }
    }
    else if([tool.type isEqualToString:TOOL_TYPE_SCAN])
    {
        //扫一扫
        [MobClick event:@"tool_v2" label:@"扫一扫"];
        ZXSanQR *scan = [[ZXSanQR alloc] init];
        scan.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:scan animated:YES];
    }
    else if([tool.type isEqualToString:TOOL_TYPE_VACCINE])
    {
        //疫苗时间表
        [MobClick event:@"tool_v2" label:@"疫苗时间表点击次数"];
        BBVaccineVC *vaVC = [[BBVaccineVC alloc]init];
        vaVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:vaVC animated:YES];
    }

}
#pragma mark- 工具点击事件
-(void)mobclickLabel:(NSString*)label
{
    if ([BBUser getNewUserRoleState]==BBUserRoleStatePrepare)
    {
        [MobClick event:@"home_prepare_v2" label:label];
    }
    else if ([BBUser getNewUserRoleState]==BBUserRoleStatePregnant)
    {
        [MobClick event:@"home_pregnant_v2" label:label];
    }
    else
    {
        [MobClick event:@"home_baby_v2" label:label];
    }
}
-(void)gotoUrl:(NSString*)url
{
    if(![url isNotEmpty])
    {
        return;
    }
    NSArray *dataArray = [url componentsSeparatedByString:@"&&"];
    NSString *realUrl = [dataArray objectAtIndex:0];
    NSString *realTitle = @"";
    for (int i =1;i< [dataArray count];i++)
    {
        NSString *param = [dataArray objectAtIndex:i];
        NSArray *titleArray = [param componentsSeparatedByString:@"="];
        if ([titleArray count]>1) {
            if ([[titleArray objectAtIndex:0]isEqualToString:@"title"])
            {
                realTitle = [titleArray objectAtIndex:1];
                break;
            }
        }
    }
    realUrl = [realUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    realTitle = [realTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self openSupportTopicURL:realUrl title:realTitle];
}

-(void)openSupportTopicURL:(NSString*)url title:(NSString*)title
{
    if (self.toolActionTarget)
    {
        UIViewController *vc = (UIViewController*)self.toolActionTarget;
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        exteriorURL.isShowCloseButton = NO;
        [exteriorURL setLoadURL:url];
        [exteriorURL setTitle:title];
        exteriorURL.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:exteriorURL animated:YES];
    }
}

#pragma mark- 登录及登录成功返回

-(void)presentLoginWithLoginType:(LoginType)type
{
    if (self.toolActionTarget)
    {
        UIViewController *vc = (UIViewController *)self.toolActionTarget;
        BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
        [navCtrl setColorWithImageName:@"navigationBg"];
        login.delegate = self;
        [vc.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];
    }
}
#pragma mark - BBLogin Finish Delegate

- (void)loginFinish
{
    if ([self.toolActionModel isNotEmpty] && self.toolActionTarget)
    {
        [self performActionOfTool:self.toolActionModel target:self.toolActionTarget];
    }
}

@end
