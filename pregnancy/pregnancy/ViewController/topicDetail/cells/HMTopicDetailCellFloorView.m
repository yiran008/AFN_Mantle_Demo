//
//  HMTopicDetailCellFloorView.m
//  lama
//
//  Created by mac on 13-8-5.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCellFloorView.h"
#import "HMApiRequest.h"
#import "BBUser.h"
#import "ARCHelper.h"
#import "BaiduMobAdView.h"
#import "BBAdConfig.h"
@interface HMTopicDetailCellFloorView ()

@property (nonatomic,strong)GDTMobBannerView *s_GDTBannerView;
@property (nonatomic,strong)BaiduMobAdView* s_BABannerView;
@end


@implementation HMTopicDetailCellFloorView
@synthesize m_PublishImageView;
@synthesize m_PublishLabel;
@synthesize m_ReplyBtn;
@synthesize m_LoveRequest;
@synthesize m_ActivityView;
@synthesize m_CityLabel;
@synthesize m_CityImageView;
@synthesize s_GDTBannerView;
@synthesize s_BABannerView;

- (void)dealloc
{
    s_GDTBannerView.delegate = nil;
    s_GDTBannerView.currentViewController = nil;
    [s_GDTBannerView ah_release];
    s_BABannerView.delegate = nil;
    [s_BABannerView ah_release];
    [m_PublishImageView ah_release];
    [m_PublishLabel ah_release];
    [m_CityImageView ah_release];
    [m_CityLabel ah_release];
    [m_ReplyBtn ah_release];

    [m_LoveRequest clearDelegatesAndCancel];
    [m_LoveRequest ah_release];
    [m_ActivityView ah_release];
    [_m_adImageView ah_release];
    
    [super ah_dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawTopicDetailCell:(HMTopicDetailCellClass *)topicDetail withTopicDelegate:(id <HMTopicDetailCellDelegate>)topicDelagate
{
    [super drawTopicDetailCell:topicDetail withTopicDelegate:topicDelagate];

    m_PublishLabel.textColor = DETAIL_TIME_COLOR;
    m_CityLabel.textColor = DETAIL_TIME_COLOR;
    
    //CGSize size = CGSizeZero;

    if ([topicDetail.m_PublishTime isNotEmpty])
    {
        CGFloat x = 16;
        m_PublishImageView.hidden = NO;
        m_PublishLabel.hidden = NO;
        m_PublishLabel.text = topicDetail.m_PublishTime;
        
        m_PublishImageView.left = x;
        m_PublishLabel.left = x + m_PublishImageView.width + 5;
//        
//        x = m_PublishLabel.left + m_PublishLabel.width + 8;
    }
    else
    {
        m_PublishImageView.hidden = YES;
        m_PublishLabel.hidden = YES;
    }
    
    if ([topicDetail.m_LocalCity isNotEmpty])
    {
        m_CityImageView.hidden = NO;
        m_CityLabel.hidden = NO;
        m_CityLabel.text = topicDetail.m_LocalCity;
    }
    else
    {
        m_CityImageView.hidden = YES;
        m_CityLabel.hidden = YES;
    }

    m_ReplyBtn.hidden = YES;
    m_ReplyBtn.exclusiveTouch = YES;
    
    if (self.m_TopicDetail.m_TopicInfor.m_IsMaster && self.m_TopicDetail.m_Type == TOPICDETAILCELL_MASTERFLOOR_TYPE)
    {
        // 主楼做喜欢功能
        m_ReplyBtn.hidden = YES;
//        [self freshLoveButtomWidthWithNumber:self.m_TopicDetail.m_TopicInfor.totalLoveTime];
//        [m_ReplyBtn addTarget:self action:@selector(addLoveAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.m_adImageView.hidden = YES;
        s_GDTBannerView.hidden = YES;
        s_BABannerView.hidden = YES;

        if ([topicDetail.m_adStatus isNotEmpty])
        {
            if ([topicDetail.m_adStatus isEqual:@"babytree"])
            {
                if (topicDetail.m_adImg)
                {
                    if (!self.m_adImageView)
                    {
                        self.m_adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, m_PublishLabel.bottom + TOPICDETAILCELLFLOOR_AD_EDGE, TOPICDETAILCELLFLOOR_AD_WIDTH, TOPICDETAILCELLFLOOR_AD_HEIGHT)];
                        [self addSubview:self.m_adImageView];
                    }
                    self.m_adImageView.hidden = NO;
                    [self.m_adImageView setImageWithURL:[NSURL URLWithString:topicDetail.m_adImg]];
                    self.m_adImageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *adTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTapped:)];
                    [self.m_adImageView addGestureRecognizer:adTap];
                    self.m_adImageView.exclusiveTouch = YES;
                }
            }
            else if ([topicDetail.m_adStatus isEqual:@"other"])
            {
                 //展示广点通广告
                if ([topicDetail.m_adUnion isEqual:@"gdt"])
                {
                    if (!s_GDTBannerView)
                    {
                        CGRect rect = CGRectMake(0, m_PublishLabel.bottom + TOPICDETAILCELLFLOOR_AD_EDGE, GDTMOB_AD_SIZE_320x50.width, GDTMOB_AD_SIZE_320x50.height);
                        // android
                        //s_BannerView = [[GDTMobBannerView alloc] initWithFrame:rect appkey:@"1101331070" placementId:@"9007479624530523088"];
                        // ios
                        s_GDTBannerView = [[GDTMobBannerView alloc] initWithFrame:rect appkey:GDT_AD_APPKEY placementId:GDT_AD_APPID];

                        //s_BannerView.isTestMode = YES;
                        s_GDTBannerView.delegate = self; // 设置 Delegate
                        s_GDTBannerView.currentViewController = (UIViewController *)self.delegate; // 设置当前的ViewController
                        s_GDTBannerView.interval = GDT_AD_INTERVAL; //【可选】设置刷新频率;默认30秒
                        s_GDTBannerView.isGpsOn = GDT_AD_ENABLE_LOCATION;
                        s_GDTBannerView.exclusiveTouch = YES;
                        [self addSubview:s_GDTBannerView];

                        [s_GDTBannerView loadAdAndShow]; // 加载广告并展示
                    }
                    
                    s_GDTBannerView.hidden = NO;
                }
                
                //展示百度联盟广告
                if ([topicDetail.m_adUnion isEqual:@"baidu"])
                {
                    if (!s_BABannerView)
                    {
                        CGRect rect = CGRectMake(0, m_PublishLabel.bottom + TOPICDETAILCELLFLOOR_AD_EDGE, kBaiduAdViewSizeDefaultWidth, kBaiduAdViewSizeDefaultHeight);
                        s_BABannerView = [[BaiduMobAdView alloc] init];
                        s_BABannerView.AdType = BaiduMobAdViewTypeBanner;
                        s_BABannerView.frame = rect;
                        s_BABannerView.delegate = self;
                        [self addSubview:s_BABannerView];
                        [s_BABannerView start];
                    }
                    s_BABannerView.hidden = NO;
                }
                
            }
        }
    }
    else
    {
        // 回复楼做回复功能
        m_ReplyBtn.hidden = NO;
        m_ReplyBtn.frame = CGRectMake(320 - 80, 0, 80, TOPICDETAILCELLFLOORVIEW_HEIGHT);
        
        [m_ReplyBtn setImage:[UIImage imageNamed:@"topicdetail_cell_reply_icon"] forState:UIControlStateNormal];
        [m_ReplyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 0)];
        
        [m_ReplyBtn setTitle:@"回复" forState:UIControlStateNormal];
        //       [m_ReplyBtn setTitleColor:DETAIL_REPLY_COLOR forState:UIControlStateNormal];
        [m_ReplyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];

        [m_ReplyBtn addTarget:self action:@selector(replyTopic:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.height = self.m_TopicDetail.m_Height;
}


#pragma mark -
#pragma mark GDTMobBannerViewDelegate

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    //NSLog(@"%s",__FUNCTION__);
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(int)errCode
{
    //NSLog(@"%s",__FUNCTION__);
}

// 全屏广告弹出时调用
//
// 详解:当广告栏被点击，弹出内嵌全屏广告时调用
- (void)bannerViewDidPresentScreen
{
    //NSLog(@"%s",__FUNCTION__);
}

// 全屏广告关闭时调用
// 详解:当弹出内嵌全屏广告关闭，返回广告栏界面时调用
- (void)bannerViewDidDismissScreen
{
    //NSLog(@"%s",__FUNCTION__);
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    //NSLog(@"%s",__FUNCTION__);
    [MobClick event:@"discuz_v2" label:@"GDT广告点击次数"];
}


#pragma mark- BaiduMobAdViewDelegate
/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString *)publisherId
{
    return BAIDU_AD_APPKEY;
}

