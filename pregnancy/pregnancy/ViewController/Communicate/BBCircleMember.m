//
//  BBCircleMember.m
//  pregnancy
//
//  Created by whl on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBCircleMember.h"
#import "BBCustemSegment.h"
#import "BBUser.h"
#import "BBCircleMemberCell.h"
#import "ASIHTTPRequest.h"
#import "BBTopListMemberCell.h"
#import "HMApiRequest.h"
#import "HMShowPage.h"
#import "BBSupportTopicDetail.h"


static NSString *topIdentifer = @"BBTopMemberCell";
static NSString *reuseIdentifier = @"BBCircleMemberCell";
static NSString *topListIdentifer = @"BBTopListMemberCell";

@interface BBCircleMember ()
<
    HMNoDataViewDelegate
>

@property(nonatomic,strong) MBProgressHUD *s_MBProgress;

@property(nonatomic,strong) NSMutableArray *s_TopArray;

@property(nonatomic,strong) NSMutableArray *s_DisArray;

@property(nonatomic,strong) NSMutableArray *s_AgeArray;

@property(nonatomic,strong) ASIHTTPRequest *s_Request;

@property(nonatomic,strong) HMNoDataView *m_NoDataView;

@property(nonatomic,strong) BBCustemSegment *segmented;

@property(nonatomic,strong) BBMemberClass  *s_MyTopObj;

@end

@implementation BBCircleMember

- (void)dealloc
{
    [_s_Request clearDelegatesAndCancel];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.m_IsBirthdayClub = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar:@"圈成员" bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
    
    self.m_CircleMembertype = BBTopMember;
    self.s_TopArray = [[NSMutableArray alloc]init];
    self.s_DisArray = [[NSMutableArray alloc]init];
    self.s_AgeArray = [[NSMutableArray alloc]init];
    
    [self addCustemSegment];
    
    UINib *nib = [UINib nibWithNibName: NSStringFromClass([BBCircleMemberCell class]) bundle:[NSBundle mainBundle]];
    [self.m_CollectionTable registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    UINib *topnib = [UINib nibWithNibName: NSStringFromClass([BBTopListMemberCell class]) bundle:[NSBundle mainBundle]];
    [self.m_CollectionTable registerNib:topnib forCellWithReuseIdentifier:topListIdentifer];
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([BBTopMemberCell class])  bundle:[NSBundle mainBundle]];
    [self.m_CollectionTable registerNib:headerNib  forSupplementaryViewOfKind :UICollectionElementKindSectionHeader  withReuseIdentifier:topIdentifer];
    self.m_CollectionTable.backgroundColor = [UIColor clearColor];
    
    [self addRefreshStatus];
    [self addNoDataView];
    self.s_MBProgress = [[MBProgressHUD alloc]init];
    [self.view addSubview:self.s_MBProgress];
    
    [self getMemberListData];
}

