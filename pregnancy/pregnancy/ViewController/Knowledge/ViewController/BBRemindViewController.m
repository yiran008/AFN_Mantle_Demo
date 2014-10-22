//
//  BBRemindViewController.m
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBRemindViewController.h"
#import "BBKonwlegdeDB.h"
#import "BBRemindCell.h"
#import "BBPregnancyInfo.h"
#import "BBKonwlegdeModel.h"
#import "BBAdRequest.h"
#import "ASIHTTPRequest.h"
#import "BBAdPVManager.h"
#import "BBSupportTopicDetail.h"
#import "BBKnowledgeDateLabelView.h"
#import "DAReloadActivityButton.h"

#define REMIND_PAGE_SIZE 50

@interface BBRemindViewController ()<UITableViewDataSource,UITableViewDelegate,BBRemindDelegate>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * remindArr;
@property(nonatomic,strong) NSMutableArray * allArr;
@property RemindType type;
@property int days;
@property NSMutableDictionary * ads;
@property NSString *curIDs;
@property ASIHTTPRequest *adRequest;
@property ASIHTTPRequest *logoAdRequest;
@property NSDictionary *logoAdData;
@property UIImageView *adImageView;
@property BOOL isCanSendPV;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)DAReloadActivityButton *loadingBtn;
@property int startIndex;
@property int endIndex;
@end

@implementation BBRemindViewController

-(void)dealloc
{
    [_adRequest clearDelegatesAndCancel];
    [_logoAdRequest clearDelegatesAndCancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isCanSendPV = NO;
    }
    return self;
}