/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString*) appSpec
{
    return BAIDU_AD_APPID;
}

/**
 *  启动位置信息
 */
-(BOOL) enableLocation
{
    return BAIDU_AD_ENABLE_LOCATION;
}

/**
 *  广告将要被载入
 */
-(void) willDisplayAd:(BaiduMobAdView*) adview
{
    
}

/**
 *  广告载入失败
 */
-(void) failedDisplayAd:(BaiduMobFailReason) reason
{
    
}

/**
 *  本次广告展示成功时的回调
 */
-(void) didAdImpressed
{
    
}

/**
 *  本次广告展示被用户点击时的回调
 */
-(void) didAdClicked
{
    [MobClick event:@"discuz_v2" label:@"BAIDU广告点击次数"];
}

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
-(void) didDismissLandingPage
{
    
}


#pragma mark -
#pragma mark love action

- (void)freshLoveButtomWidthWithNumber:(NSInteger)num
{
    NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] ah_autorelease];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0f;
    paragraphStyle.firstLineHeadIndent = 0.0f;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.paragraphSpacing = 0.0f;
    paragraphStyle.headIndent = 0.0f;

    NSString *loveStr = @"喜欢";
    NSString *allStr = [NSString stringWithFormat:@"%@ %d", loveStr, num];
    
    NSMutableAttributedString *attri = [[[NSMutableAttributedString alloc] initWithString:allStr] ah_autorelease];
    NSDictionary *attributes1 = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName : DETAIL_LOVE_COLOR,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    [attri setAttributes:attributes1 range:NSMakeRange(0, loveStr.length)];
    
    NSDictionary *attributes2 = @{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                  NSForegroundColorAttributeName : DETAIL_LOVECOUNT_COLOR,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    [attri setAttributes:attributes2 range:NSMakeRange(loveStr.length, allStr.length-loveStr.length)];
    
    [m_ReplyBtn setAttributedTitle:attri forState:UIControlStateNormal];
    
    CGSize size = [m_ReplyBtn.titleLabel.attributedText.string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByCharWrapping];
    float width = size.width>50? size.width+20:70;
    
    m_ReplyBtn.frame = CGRectMake(320 - width - TOPIC_ALL_EDGE_DISTANCE, (TOPICDETAILCELLFLOORVIEW_HEIGHT-24)/2, width, 24);
    UIImage *image = [UIImage imageNamed:@"listcell_like_bg"];
    image = [image stretchableImageWithLeftCapWidth:24 topCapHeight:12];
    [m_ReplyBtn setBackgroundImage:image forState:UIControlStateNormal];

    if (self.m_TopicDetail.m_TopicInfor.m_IsLoved)
    {
        [self.m_ReplyBtn setImage:[UIImage imageNamed:@"listcell_liked_btn@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.m_ReplyBtn setImage:[UIImage imageNamed:@"listcell_like_btn@2x.png"] forState:UIControlStateNormal];
    }
    
    [m_ReplyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, width-24)];
    [m_ReplyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
}

- (void)addLoveAction:(id)sender
{
    if (isSendingLove)
    {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(theTopicIdAboutDetail)])
    {
        NSString *topicId = [self.delegate theTopicIdAboutDetail];
        
        if (self.m_ActivityView == nil)
        {
            self.m_ActivityView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)] ah_autorelease];//指定进度轮的大小
            [m_ActivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
            [m_ReplyBtn addSubview:m_ActivityView];
        }
        
        [m_ActivityView centerInSuperView];
        [m_ActivityView startAnimating];
        
        if ([topicId isNotEmpty])
        {
            if (m_LoveRequest!=nil)
            {
                [m_LoveRequest clearDelegatesAndCancel];
            }
            
            self.m_LoveRequest = [HMApiRequest lovetTopicWithID:topicId];
            [m_LoveRequest setDelegate:self];
            [m_LoveRequest setDidFinishSelector:@selector(loveTopicFinished:)];
            [m_LoveRequest setDidFailSelector:@selector(loveTopicFail:)];
            [m_LoveRequest startAsynchronous];
            
            isSendingLove = YES;
            m_ReplyBtn.userInteractionEnabled = NO;
        }
    }
}