-(void)addCustemSegment
{
    __weak __typeof (self) weakself = self;
    
    
    NSArray *items = @[@{@"text":@"圈排行"}, @{@"text":@"距离近"}];

    
    if (self.m_IsBirthdayClub)
    {
        if([BBUser getNewUserRoleState] != BBUserRoleStatePrepare)
        {
            items = @[@{@"text":@"圈排行"}, @{@"text":@"距离近"},@{@"text":@"同生日"}];
        }
    }
    else
    {
        NSString *str = @"同孕龄";
        if ([BBUser getNewUserRoleState] == BBUserRoleStatePrepare)
        {
            str = @"备孕姐妹";
        }
        else if([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
        {
            str = @"同宝龄";
        }
        
        items = @[@{@"text":@"圈排行"}, @{@"text":@"距离近"},@{@"text":str}];
    }
    
    _segmented = [[BBCustemSegment alloc] initWithFrame:CGRectMake(10, 10, 300, 26)
                                                                  items:items
                                                      andSelectionBlock:^(NSUInteger segmentIndex) {
                                                          __strong __typeof (weakself) strongself = weakself;
                                                          if (strongself)
                                                          {
                                                              if (strongself.m_CircleMembertype == segmentIndex)
                                                              {
                                                                  return;
                                                              }
                                                              [self.m_CollectionTable reloadData];
                                                              
                                                              [strongself.segmented setNoDataViewStatusInfoWithArrayIndex:strongself.m_CircleMembertype withNoDataType:strongself.m_NoDataView.m_Type withHidden:strongself.m_NoDataView.hidden withText:strongself.m_NoDataView.m_PromptText];
                                                              
                                                              if (segmentIndex == 0)
                                                              {
                                                                  strongself.m_CircleMembertype = BBTopMember;
                                                                  if ([self.s_TopArray count]>0)
                                                                  {
                                                                      [strongself reloadCollectionTable];

                                                                  }
                                                                  else
                                                                  {
                                                                      [strongself getMemberListData];
                                                                  }
                                                              }
                                                              else if (segmentIndex == 1)
                                                              {
                                                                  strongself.m_CircleMembertype = BBDistancemember;
                                                                  if (![strongself isGetUserDistanceInfomation])
                                                                  {
                                                                      [strongself reloadCollectionTable];
                                                                      self.m_NoDataView.hidden = YES;
                                                                      return;
                                                                  }
                                                                  
                                                                  if ([self.s_DisArray count]>0)
                                                                  {
                                                                      [strongself reloadCollectionTable];
                                                                  }
                                                                  else
                                                                  {
                                                                      [strongself getMemberListData];
                                                                  }

                                                              }
                                                              else if (segmentIndex == 2)
                                                              {
                                                                  strongself.m_CircleMembertype = BBAgeMember;
                                                                  if ([self.s_AgeArray count]>0)
                                                                  {
                                                                      [strongself reloadCollectionTable];
                                                                  }
                                                                  else
                                                                  {
                                                                      [strongself getMemberListData];
                                                                  }
                                                              }
                                                              
                                                              NSDictionary *noDataStatusDic = [strongself.segmented getNoDataStatusWithIndex:segmentIndex];
                                                              strongself.m_NoDataView.m_Type = (HMNODATAVIEW_TYPE)noDataStatusDic[@"noDataViewType"];
                                                              strongself.m_NoDataView.hidden = [noDataStatusDic[@"noDataViewHidden"] boolValue];
                                                              strongself.m_NoDataView.m_PromptText = noDataStatusDic[@"noDataViewText"];

                                                          }
                                                      }];
    _segmented.color = [UIColor whiteColor];
    _segmented.borderWidth = 1.f;
    _segmented.borderColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    _segmented.selectedColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    _segmented.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1]};
    _segmented.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIImage *tempImage=  [UIImage imageNamed:@"head_tab_bg"];
    self.m_TopView.image = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 3)];
    [self.view addSubview:_segmented];

}

-(void)addRefreshStatus
{
    if (_refresh_header_view == nil)
    {
        HMRefreshTableHeaderView *refreshHeaderView = [[HMRefreshTableHeaderView alloc] init];
        refreshHeaderView.delegate = self;
        [self.m_CollectionTable addSubview:refreshHeaderView];
        _refresh_header_view = refreshHeaderView;
        _refresh_header_view.backgroundColor = [UIColor clearColor];
    }
    
//    if (_refresh_bottom_view == nil)
//    {
//        CGFloat height = [self.m_CollectionTable.collectionViewLayout collectionViewContentSize].height;
//        if (height < self.m_CollectionTable.height)
//        {
//            height = self.m_CollectionTable.height;
//        }
//        _refresh_bottom_view = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, height, self.m_CollectionTable.width, self.m_CollectionTable.height)];
//        _refresh_bottom_view.delegate = self;
//        _refresh_bottom_view.backgroundColor = [UIColor clearColor];
//        [self.m_CollectionTable addSubview:_refresh_bottom_view];
//    }
//    [_refresh_bottom_view refreshPullUpLastUpdatedDate];
}


