//
//  HMMyCircleList.m
//  BBHotMum
//
//  Created by songxf on 13-12-19.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMMyCircleList.h"
#import "BBConfigureAPI.h"
#import "BBSupportTopicDetail.h"
#import "HMShowPage.h"
#import "HMApiRequest.h"
#import "HMCircleTopicVC.h"
#import "BBSelectHospitalArea.h"

@interface HMMyCircleList ()
<
    BBLoginDelegate,
    UIActionSheetDelegate
>

@property (nonatomic, retain) UIView *m_BtnBackView;
@property (assign, nonatomic) LoginType s_LoginType;
@property (nonatomic,strong) HMMyCircleCell *s_TopMyCircle;
@property (nonatomic, strong) MBProgressHUD *s_AddCircleHUD;

@property (nonatomic,strong)HMMyCircleCell *theCell;
@property (nonatomic,strong)HMCircleClass *theCellClass;


@end

@implementation HMMyCircleList

@synthesize ContainerVC;

@synthesize m_UserID;

//@synthesize m_TipView;
@synthesize m_TipRequests;

//@synthesize m_BannerView;
@synthesize m_BannerRequests;

@synthesize m_TopRequests;

@synthesize theCell;
@synthesize theCellClass;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_TipRequests clearDelegatesAndCancel];

    [m_BannerRequests clearDelegatesAndCancel];
//    m_BannerView.delegate = nil;

    [m_TopRequests clearDelegatesAndCancel];
    [_m_PrizeRequest clearDelegatesAndCancel];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCircleJoinState:) name:DIDCHANGE_CIRCLE_JOIN_STATE object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    s_NeedBanner = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshData) name:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];

    if (self.m_UserID && ![self.m_UserID isEqualToString:[BBUser getEncId]])
    {
        self.navigationItem.title = @"她的圈";
        [self setNavBar:self.navigationItem.title bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
//        self.umeng_VCname = @"她的圈";
        s_IsMain = NO;
        s_IsMine = NO;
    }
    else if (self.m_UserID && [self.m_UserID isEqualToString:[BBUser getEncId]])
    {
        self.navigationItem.title = @"我的圈";
        [self setNavBar:self.navigationItem.title bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
//        self.umeng_VCname = @"我的圈";
        s_IsMain = NO;
        s_IsMine = YES;
        
        //我的圈列表更多按钮
//        [self createAddCricleBtn];
        
    }
    else
    {
        s_NeedBanner = NO;

        UIImage *image = [UIImage imageNamed:@"navigationbar_main_logo"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);

        [self setNavBarTitleView:imageView bgColor:nil  leftTitle:nil leftBtnImage:nil leftToucheEvent:nil rightTitle:nil rightBtnImage:@"navigationbar_addmorecircle_btn" rightToucheEvent:@selector(rightAction:)];

        self.m_Table.height = UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_TAB_BAR_HEIGHT;

        self.navigationItem.title = @"我的圈";
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
//        self.umeng_VCname = @"首页我的圈";
        s_IsMain = YES;
        s_IsMine = YES;
    }
    [self freshData];
    
    self.s_AddCircleHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.s_AddCircleHUD];
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick event:@"discuz_v2" label:@"我的圈页pv"];//tag2 for init opportunity
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [self checkBanner];
    
//    if (!s_IsMain && s_IsMine)
//    {
//        [HMShadeGuideControl controlForMainPage];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_TipRequests clearDelegatesAndCancel];
    self.m_TipRequests = nil;

//    [self closeTipView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AddCricleBtn 相关方法