- (void)playLoveAnimation
{
    if (self.m_TopicDetail.m_TopicInfor.m_IsLoved)
    {
        [m_ReplyBtn setImage:[UIImage imageNamed:@"listcell_liked_btn@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [m_ReplyBtn setImage:[UIImage imageNamed:@"listcell_like_btn@2x.png"] forState:UIControlStateNormal];
    }
    
    __block UIButton *_btn = m_ReplyBtn;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         _btn.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
     }completion:^(BOOL finish)
     {
         if (finish)
         {
             [UIView animateWithDuration:0.2  animations:^
              {
                  _btn.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
              }completion:^(BOOL finish)
              {
                  if (finish)
                  {
                      [UIView animateWithDuration:0.2   animations:^
                       {
                           _btn.imageView.transform = CGAffineTransformMakeScale(1, 1);
                       }completion:^(BOOL finish)
                       {
                           if (finish)
                           {
                               _btn.userInteractionEnabled = YES;
                           }
                       }];
                  }
              }];
         }
     }];
}


#pragma mark -
#pragma mark ad action

- (void)adTapped:(UIGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(adClicked:title:)])
    {
        [self.delegate adClicked:self.m_TopicDetail.m_adUrl title:self.m_TopicDetail.m_adTitle];
    }
}

#pragma mark -
#pragma mark BTN Func