-(BOOL)isGetUserDistanceInfomation
{
    if(![CLLocationManager locationServicesEnabled])
    {
       //设备未开启定位
        
        [AlertUtil showAlert:@"定位服务不可用" withMessage:@"请在系统设置-“定位服务”中 \n允许宝宝树孕育确定您的位置  "];
        return NO;
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
       //未允许app定位
        [AlertUtil showAlert:@"定位服务不可用" withMessage:@"请在系统设置-“定位服务”中 \n允许宝宝树孕育确定您的位置  "];
        return NO;
    }
    else
    {
        [ApplicationDelegate getUserLocationInfomation];
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- API And Httpdelegate
- (void)getMemberListData
{
    [self.s_MBProgress show:YES];
    [self.s_Request clearDelegatesAndCancel];
    
    switch (self.m_CircleMembertype)
    {
        case BBTopMember:
        {
            [self.s_TopArray removeAllObjects];
            self.s_Request = [HMApiRequest setCircleTopMemberList:self.m_CircleID];
        }
            break;
        case BBDistancemember:
        {
            if (![self isGetUserDistanceInfomation])
            {
                return;
            }
            [self.s_DisArray removeAllObjects];
            self.s_Request = [HMApiRequest setCircleDisMemberList:self.m_CircleID];
        }
            break;
        case BBAgeMember:
        {
            [self.s_AgeArray removeAllObjects];
            self.s_Request = [HMApiRequest setCircleAgeMemberList:self.m_CircleID];
        }
            break;
        default:
            break;
    }

    [self.s_Request setDidFinishSelector:@selector(memberDataRequestFinish:)];
    [self.s_Request setDidFailSelector:@selector(memberDataRequestFail:)];
    [self.s_Request setDelegate:self];
    [self.s_Request startAsynchronous];

}

- (void)memberDataRequestFinish:(ASIFormDataRequest *)request
{
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    NSDictionary *userInfoData = [responseString objectFromJSONString];
    if (![userInfoData isDictionaryAndNotEmpty])
    {
        [self setNodataViewErrorType:HMNODATAVIEW_DATAERROR withAlertTitle:@"网络获取数据错误"];
        return;
    }
    
    NSString *status = [userInfoData stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"1"])
    {
        if (self.m_CircleMembertype == BBTopMember)
        {
            NSDictionary *myDic = [[userInfoData dictionaryForKey:@"data"] dictionaryForKey:@"userinfo"];
            if ([myDic isNotEmpty])
            {
                if (!self.s_MyTopObj)
                {
                    self.s_MyTopObj = [[BBMemberClass alloc]init];
                }
                
                self.s_MyTopObj.m_UserAvatar = [myDic stringForKey:@"author_avatar"];
                self.s_MyTopObj.m_UserTop    = [myDic stringForKey:@"myNum"];
                self.s_MyTopObj.m_Contribution = [myDic stringForKey:@"myExp"];
            }
        }
        
        NSArray *listData = [[userInfoData dictionaryForKey:@"data"] arrayForKey:@"list"];
        NSInteger i = 1;
        for (NSDictionary *dic in listData)
        {
            BBMemberClass *memberObj = [[BBMemberClass alloc]init];
            memberObj.m_UserAdress = [dic stringForKey:@"city_name"];
            memberObj.m_UserName   = [dic stringForKey:@"author_name"];
            memberObj.m_UserAvatar = [dic stringForKey:@"author_avatar"];
            memberObj.m_UserEncodeID = [dic stringForKey:@"author_enc_user_id"];
            memberObj.m_UserRank   = [dic stringForKey:@"level_num"];
            memberObj.m_UserPregnancy = [dic stringForKey:@"babyage"];
            memberObj.m_UserHospital = [dic stringForKey:@"hospital_name"];
            
            switch (self.m_CircleMembertype)
            {
                case BBTopMember:
                {
                    memberObj.m_MemberType = BBTopMember;
                    memberObj.m_UserTop = [NSString stringWithFormat:@"%d",i++];
                    memberObj.m_SignImage =[dic stringForKey:@"active_user_avater"];
                    memberObj.m_SignName = [dic stringForKey:@"active_user_title"];
                    memberObj.m_Contribution = [dic stringForKey:@"exp"];
                    [self.s_TopArray addObject:memberObj];
                }
                    break;
                case BBDistancemember:
                {
                    memberObj.m_MemberType = BBDistancemember;
                    memberObj.m_Distance = [dic stringForKey:@"distance"];
                    [self.s_DisArray addObject:memberObj];
                }
                    break;
                case BBAgeMember:
                {
                    memberObj.m_MemberType = BBAgeMember;
                    [self.s_AgeArray addObject:memberObj];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [self setNodataViewErrorType:HMNODATAVIEW_PROMPT withAlertTitle:nil];
    }
    else
    {
        [self setNodataViewErrorType:HMNODATAVIEW_DATAERROR withAlertTitle:@"网络获取数据错误"];
    }
    
    [self reloadCollectionTable];

}

- (void)memberDataRequestFail:(ASIFormDataRequest *)request
{
    [self setNodataViewErrorType:HMNODATAVIEW_NETERROR withAlertTitle:@"亲，您的网络不给力啊"];
    
    [self reloadCollectionTable];
}

-(void)setNodataViewErrorType:(HMNODATAVIEW_TYPE)errType withAlertTitle:(NSString*)errorStr
{
    [self.s_MBProgress hide:YES];
    [self cancelRefreshView];
    
    switch (self.m_CircleMembertype)
    {
        case BBTopMember:
        {
            if ([self.s_TopArray count] == 0)
            {
                [self changeNoDataViewWithHiddenStatus:NO withType:errType];
            }
            else  if ([self isValided] && [errorStr isNotEmpty])
            {
                [PXAlertView showAlertWithTitle:errorStr];
            }
        }
            break;
        case BBDistancemember:
        {
            if ([self.s_DisArray count] == 0)
            {
                [self changeNoDataViewWithHiddenStatus:NO withType:errType];
                if (errType == HMNODATAVIEW_PROMPT)
                {
                    self.m_NoDataView.m_PromptText = @"亲，附近暂时没有圈里的姐妹";

                }
            }
            else  if ([self isValided] && [errorStr isNotEmpty])
            {
                [PXAlertView showAlertWithTitle:errorStr];
            }
        }
            break;
        case BBAgeMember:
        {
            if ([self.s_AgeArray count] == 0)
            {
                [self changeNoDataViewWithHiddenStatus:NO withType:errType];
                if (errType == HMNODATAVIEW_PROMPT)
                {
                    self.m_NoDataView.m_PromptText = @"亲，圈里暂时没有符合条件的姐妹。\n可以去其他圈子看看~";
                }
            }
            else  if ([self isValided] && [errorStr isNotEmpty])
            {
                [PXAlertView showAlertWithTitle:errorStr];
            }
        }
            break;
        default:
            break;
    }

}

-(void)reloadCollectionTable
{
    [self.s_MBProgress hide:YES];
    switch (self.m_CircleMembertype)
    {
        case BBTopMember:
        {
            [MobClick event:@"discuz_v2" label:@"圈成员-圈排行pv"];
            _refresh_bottom_view.hidden = YES;
            [self.m_CollectionTable reloadData];
        }
            break;
        case BBDistancemember:
        {
            [MobClick event:@"discuz_v2" label:@"圈成员-距离近pv"];
            _refresh_bottom_view.hidden = YES;
            [self.m_CollectionTable reloadData];
        }
            break;
        case BBAgeMember:
        {
            if (self.m_IsBirthdayClub)
            {
                [MobClick event:@"discuz_v2" label:@"圈成员-同生日pv"];
            }
            else
            {
                [MobClick event:@"discuz_v2" label:@"圈成员-同孕龄pv"];   
            }
            _refresh_bottom_view.hidden = YES;
            [self.m_CollectionTable reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.m_CircleMembertype)
    {
        case BBTopMember:
            return [self.s_TopArray count];
            break;
        case BBDistancemember:
            return [self.s_DisArray count];
            break;
        case BBAgeMember:
            return [self.s_AgeArray count];
            break;
        default:
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.m_CircleMembertype)
    {
        case BBTopMember:
        {
            BBTopListMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topListIdentifer forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];

            if (indexPath.row < [self.s_TopArray count])
            {
                [cell setMemberCellData:[self.s_TopArray objectAtIndex:indexPath.row]];
            }
            return cell;
        }
            break;
        case BBDistancemember:
        {
            BBCircleMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            if (indexPath.row < [self.s_DisArray count])
            {
                [cell setMemberCellData:[self.s_DisArray objectAtIndex:indexPath.row]];
            }
            return cell;
        }
            break;
        case BBAgeMember:
        {
            BBCircleMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            if (indexPath.row < [self.s_AgeArray count])
            {
                [cell setMemberCellData:[self.s_AgeArray objectAtIndex:indexPath.row]];
            }
            return cell;
        }
            break;
        default:
            break;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (self.m_CircleMembertype)
    {
        case BBTopMember:
            return CGSizeMake(320, 82);
            break;
        case BBDistancemember:
            return CGSizeMake(320, 6);
            break;
        case BBAgeMember:
            return CGSizeMake(320, 6);
            break;
        default:
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BBTopMemberCell *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:topIdentifer forIndexPath:indexPath];
    headview.backgroundColor = [UIColor clearColor];
    headview.hidden = YES;
    if (self.m_CircleMembertype == BBTopMember && self.s_MyTopObj)
    {
        headview.hidden = NO;
        headview.delegate = self;
        headview.m_TopLabel.text = self.s_MyTopObj.m_UserTop;
        CGSize size = headview.m_AvtarImage.size;
        [headview.m_AvtarImage roundCornersTopLeft:size.width/2 topRight:size.width/2 bottomLeft:size.height/2 bottomRight:size.height/2];
        [headview.m_AvtarImage setImageWithURL:[NSURL URLWithString:self.s_MyTopObj.m_UserAvatar] placeholderImage:[UIImage imageNamed:@"personal_default_avatar"]];
        headview.m_Contributionlabel.text = self.s_MyTopObj.m_Contribution;
    }
    return headview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.m_CircleMembertype)
    {
        case BBTopMember:
        {
            if (indexPath.row <[self.s_TopArray count])
            {
                BBMemberClass *memberObj = [self.s_TopArray objectAtIndex:indexPath.row];
                [HMShowPage showPersonalCenter:self userEncodeId:memberObj.m_UserEncodeID vcTitle:memberObj.m_UserName];
            }
        }
            break;
        case BBDistancemember:
        {
            if (indexPath.row <[self.s_DisArray count])
            {
                BBMemberClass *memberObj = [self.s_DisArray objectAtIndex:indexPath.row];
                [HMShowPage showPersonalCenter:self userEncodeId:memberObj.m_UserEncodeID vcTitle:memberObj.m_UserName];
            }
        }
            break;
        case BBAgeMember:
        {
            if (indexPath.row <[self.s_AgeArray count])
            {
                BBMemberClass *memberObj = [self.s_AgeArray objectAtIndex:indexPath.row];
                [HMShowPage showPersonalCenter:self userEncodeId:memberObj.m_UserEncodeID vcTitle:memberObj.m_UserName];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 圈排行点击跳规则页delegate
-(void)clickedTopMemberRule
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    NSString *url = [NSString stringWithFormat:@"%@/app/community/rule",BABYTREE_URL_SERVER];
    [exteriorURL setLoadURL:url];
    [exteriorURL setTitle:@"如何上榜"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
}

#pragma mark -- cancel refresh

-(void)cancelRefreshView
{
    if (_header_reloading)
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
    if (_bottom_reloading)
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate


-(void)hmRefreshTableHeaderDidTriggerRefresh:(HMRefreshTableHeaderView *)headerView
{
    [self reloadTableViewDataSource];
}

- (BOOL)hmRefreshTableHeaderDataSourceIsLoading:(HMRefreshTableHeaderView *)headerView
{
    return _header_reloading;
}

// 下拉
- (void)reloadTableViewDataSource
{
    if (_bottom_reloading != YES && _header_reloading != YES )
    {
        _header_reloading = YES;
        [self getMemberListData];
    }
    else
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:EGOHEAD_REFRESH_DELAY inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)doneLoadingTableViewData
{
    _header_reloading = NO;
    [_refresh_header_view hmRefreshScrollViewDataSourceDidFinishedLoading:self.m_CollectionTable];
}


#pragma mark -
#pragma mark EGORefreshPullUpTableHeaderDelegate

//上拉
- (void)reloadPullUpTableViewDataSource
{
    if (_bottom_reloading != YES && _header_reloading != YES )
    {
        _bottom_reloading = YES;
        [self getMemberListData];
    }
    else
    {
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)egoRefreshPullUpTableHeaderDidTriggerRefresh:(EGORefreshPullUpTableHeaderView*)view
{
	[self reloadPullUpTableViewDataSource];
}

- (BOOL)egoRefreshPullUpTableHeaderDataSourceIsLoading:(EGORefreshPullUpTableHeaderView*)view
{
	return _bottom_reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshPullUpTableHeaderDataSourceLastUpdated:(EGORefreshPullUpTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

- (void)doneLoadingPullUpTableViewData
{
    _bottom_reloading = NO;
    [_refresh_bottom_view egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.m_CollectionTable];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresh_header_view hmRefreshScrollViewDidScroll:scrollView];
    [_refresh_bottom_view egoRefreshPullUpScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresh_header_view hmRefreshScrollViewDidEndDragging:scrollView];
    [_refresh_bottom_view egoRefreshPullUpScrollViewDidEndDragging:scrollView];
}


#pragma mark - HMNoDataViewDelegate andOtherFunction

-(void)freshFromNoDataView
{
    [self getMemberListData];
}

-(void)addNoDataView
{
    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.m_CollectionTable addSubview:self.m_NoDataView];
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.delegate = self;
    self.m_NoDataView.hidden = YES;
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus
{
    [self changeNoDataViewWithHiddenStatus:theHiddenStatus withType:HMNODATAVIEW_CUSTOM];
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus withType:(HMNODATAVIEW_TYPE)theType
{
    self.m_NoDataView.m_Type = theType;
    self.m_NoDataView.hidden = theHiddenStatus;
}



@end