- (id)initWithType:(RemindType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:self.type == RemindTypeRimind?@"knowledge_remind_v2":@"knowledge_grown_v2" label:@"访问用户数"];
    
    if (_type == RemindTypeRimind)
    {
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"关爱提醒"]];
    }else
    {
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"宝宝发育"]];
    }
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height-20-44)style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    self.days = [BBPregnancyInfo daysOfPregnancy];
    BBUserRoleState  state = [BBUser getNewUserRoleState];
    //为了提高cell的效率，减少io操作，做静态变量
    [BBKnowledgeDateLabelView setCurDays:self.days];
    [BBKnowledgeDateLabelView setRoleState:state];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.remindArr = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (_type == RemindTypeRimind) {
            _allArr = [BBKonwlegdeDB allReminds];
        }else
        {
            _allArr = [BBKonwlegdeDB allBabyGrowth];
        }
        int index = 0;
        for (int i = 0; i < _allArr.count; i++)
        {
            BBKonwlegdeModel * obj = [_allArr objectAtIndex:i];
            if ([obj.ID isEqualToString:self.startID])
            {
                index = i;
                break;
            }
        }
        
        NSRange range;
        if (_allArr.count > REMIND_PAGE_SIZE)
        {
            range.location = index - 10 > 0 ? index - 10 : 0;
            if (range.location + REMIND_PAGE_SIZE >= _allArr.count) {
                range.location = _allArr.count - REMIND_PAGE_SIZE;
            }
            range.length = REMIND_PAGE_SIZE;
        }
        else
        {
            range.location = 0;
            range.length = _allArr.count;
        }
        [_remindArr replaceObjectsInRange:NSMakeRange(0, 0) withObjectsFromArray:[_allArr subarrayWithRange:range]];
        self.startIndex = range.location;
        self.endIndex = range.location + range.length -1;
        
        for (int i = 0; i < _remindArr.count; i++)
        {
            BBKonwlegdeModel * obj = [_remindArr objectAtIndex:i];
            if ([obj.ID isEqualToString:self.startID])
            {
                index = i;
                break;
            }
        }
        
        if (self.type == RemindTypeRimind)
        {
            //先展示缓存
            NSArray *adArr = [BBUser getRemindAds];
            if (adArr && adArr.count)
            {
                self.ads = [NSMutableDictionary dictionary];
                for (NSDictionary *dic in adArr)
                {
                    NSDictionary *adDic = [dic dictionaryForKey:@"ad"];
                    BBAdModel *obj = [[BBAdModel alloc]init];
                    obj.adServer = [adDic stringForKey:AD_DICT_SERVER_KEY];
                    obj.adContent = [adDic stringForKey:AD_DICT_CONTENT_KEY];
                    obj.adBannerID = [adDic stringForKey:AD_DICT_BANNERID_KEY];
                    obj.adUrl = [adDic stringForKey:AD_DICT_URL_KEY];
                    obj.adMonitor = [adDic stringForKey:AD_DICT_MONITOR_KEY];
                    obj.adZoneID = [adDic stringForKey:AD_DICT_ZONEID_KEY];
                    
                    NSString *key = [dic stringForKey:@"tip_id"];
                    if (key)
                    {
                        [self.ads setObject:obj forKey:key];
                    }
                }
            }
            
            NSMutableArray * arr = [NSMutableArray array];
            int startIndex = 0;
            if (index - 3 > 0)
            {
                startIndex = index - 3;
            }
            if (startIndex + 10 > _remindArr.count)
            {
                startIndex = _remindArr.count - 10;
            }
            if (startIndex + 9 < _remindArr.count && _remindArr.count >=10)
            {
                for (int i = startIndex; i < startIndex +10; i++)
                {
                    BBKonwlegdeModel *obj = [_remindArr objectAtIndex:i];
                    [arr addObject:obj.ID];
                }
                _curIDs = [arr componentsJoinedByString:@","];
                self.adRequest = [BBAdRequest getRemindAdRequestWithIDs:_curIDs];
                [self.adRequest setDidFinishSelector:@selector(getAdFinished:)];
                [self.adRequest setDidFailSelector:@selector(getAdFailed:)];
                [self.adRequest setDelegate:self];
                [self.adRequest startAsynchronous];
            }
        }
        
        [self refreshDataSource];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [self.hud hide:YES];
            if (_remindArr && _remindArr.count)
            {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
    });
    
    [self handelAd];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goAdWebPage:) name:REMIND_AD_TAP object:nil];
    
    self.loadingBtn = [[DAReloadActivityButton alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - classMethod

- (void)handelAd
{
    //下载展示宝宝发育的广告图
    if (self.type == RemindTypeBabyGrowth)
    {
        //先展示缓存
        self.adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(48, 4, 64, 36)];
        [self.navigationController.navigationBar addSubview:self.adImageView];
        [self.adImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.adImageView setClipsToBounds:YES];
        self.adImageView.userInteractionEnabled = YES;
        self.logoAdData = [BBUser getRemindLogoData];
        NSString * url = [self.logoAdData stringForKey:AD_DICT_NORMAL_IMG_KEY];
        if (url)
        {
            [self.adImageView setImageWithURL:[NSURL URLWithString:url]];
        }
        
        self.logoAdRequest = [BBAdRequest getAdRequestForZoneType:AdZoneTypeBabyGrowLogo];
        [self.logoAdRequest setDidFinishSelector:@selector(getLogoAdFinished:)];
        [self.logoAdRequest setDidFailSelector:@selector(getLogoAdFailed:)];
        [self.logoAdRequest setDelegate:self];
        [self.logoAdRequest startAsynchronous];
    }
    else if (self.type == RemindTypeRimind)
    {

    }
}

- (void)refreshDataSource
{
    for (int i = 0; i < _remindArr.count; i++)
    {
        [self handleDataSourceWithObj:[_remindArr objectAtIndex:i] index:i];
    }
}

//处理数据源
- (void)handleDataSourceWithObj:(BBKonwlegdeModel *)obj index:(int)index
{
    float cellHeight = 0;
    
    if (obj.imgArrStr && obj.imgArrStr.length)
    {
        NSArray * mgArr = [NSJSONSerialization JSONObjectWithData:[obj.imgArrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if (mgArr && mgArr.count)
        {
            obj.image = [mgArr.firstObject stringForKey:@"middle_src"];
        }
    }
    
    //如果有图片
    if (obj.image && obj.image.length > 1)
    {
        cellHeight = cellHeight + REMIND_IMGEVIEW_MINHEIGHT;
        
        if (obj.title)
        {
            CGSize timeSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(230.0, 1024.0) withFont:[UIFont systemFontOfSize:REMIND_FONT_CONTENT] withString:obj.title];
            obj.textHight = timeSize.height + 10;
            cellHeight = cellHeight + obj.textHight + 10;
        }
    }else
    {
        cellHeight = cellHeight + REMIND_CONTENTVIEW_MINHEIGHT;
        
        if (obj.title)
        {
            CGSize timeSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(230.0, 1024.0) withFont:[UIFont systemFontOfSize:REMIND_FONT_CONTENT] withString:obj.title];
            obj.textHight = timeSize.height + 10;
            if (obj.textHight + 20 > REMIND_CONTENTVIEW_MINHEIGHT)
            {
                cellHeight = cellHeight - REMIND_CONTENTVIEW_MINHEIGHT + obj.textHight + 20;
            }
        }
    }
    
    BBAdModel * ad = [self.ads objectForKey:obj.ID];
    if (ad)
    {
        if (ad.adContent)
        {
            CGSize timeSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(320-26, 1024.0) withFont:[UIFont systemFontOfSize:REMIND_FONT_CONTENT] withString:ad.adContent];
            ad.adContextHeight = timeSize.height + 10;
            {
                cellHeight = cellHeight +ad.adContextHeight + 20;
            }
        }
    }
    
    obj.cellHight = cellHeight;
    
    if (obj.days) {
        obj.week = [NSString stringWithFormat:@"%d",obj.days.intValue /7];
        obj.weekPlusDay = [NSString stringWithFormat:@"%d",obj.days.intValue%7];
    }
}

