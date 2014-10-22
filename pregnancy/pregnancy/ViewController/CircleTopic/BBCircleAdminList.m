//
//  BBCircleAdminList.m
//  pregnancy
//
//  Created by whl on 14-8-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBCircleAdminList.h"
#import "BBCircleAdminClass.h"
#import "BBMessageChat.h"
#import "HMApiRequest.h"
#import "HMNoDataView.h"
#import "HMShowPage.h"

static NSString *reuseIdentifier = @"BBAdminCell";


@interface BBCircleAdminList ()
<
    HMNoDataViewDelegate
>

@property (nonatomic, strong) NSMutableArray *s_AdminArray;
@property (nonatomic, strong) MBProgressHUD  *s_MBProgress;
@property (nonatomic, strong) ASIHTTPRequest *s_RequestData;
@property (nonatomic, strong) BBCircleAdminClass *s_AdminObj;

@property (nonatomic, retain) HMNoDataView *m_NoDataView;

@end

@implementation BBCircleAdminList

- (void)dealloc
{
    [_s_RequestData clearDelegatesAndCancel];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar:@"管理员" bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
    
    UINib *nib = [UINib nibWithNibName: NSStringFromClass([BBAdminCell class]) bundle:[NSBundle mainBundle]];
    [self.m_AdminTable registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.m_AdminTable.backgroundColor = [UIColor clearColor];
    
    self.s_MBProgress = [[MBProgressHUD alloc]init];
    [self.view addSubview:self.s_MBProgress];
    
    self.s_AdminArray = [[NSMutableArray alloc]init];
    
    [self addNoDataView];
    
    [self getCircleAdminData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNoDataView
{
    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.m_AdminTable addSubview:self.m_NoDataView];
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.delegate = self;
    self.m_NoDataView.hidden = YES;
}

-(void)checkShowNoDataView
{
    if ([self.s_AdminArray count] > 0)
    {
        self.m_NoDataView.hidden = YES;
    }
    else
    {
        self.m_NoDataView.hidden = NO;
    }
}

#pragma mark - HMNoDataViewDelegate

-(void)freshFromNoDataView
{
    [self getCircleAdminData];
}

#pragma mark - ASIHTTPRequest method and delegate

-(void)getCircleAdminData
{
    [self checkShowNoDataView];
    [self.s_MBProgress show:YES];
    [self.s_RequestData clearDelegatesAndCancel];
    self.s_RequestData = [HMApiRequest setCircleAdminList:self.m_CircleID];
    [self.s_RequestData setDidFinishSelector:@selector(circleAdminDataRequestFinish:)];
    [self.s_RequestData setDidFailSelector:@selector(circleAdminDataRequestFail:)];
    [self.s_RequestData setDelegate:self];
    [self.s_RequestData startAsynchronous];
}

- (void)circleAdminDataRequestFinish:(ASIFormDataRequest *)request
{
    [self.s_MBProgress hide:YES];
    NSString *responseString = [request responseString];
    NSDictionary *userInfoData = [responseString objectFromJSONString];
    if (![userInfoData isDictionaryAndNotEmpty])
    {
        self.m_NoDataView.m_Type = HMNODATAVIEW_DATAERROR;
        if ([self isValided] && self.m_NoDataView.hidden)
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
        return;
    }
    
    NSString *status = [userInfoData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"1"])
    {
        NSArray *detailList = [[userInfoData dictionaryForKey:@"data"] arrayForKey:@"list"];
        
        if ([detailList isNotEmpty])
        {
            if (!self.s_AdminArray)
            {
                self.s_AdminArray = [[NSMutableArray alloc]init];
            }
            
            for (NSDictionary *dic in detailList)
            {
                BBCircleAdminClass *adminObj = [[BBCircleAdminClass alloc]init];
                adminObj.m_UserEncodeID  = [dic stringForKey:@"author_enc_user_id"];
                adminObj.m_UserName      = [dic stringForKey:@"author_name"];
                adminObj.m_UserAdress    = [dic stringForKey:@"city_name"];
                adminObj.m_UserPregnancy = [dic stringForKey:@"babyage"];
                adminObj.m_UserAvatar    = [dic stringForKey:@"author_avatar"];
                adminObj.m_UserRank      = [dic stringForKey:@"level_num"];
                
                [self.s_AdminArray addObject:adminObj];
            }
            [self.m_AdminTable reloadData];
        }
    }
    [self checkShowNoDataView];
    self.m_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
    
}

- (void)circleAdminDataRequestFail:(ASIFormDataRequest *)request
{
    [self.s_MBProgress hide:YES];
    [self checkShowNoDataView];
    self.m_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
    if ([self isValided] && self.m_NoDataView.hidden)
    {
        [PXAlertView showAlertWithTitle:@"亲，您的网络不给力啊"];
    }
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.s_AdminArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBAdminCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row < [self.s_AdminArray count])
    {
        BBCircleAdminClass *adminObj = [self.s_AdminArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        [cell setCollectionCellData:adminObj];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.s_AdminArray count])
    {
        BBCircleAdminClass *adminObj = [self.s_AdminArray objectAtIndex:indexPath.row];
        [HMShowPage showPersonalCenter:self userEncodeId:adminObj.m_UserEncodeID vcTitle:adminObj.m_UserName];
    }
}

#pragma mark - BBAdminCellDelegate

-(void)clickedSendMessage:(BBCircleAdminClass*)adminObj
{
    [MobClick event:@"discuz_v2" label:@"管理员-私信点击"];
    self.s_AdminObj = adminObj;
    if([BBUser isLogin])
    {
        [self pushSendMessageView];
    }
    else
    {
        BBLogin *login = [[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil];
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[BBCustomNavigationController alloc]initWithRootViewController:login];
        [navCtrl setColorWithImageName:@"navigationBg"];
        login.delegate = self;
        [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];
    }

}


-(void)pushSendMessageView
{
    BBMessageChat *messageChat = [[BBMessageChat alloc]initWithNibName:@"BBMessageChat" bundle:nil];
    messageChat.title= self.s_AdminObj.m_UserName;
    messageChat.userEncodeId = self.s_AdminObj.m_UserEncodeID;
    [self.navigationController pushViewController:messageChat animated:YES];
}

#pragma --mark login delegate

- (void)loginFinish
{
    [self pushSendMessageView];
}


@end