- (void)replyTopic:(id)sender
{
    [MobClick event:@"discuz_v2" label:@"楼层-回复图标"];
    if ([self.delegate respondsToSelector:@selector(replyFloorDelegate:withReplyID:)])
    {
        [self.delegate replyFloorDelegate:self.m_TopicDetail.m_TopicInfor.m_Floor withReplyID:self.m_TopicDetail.m_TopicInfor.m_ReplyID];
    }
}

#pragma mark 发送 赞 回调

- (void)loveTopicFinished:(ASIHTTPRequest *)request
{
    [m_ActivityView stopAnimating];
    isSendingLove = NO;
    
    NSString *responseString = [request responseString];
    NSDictionary *dictData = [responseString objectFromJSONString];
    
    if (![dictData isDictionaryAndNotEmpty])
    {
        m_ReplyBtn.userInteractionEnabled = YES;
        return;
    }
    else
    {
        NSString *status = [dictData stringForKey:@"status"];
        NSDictionary *numberDic = [dictData dictionaryForKey:@"data"];
        if ([numberDic isDictionaryAndNotEmpty] && ([status isEqualToString:@"success"] || [status isEqualToString:@"0"]))
        {            
            self.m_TopicDetail.m_TopicInfor.m_IsLoved = [numberDic boolForKey:@"had_praised"];
            [self freshLoveButtomWidthWithNumber:[numberDic intForKey:@"praise_count"]];
            //NSLog(@"assssss__%@____%@",[numberDic stringForKey:@"had_praised"],[numberDic stringForKey:@"praise_count"]);
            
            [self playLoveAnimation];
        }
        else
        {
            m_ReplyBtn.userInteractionEnabled = YES;
        }
    }
}

- (void)loveTopicFail:(ASIHTTPRequest *)request
{
    isSendingLove = NO;
    [m_ActivityView stopAnimating];
    m_ReplyBtn.userInteractionEnabled = YES;
}


@end