-(void)leftButtonAction:(id)btn
{
    [_adImageView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadNextPage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (self.allArr.count && self.endIndex>=0 && self.endIndex < self.allArr.count - 1)
        {
            self.endIndex ++;
            NSRange range;
            range.location = self.endIndex;
            range.length = REMIND_PAGE_SIZE >= self.allArr.count - self.endIndex ? self.allArr.count - self.endIndex : REMIND_PAGE_SIZE;
            NSArray * arr = [self.allArr subarrayWithRange:range];
            for (BBKonwlegdeModel * model in arr) {
                [self handleDataSourceWithObj:model index:0];
            }
            [_remindArr addObjectsFromArray:arr];
            self.endIndex = range.location + range.length -1;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.loadingBtn stopAnimating];
            [self.loadingBtn removeFromSuperview];
            self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height);
        });
    });
}

-(void)loadPrePage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __block NSRange range = NSMakeRange(0, 0);
        if (self.allArr.count && self.startIndex>0)
        {
            self.startIndex --;
            range.location = self.startIndex>=REMIND_PAGE_SIZE-1 ?self.startIndex - REMIND_PAGE_SIZE +1: 0;
            range.length = self.startIndex>=REMIND_PAGE_SIZE-1 ? REMIND_PAGE_SIZE : self.startIndex+1;
            NSArray * arr = [self.allArr subarrayWithRange:range];
            for (BBKonwlegdeModel * model in arr) {
                [self handleDataSourceWithObj:model index:0];
            }
            [_remindArr replaceObjectsInRange:NSMakeRange(0, 0) withObjectsFromArray:arr];
            self.startIndex = range.location;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:range.length inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self.loadingBtn stopAnimating];
            [self.loadingBtn removeFromSuperview];
            self.tableView.contentInset = UIEdgeInsetsZero;
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y-40) animated:YES];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.remindArr) {
        return self.remindArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.remindArr && [self.remindArr objectAtIndex:indexPath.row])
    {
        BBKonwlegdeModel * data = (BBKonwlegdeModel *)[self.remindArr objectAtIndex:indexPath.row];
        float height = data.cellHight;
        return height > 0 ? height:0;
    }
    return 0;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 78;
//}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBRemindCell";
    
    BBRemindCell *cell = [tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BBRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    BBKonwlegdeModel * data = [self.remindArr objectAtIndex:indexPath.row];
    
    BBAdModel *adData = [self.ads objectForKey:data.ID];
    cell.delegate = self;
    [cell setData:[self.remindArr objectAtIndex:indexPath.row] AdData:adData];
    if (adData && self.isCanSendPV)
    {
        [[BBAdPVManager sharedInstance]addLocalPVForAdModel:adData];
    }
    return cell;
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.remindArr.count)
    {
        float height = self.tableView.contentSize.height;
        
        if ((((self.tableView.contentOffset.y>=height-self.tableView.frame.size.height+2 ) && (height > self.tableView.frame.size.height )) || (height < self.tableView.frame.size.height && self.tableView.contentOffset.y>0)) && ![self.loadingBtn isAnimating] && self.endIndex < self.allArr.count - 1)
        {
            self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+40);
            self.loadingBtn.center = CGPointMake(160, height + 17/2);
            [self.tableView addSubview:self.loadingBtn];
            [self.loadingBtn startAnimating];
            [self loadNextPage];
        }
        else if(self.tableView.contentOffset.y<-2 && height > self.tableView.frame.size.height && ![self.loadingBtn isAnimating] && self.startIndex > 0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, 40.f, 0.0f);
            self.loadingBtn.center = CGPointMake(160, -17/2 - 5);
            [self.tableView addSubview:self.loadingBtn];
            [self.loadingBtn startAnimating];
            [self loadPrePage];
        }
        
    }
}

