//
//  HMEmptyView.h
//  lama
//
//  Created by Heyanyang on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HMNODATA_DEFAULT_TOPGAP         40.0f
#define HMNODATA_DEFAULT_TOPGAPIPHONE5  60.0f
#define HMNODATA_DEFAULT_IMAGEWIDTH     194.0f
#define HMNODATA_DEFAULT_IMAGEHEIGHT    148.0f

//类型枚举
typedef enum
{
    // 自定义
    HMNODATAVIEW_CUSTOM,
    // 网络或服务器问题
    HMNODATAVIEW_NETERROR,
    HMNODATAVIEW_DATAERROR,
    // 通用无数据
    HMNODATAVIEW_PROMPT,
    // 圈子
    HMNODATAVIEW_CIRCLE,
    // 关注-无人-无话题
    HMNODATAVIEW_FOLLOW,
    // 收藏
    HMNODATAVIEW_FAVORITE,
    // 消息
    HMNODATAVIEW_MESSAGE,
    // 话题
    HMNODATAVIEW_TOPIC,
    // 回复
    HMNODATAVIEW_REPLY

} HMNODATAVIEW_TYPE;

//提示语枚举，详见HMNoDataView.plist
typedef enum
{
    //
    HMNODATAMESSAGE_NONE,

    // 网络不给力,\n辣妈也会力不从心(>_<)
    HMNODATAMESSAGE_NETERROR,
    // 数据错误, \n请稍后再试(>_<!)
    HMNODATAMESSAGE_DATAERROR,

    // 这里还什么都木有...
    HMNODATAMESSAGE_PROMPT_COM,
    // 亲还木有粉丝哟~\n现在就去邀请好友来粉你吧!
    HMNODATAMESSAGE_PROMPT_FANS,
    // 她还木有粉丝哟~
    HMNODATAMESSAGE_PROMPT_OFANS,
    // 555...找不到内容,\n换个关键词再试试吧~
    HMNODATAMESSAGE_PROMPT_SEARCH,
    // 亲的相册还木有靓照噢,\n赶快发表话题晒美图吧!
    HMNODATAMESSAGE_PROMPT_PHOTO,
    // 她的相册还木有靓照噢!
    HMNODATAMESSAGE_PROMPT_OPHOTO,
    // 亲还没有写草稿噢~
    HMNODATAMESSAGE_PROMPT_DRAFT,

    // 矮油~这里还没有圈子噢~
    HMNODATAMESSAGE_CIRCLE_NOCIRCLE,
    // 矮油~这里还没有圈子噢~\n点击右上角“+”,加入感兴趣的圈子吧
    HMNODATAMESSAGE_CIRCLE_MAIN,
    // 矮油~这里还没有圈子噢~\n到“更多圈”加入感兴趣的圈子吧
    HMNODATAMESSAGE_CIRCLE_MINE,
    // 矮油~她还没有圈子噢~
    HMNODATAMESSAGE_CIRCLE_OTHER,
    // 亲已经加入所有的圈子啦
    HMNODATAMESSAGE_CIRCLE_MORE,

    // 亲还木有关注的辣妈噢,\n不妨去“发现”达人榜看看吧!
    HMNODATAMESSAGE_FOUNDFOLLOW,
    // 亲还没有关注别人呢(⊙o⊙)
    HMNODATAMESSAGE_FOLLOW,
    // 她还没有关注别人呢(⊙o⊙)
    HMNODATAMESSAGE_OFOLLOW,

    // 矮油~亲还木有任何收藏噢!\n点下话题详情右上角滴五角星,\n就可以收藏啦!
    HMNODATAMESSAGE_FAVORITE,

    // 亲还木有私信记录噢, 点击辣妈头像,\n给喜欢的辣妈发条私信吧!
    HMNODATAMESSAGE_MESSAGE,
    // 亲还木有收到任何通知噢,\n赶快去圈子里发些好玩的话题吧!
    HMNODATAMESSAGE_NOTICE,

    // 你关注的辣妈\n暂时没有发布话题
    HMNODATAMESSAGE_FOLLOWTOPIC,
    // 矮油~亲还木有发表过任何话题噢!\n赶快去圈子里多发些好玩的话题吧!
    HMNODATAMESSAGE_PUBLISHTOPIC,
    // 矮油~她还木有发表过任何话题噢!
    HMNODATAMESSAGE_OPUBLISHTOPIC,

    // 亲还木有回复的记录噢~,\n赶快跟其他辣妈一起互动吧!
    HMNODATAMESSAGE_REPLYTOPIC,
    // 她还木有回复的记录噢~
    HMNODATAMESSAGE_OREPLYTOPIC

} HMNODATA_MESSAGE;

@protocol HMNoDataViewDelegate <NSObject>

@optional
- (void)freshFromNoDataView;

@end

@interface HMNoDataView : UIView
{
    HMNODATAVIEW_TYPE _m_Type;

    NSString *_m_PromptText;
    UIImage *_m_PromptImage;
    
    BOOL _m_ShowBtn;
    
    UIImageView *s_ImageView;
    UILabel *s_Label;
    UIButton *s_Btn;
    
    CGFloat _m_OffsetY;
}

@property (nonatomic, assign) id <HMNoDataViewDelegate> delegate;

@property (nonatomic, assign) HMNODATAVIEW_TYPE m_Type;
@property (nonatomic, assign) HMNODATA_MESSAGE m_MessageType;

@property (nonatomic, retain) NSString *m_PromptText;
@property (nonatomic, retain) UIImage *m_PromptImage;

@property (nonatomic, assign) BOOL m_ShowBtn;

@property (nonatomic, assign) CGFloat m_OffsetY;

- (NSString *)getMessage:(HMNODATA_MESSAGE)messageId;

- (id)initWithType:(HMNODATAVIEW_TYPE)type;

- (void)freshPress;

@end