- (void)createAddCricleBtn
{
    UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    UIButton *addCircleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addCircleBtn.exclusiveTouch = YES;
    addCircleBtn.frame = CGRectMake(35, 18, 250, 44);
    [addCircleBtn setImage:[UIImage imageNamed:@"navigationbar_addmorecircle_btn"] forState:UIControlStateNormal];
    [addCircleBtn setTitle:@"更多精彩圈子" forState:UIControlStateNormal];
    addCircleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [addCircleBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [addCircleBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateSelected];
    [addCircleBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    
    [addCircleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 35)];
    [addCircleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
    
    [addCircleBtn addTarget:self action:@selector(goMoreCircle) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBackView addSubview:addCircleBtn];
    
    self.m_BtnBackView = btnBackView;
}

- (void)goMoreCircle
{
    [HMShowPage showMoreCircle:self categoryId:nil];
}

#pragma mark -
#pragma mark navi envent

- (void)rightAction:(id)sender
{
    [MobClick event:@"discuz_v2" label:@"我的圈-添加图标点击"];
    NSString *lastClassID = [BBUser moreCircleCategory];
    [HMShowPage showMoreCircle:self categoryId:lastClassID];
}


#pragma mark -
#pragma mark Table Data Source Methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"HMMyCircleCell";

    HMMyCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMMyCircleCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        [cell makeCellStyle];
    }

    //数据模型
    HMCircleClass *item = [self.m_Data objectAtIndex:indexPath.row];
    cell.theCurrentIndexPath = indexPath;
    [cell setCellContent:item isMine:s_IsMine];
    
    if (indexPath.row ==0)
    {
        if (item.isDefaultJoined)
        {
            cell.m_ControlButton.hidden = YES;
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HMMYCIRCLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"discuz_v2" label:@"我的圈-圈子点击"];
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    HMCircleClass *class = [self.m_Data objectAtIndex:indexPath.row];
    
    UIViewController *pushVC = self.ContainerVC != nil ? self.ContainerVC : self;
    if (pushVC.navigationController == nil)
    {
        return;
    }

    if (class.isMyHospital)
    {
        if ([class.circleId isEqualToString:@"0"])
        {
            BBSelectHospitalArea *selectHospitalArea = [[BBSelectHospitalArea alloc] initWithNibName:@"BBSelectHospitalArea" bundle:nil];
            selectHospitalArea.hidesBottomBarWhenPushed = YES;
            [pushVC.navigationController pushViewController:selectHospitalArea animated:YES];
            return;
        }
    }

    [HMShowPage showCircleTopic:pushVC circleClass:class];
}


#pragma mark -
#pragma mark freshData Request

- (void)freshData
{
    [super freshData];

    [self loadNextData];
}

- (void)loadNextData
{
    [super loadNextData];

    if (s_CanLoadNextPage)
    {
        [self.m_DataRequest clearDelegatesAndCancel];

        self.m_DataRequest = [HMApiRequest myCircleListwithStart:s_BakLoadedPage WithUserID:self.m_UserID];
        [self.m_DataRequest setDelegate:self];
        [self.m_DataRequest setDidFinishSelector:@selector(loadDataFinished:)];
        [self.m_DataRequest setDidFailSelector:@selector(loadDataFail:)];
        [self.m_DataRequest startAsynchronous];

        [self.m_ProgressHUD show:YES showBackground:NO];
    }
    else
    {
        [self hideEGORefreshView];
    }
}

- (void)loadDataFinished:(ASIHTTPRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self hideEGORefreshView];

    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];

    if (![dictData isDictionaryAndNotEmpty])
    {
        if (self.m_Data.count == 0)
        {
            self.m_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.m_NoDataView.hidden = NO;
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }

        return ;
    }

    NSDictionary *dictList = [dictData dictionaryForKey:@"data"];

    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        s_LoadedTotalCount = [dictList intForKey:@"total_count"];
        s_EachLoadCount = [dictList intForKey:@"page_count"];

        NSArray *group_list = [dictList arrayForKey:@"group_list"];
        
        if (s_LoadedPage == 0)
        {
            [self.m_Data removeAllObjects];
        }
    
        if ([group_list isNotEmpty])
        {
            for (NSDictionary *clumn in [dictList arrayForKey:@"group_list"])
            {
                if (![clumn isDictionaryAndNotEmpty])
                {
                    continue;
                }
                HMCircleClass * item = [[HMCircleClass alloc]init];
                
                item.circleId = [clumn stringForKey:@"id"];
                // 去重操作
                BOOL isExisted = NO;
                NSArray *array = [self.m_Data lastArrayWithCount:DUPLICATE_COMPARECOUNT];
                for (HMCircleClass *item1 in array)
                {
                    if ([item.circleId isEqualToString:item1.circleId])
                    {
                        isExisted = YES;
                        break;
                    }
                }
                if (isExisted)
                {
                    continue;
                }
                item.circleImageUrl = [clumn stringForKey:@"img_src"];
                item.circleTitle = [clumn stringForKey:@"title"];
                item.memberNum = [clumn stringForKey:@"user_count"];
                item.todayTopicNum = [clumn stringForKey:@"new_topic_count" defaultString:@"0"];
                item.addStatus = [clumn boolForKey:@"is_joined"];
                item.isMyHospital = [clumn boolForKey:@"is_myhospital"];
                item.isDefaultJoined = [clumn boolForKey:@"is_default_joined"];
                if([[clumn stringForKey:@"has_mybirthclub"] isEqualToString:@"1"])
                {
                    item.isMyBirthClub = YES;
                }
                else
                {
                    item.isMyBirthClub = NO;
                }
                
                item.type = [clumn stringForKey:@"type"];
                if ([item.type isEqualToString:@"1"])
                {
                    item.m_HospitalID = [clumn stringForKey:@"hospital_id" defaultString:@""];
                }
                
                item.isMyCityCircle = [clumn boolForKey:@"is_mycity"];
                
                NSArray *topicListArray = [clumn arrayForKey:@"topic_list"];
                
                if ([item.todayTopicNum isEqualToString:@"0"])
                {
                    NSInteger todayTopicNum = arc4random() % 20 + 10;
                    item.todayTopicNum = [NSString stringWithFormat:@"%d",todayTopicNum];
                }
                
                if (topicListArray)
                {
                    //目前最多只需一条话题纪录。
                    if ([topicListArray count] == 1)
                    {
                        item.topicTitle01 = [[topicListArray objectAtIndex:0] stringForKey:@"title" defaultString:@""];
                        item.iconForTopicTitle01ImageType = [[topicListArray objectAtIndex:0] intForKey:@"is_pic"];
                        item.buttonImageUrl = [[topicListArray objectAtIndex:0] stringForKey:@"author_avatar"] ;
                    }
                    else if ([topicListArray count] == 2)
                    {
                        item.topicTitle01 = [[topicListArray objectAtIndex:0] stringForKey:@"title"defaultString:@""];
                        item.iconForTopicTitle01ImageType = [[topicListArray objectAtIndex:0] intForKey:@"is_pic"];
                        item.buttonImageUrl = [[topicListArray objectAtIndex:0] stringForKey:@"author_avatar"] ;
                        item.topicTitle02 = [[topicListArray objectAtIndex:1] stringForKey:@"title"defaultString:@""];
                        item.iconForTopicTitle02ImageType = [[topicListArray objectAtIndex:1] intForKey:@"is_pic"];
                    }
                }

                [self.m_Data addObject:item];
            }
            s_LoadedPage++;
        }
        else
        {
            _refresh_bottom_view.refreshStatus = YES;
        }
        
        if (!s_IsMain && s_IsMine)
        {
            if (self.m_Data.count != 0 && self.m_Data.count == [dictList intForKey:@"total_count"])
            {
                self.m_Table.tableFooterView = self.m_BtnBackView;
            }
            else
            {
                self.m_Table.tableFooterView = nil;
            }
        }

        if (self.m_Data.count == 0)
        {
            if (s_IsMine)
            {
                self.m_NoDataView.m_MessageType = HMNODATAMESSAGE_CIRCLE_NOCIRCLE;
                self.m_NoDataView.m_Type = HMNODATAVIEW_CIRCLE;
            }
            else
            {
                self.m_NoDataView.m_MessageType = HMNODATAMESSAGE_CIRCLE_OTHER;
                self.m_NoDataView.m_Type = HMNODATAVIEW_CIRCLE;
            }

            self.m_NoDataView.hidden = NO;
        }
        
        [self.m_Table reloadData];
    }
    else
    {
        if (self.m_Data.count == 0)
        {
            self.m_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
            self.m_NoDataView.hidden = NO;
        }
        else if ([self isVisible])
        {
            [PXAlertView showAlertWithTitle:@"数据下载错误, 请稍后再试！"];
        }
    }
}