#pragma mark- httpMethod
-(void)getAdFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        if ([[data arrayForKey:@"data"] count] >0)
        {
            self.ads = [NSMutableDictionary dictionary];
            NSArray * arr = [data arrayForKey:@"data"];
            for (NSDictionary *dic in arr)
            {
                NSDictionary *adDic = [dic dictionaryForKey:@"ad"];
                BBAdModel *obj = [[BBAdModel alloc]init];
                obj.adContent = [adDic stringForKey:AD_DICT_CONTENT_KEY];
                obj.adBannerID = [adDic stringForKey:AD_DICT_BANNERID_KEY];
                obj.adUrl = [adDic stringForKey:AD_DICT_URL_KEY];
                obj.adMonitor = [adDic stringForKey:AD_DICT_MONITOR_KEY];
                obj.adZoneID = [adDic stringForKey:AD_DICT_ZONEID_KEY];
                obj.adServer = [adDic stringForKey:AD_DICT_SERVER_KEY];
                
                NSString *key = [dic stringForKey:@"tip_id"];
                if (key)
                {
                    [self.ads setObject:obj forKey:key];
                }
            }
            if (self.ads && self.ads.count)
            {
                self.isCanSendPV = YES;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [self refreshDataSource];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        if (arr && arr.count)
                        {
                            [BBUser setRemindAds:arr];
                        }
                    });
                });
                
            }
        }else
        {
            //没有关爱提醒广告要清空当前的关爱提醒广告缓存
            [BBUser setRemindAds:[NSArray array]];
        }
    }
}

-(void)getAdFailed:(ASIHTTPRequest *)requst
{
    self.isCanSendPV = YES;
    if(self.ads && self.ads.count)
    {
        //为了统计离线的广告展现
        [self.tableView reloadData];
    }
}

-(void)getLogoAdFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"])
    {
        if ([data dictionaryForKey:@"data"])
        {
            self.ads = [NSMutableDictionary dictionary];
            NSDictionary * dic = [data dictionaryForKey:@"data"];
            self.logoAdData = [dic dictionaryForKey:@"ad"];
            NSString * url = [self.logoAdData stringForKey:AD_DICT_NORMAL_IMG_KEY];
            if (url)
            {
                [self.adImageView setImageWithURL:[NSURL URLWithString:url]];
            }
            if (self.logoAdData && self.logoAdData.count)
            {
                [BBUser setRemindLogoData:self.logoAdData];
                [[BBAdPVManager sharedInstance]addLocalPVForAd:self.logoAdData];
            }else
            {
                //没有取到广告，下架广告
                [BBUser removeRemindLogoData];
            }
        }
    }
}

-(void)getLogoAdFailed:(ASIHTTPRequest *)requst
{
    if (self.logoAdData)
    {
        [[BBAdPVManager sharedInstance]addLocalPVForAd:self.logoAdData];
    }
}

- (void)goAdWebPage:(NSNotification*)notify
{
    NSDictionary *dic = notify.userInfo;
    if (dic && [dic stringForKey:AD_DICT_URL_KEY])
    {
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        NSString *adTitle = [dic stringForKey:AD_DICT_TITLE_KEY]?[dic stringForKey:AD_DICT_TITLE_KEY]:@"推广";
        [exteriorURL setLoadURL:[dic stringForKey:AD_DICT_URL_KEY]];
        [exteriorURL setTitle:adTitle];
        [self.navigationController pushViewController:exteriorURL animated:YES];
    }
}

#pragma mark -remindCellDelegate

-(void)BBRemindCell:(BBRemindCell *)cell imageClicked:(UIImageView *)imageView
{
    CGRect rect = [imageView  convertRect:imageView.bounds toView:self.view ];
    if (imageView && imageView.image)
    {
        [MobClick event:@"knowledge_grown_v2" label:@"图片点击"];
        PicReviewView *pView = [[PicReviewView alloc] initWithRect:rect placeholderImage:imageView.image];
        pView.shareTypeMark = BBShareTypeRecord;
        int index = [self.tableView indexPathForCell:cell].row;
        if (index>=0 && index < self.remindArr.count)
        {
            BBKonwlegdeModel *model =[self.remindArr objectAtIndex:index];
            if (model.imgArrStr && model.imgArrStr.length)
            {
                NSArray * mgArr = [NSJSONSerialization JSONObjectWithData:[model.imgArrStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                if (mgArr && mgArr.count)
                {
                    NSString *imageStr = [mgArr.firstObject stringForKey:@"big_src"];
                    if (imageStr)
                    {
                        [pView loadUrl:[NSURL URLWithString:imageStr]];
                        [self.view addSubview:pView];
                        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                        [self.navigationController setNavigationBarHidden:YES animated:NO];
                    }
                }
            }
        }
    }

}

@end