- (void)loadDataFail:(ASIHTTPRequest *)request
{
    if (self.m_Data.count == 0)
    {
        self.m_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
        self.m_NoDataView.hidden = NO;
    }
    else if ([self isVisible])
    {
        [PXAlertView showAlertWithTitle:@"没有网络连接哦"];
    }

    [self.m_ProgressHUD hide:YES];
    [self hideEGORefreshView];
}

#pragma mark -
#pragma mark NSNotificationCenter - DIDCHANGE_CIRCLE_JOIN_STATE
- (void)changeCircleJoinState:(NSNotification *)notify
{
    if (self.m_UserID && ![self.m_UserID isEqualToString:[BBUser getEncId]])
    {
        return;
    }

    [self freshData];
}

#pragma mark -
#pragma mark HMMyCircleCellDelegate

-(void)myCircleCellControlAction:(HMMyCircleCell *)circleCell withClass:(HMCircleClass *)circleCellClass withIndexPath:(NSIndexPath *)theIndexPath
{
    self.theCell = circleCell;
    self.theCellClass = circleCellClass;
    
    NSString *titleStr = (![self.theCellClass.circleTitle isNotEmpty]) ? @"操作" : self.theCellClass.circleTitle;
    if ([BBUser isLogin] && !self.theCellClass.isDefaultJoined)
    {
        if (theIndexPath.row == 0)
        {
            UIActionSheet *controlActionSheet = [[UIActionSheet alloc] initWithTitle:titleStr delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出圈子", nil];
            controlActionSheet.tag = 3999;
            [controlActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
        else
        {
            UIActionSheet *controlActionSheet = [[UIActionSheet alloc] initWithTitle:titleStr delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"置顶圈子", @"退出圈子", nil];
            controlActionSheet.tag = 4000;
            [controlActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
    else
    {
        UIActionSheet *controlActionSheet = [[UIActionSheet alloc] initWithTitle:titleStr delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"置顶圈子", nil];
        controlActionSheet.tag = 4001;
        [controlActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}

- (void)myCircleCellDidSelected:(HMMyCircleCell *)circleCell
{
    NSIndexPath *cellIndexPath = [self.m_Table indexPathForCell:circleCell];
    [self tableView:self.m_Table didSelectRowAtIndexPath:cellIndexPath];
}

- (void)myCircleCellSetTop:(HMMyCircleCell *)circleCell
{
    self.s_TopMyCircle = circleCell;
    if([BBUser isLogin])
    {
        [self topMyCircle];
    }
    else
    {
        [self goToLoginWithLoginType:LoginDefault];
    }
}

-(void)topMyCircle
{
    [m_TopRequests clearDelegatesAndCancel];
    self.m_TopRequests = [HMApiRequest setCircleTop:self.s_TopMyCircle.m_CircleClass.circleId];
    [self.m_TopRequests setDelegate:self];
    [self.m_TopRequests setDidFinishSelector:@selector(setCircleTopFinished:)];
    [self.m_TopRequests setDidFailSelector:@selector(setCircleTopFail:)];
    [self.m_TopRequests startAsynchronous];
    [self.m_ProgressHUD show:YES showBackground:NO];
}

- (void)goToLoginWithLoginType:(LoginType)theLoginType
{
    UIViewController *pushVC = self.ContainerVC != nil ? self.ContainerVC : self;
    if (pushVC.navigationController == nil)
    {
        return;
    }
    BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
    login.m_LoginType = BBPresentLogin;
    BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
    [navCtrl setColorWithImageName:@"navigationBg"];
    self.s_LoginType = theLoginType;
    login.delegate = self;
    [pushVC.navigationController  presentViewController:navCtrl animated:YES completion:^{
        
    }];
    return ;
}

-(void)loginFinish
{
    [self topMyCircle];
}


#pragma mark -
#pragma mark setCircleTop Request

- (void)setCircleTopFinished:(ASIFormDataRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *data = [parser objectWithString:responseString];

    if (![data isDictionaryAndNotEmpty])
    {
        [self.s_AddCircleHUD show:NO withText:@"置顶失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }

    NSString *status = [data stringForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        [self.s_AddCircleHUD show:NO withText:@"置顶成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        NSInteger index = [self.m_Data indexOfObject:self.s_TopMyCircle.m_CircleClass];
        
        if (index == NSNotFound)
        {
            return;
        }
        
        [self.m_Data moveObjectToTop:index];
        
        [self.m_Table reloadData];
    }
    
}

- (void)setCircleTopFail:(ASIFormDataRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self.s_AddCircleHUD show:NO withText:@"置顶失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}


#pragma mark - HMNoDataViewDelegate

-(void)freshFromNoDataView
{
    if (self.m_NoDataView.m_Type == HMNODATAVIEW_CIRCLE)
    {
        [HMShowPage showMoreCircle:self categoryId:nil];
    }
    else
    {
        [self freshData];
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 3999)
    {
        if (buttonIndex == 0)
        {
            [MobClick event:@"discuz_v2" label:@"我的圈- 退出点击"];
            [self quitCircleReloadData];
        }
    }
    else if (actionSheet.tag == 4000)
    {
        if (buttonIndex == 0)
        {
            [MobClick event:@"discuz_v2" label:@"我的圈- 置顶点击"];
            [self myCircleCellSetTop:theCell];
        }
        else if (buttonIndex == 1)
        {
            [MobClick event:@"discuz_v2" label:@"我的圈- 退出点击"];
            [self quitCircleReloadData];
        }
    }
    else if(actionSheet.tag == 4001)
    {
        if (buttonIndex == 0)
        {
            [MobClick event:@"discuz_v2" label:@"我的圈- 置顶点击"];
            [self myCircleCellSetTop:theCell];
        }
    }
}

#pragma mark - QuitCircle request

- (void)quitCircleReloadData
{
    if (self.m_DataRequest != nil)
    {
        [self.m_DataRequest clearDelegatesAndCancel];
    }
    
    self.m_DataRequest = [HMApiRequest quitTheCircleWithGroupID:self.theCellClass.circleId];
    [self.m_DataRequest setDelegate:self];
    [self.m_DataRequest setDidFinishSelector:@selector(quitCircleReloadDataFinished:)];
    [self.m_DataRequest setDidFailSelector:@selector(quitCircleReloadDataFail:)];
    [self.m_DataRequest startAsynchronous];
    
    [self.s_AddCircleHUD show:YES showBackground:NO];
}

- (void)quitCircleReloadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];
    
    if (![dictData isDictionaryAndNotEmpty])
    {
        [self.s_AddCircleHUD show:YES withText:@"退出失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        return;
    }
    
    NSString *status = [dictData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        [self.s_AddCircleHUD show:YES withText:@"退出成功" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        
        NSDictionary * dictList = [dictData dictionaryForKey:@"data"];
        if ([dictList isNotEmpty])
        {
            if ([[dictList stringForKey:@"group_id"] isEqualToString:self.theCellClass.circleId])
            {
                [self.m_Data removeObject:theCellClass];
                [self.m_Table reloadData];
            }
        }
    }
    else if ([status isEqualToString:@"owner_cannot_quit"])
    {
        [self.s_AddCircleHUD show:YES withText:@"您不能退出自己管理的圈子哦" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    else
    {
        [self.s_AddCircleHUD show:YES withText:@"退出失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
    }
    
    return;
}

- (void)quitCircleReloadDataFail:(ASIHTTPRequest *)request
{
    [self.s_AddCircleHUD show:YES withText:@"退出失败, 请稍后再试" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
}

@end
