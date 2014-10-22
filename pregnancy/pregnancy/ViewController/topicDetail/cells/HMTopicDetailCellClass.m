//
//  HMTopicDetailCellClass.m
//  lama
//
//  Created by mac on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicDetailCellClass.h"
#import "BBUser.h"
#import "BBTimeUtility.h"
#import "EmojiLabel.h"
#import "BBAppInfo.h"
#import "ARCHelper.h"
#import "BBAdModel.h"

#import "GDTMobBannerView.h"
#import "BaiduMobAdView.h"

@implementation HMTopicDetailCellClass
@synthesize m_Type;
@synthesize m_LinkType;
@synthesize m_Height;
@synthesize m_TopicInfor;
@synthesize m_ReplyInfor;
@synthesize m_LocalCity;
@synthesize m_PublishTime;

@synthesize m_LinkUseBtn;
@synthesize m_LinkUrl;
@synthesize m_LinkTopicId;

@synthesize m_Text;
@synthesize m_ELabelDataArray;

@synthesize m_PreImageUrl;
@synthesize m_ImageUrl;
@synthesize m_ImageIndex;


+ (NSString *)getImageHeight:(NSDictionary *)imageLinkDic
{
    NSString *height_str;
    
    height_str = [imageLinkDic stringForKey:@"small_height"];
    
    if (![height_str isNotEmpty])
    {
        return nil;
    }
    
    return height_str;
}

+ (NSString *)getImageWidth:(NSDictionary *)imageLinkDic
{
    NSString *width_str;
    width_str = [imageLinkDic stringForKey:@"small_width"];
    
    if (![width_str isNotEmpty])
    {
        return nil;
    }
    
    return width_str;
}


- (void)dealloc
{
    [m_TopicInfor ah_release];
    [m_ReplyInfor ah_release];
    [m_LocalCity ah_release];
    [m_PublishTime ah_release];
    
    
    [m_LinkUrl ah_release];
    [m_LinkTopicId ah_release];
    
    [m_Text ah_release];
    [m_ELabelDataArray ah_release];
    
    [m_PreImageUrl ah_release];
    [m_ImageUrl ah_release];
    
    [_m_adImg ah_release];
    [_m_adMonitor ah_release];
    [_m_adBannerid ah_release];
    [_m_adUrl ah_release];
    [_m_adZoneid ah_release];
    [_m_adTitle ah_release];
    [_m_adStatus ah_release];
    [_m_adUnion ah_release];
    
    [super ah_dealloc];
}

- (id)initWithData:(NSDictionary *)dic topicInfor:(HMNewTopicInfor *)topicInfor masterID:(NSString *)masterID
{
    self = [super init];
    
    if (self)
    {
        // Initialization code
        self.m_TopicInfor = topicInfor;
        [self makeData:dic masterID:masterID];
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)dic topicInfor:(HMNewTopicInfor *)topicInfor masterID:(NSString *)masterID replyInfor:(HMNewReplyInfor *)replyInfor
{
    self = [super init];
    
    if (self)
    {
//        if ([BBAppInfo openOldTopicDetail])
        {
            // Initialization code
            self.m_Type = TOPICDETAILCELL_REPLYCONTENT_TYPE;
            
            self.m_TopicInfor = topicInfor;
            self.m_ReplyInfor = replyInfor;
            
            if ([self.m_TopicInfor.m_UserId isEqualToString:masterID])
            {
                self.m_TopicInfor.m_IsMaster = YES;
            }
            else
            {
                self.m_TopicInfor.m_IsMaster = NO;
            }
            self.m_Height = 48;
            
            if ([self.m_ReplyInfor.m_ContentText isNotEmpty])
            {
                CGSize size = [self.m_ReplyInfor.m_ContentText sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(270, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
                
                CGFloat height = size.height;
                
                if (height > 36)
                {
                    height = 36;
                }
                
                self.m_Height += height;
            }
        }
    }
    
    return self;
}

- (void)makeData:(NSDictionary *)dic masterID:(NSString *)masterID
{
    self.m_Type = TOPICDETAILCELL_NONE_TYPE;
    
    NSDictionary *contentData = dic;
    NSString *tag = [dic stringForKey:@"tag"];
    
    if ([tag isEqualToString:@"discussion_header"])
    {
        self.m_Type = TOPICDETAILCELL_MASTERHEADER_TYPE;
    }
    else if ([tag isEqualToString:@"reply_header"])
    {
        self.m_Type = TOPICDETAILCELL_REPLYHEADER_TYPE;
    }
    else if ([tag isEqualToString:@"discussion_footer"])
    {
        self.m_Type = TOPICDETAILCELL_MASTERFLOOR_TYPE;
    }
    else if ([tag isEqualToString:@"reply_footer"])
    {
        self.m_Type = TOPICDETAILCELL_REPLYFLOOR_TYPE;
    }
    else if ([tag isEqualToString:@"text"])
    {
        self.m_Type = TOPICDETAILCELL_TEXTCONTENT_TYPE;
    }
    else if ([tag isEqualToString:@"img"])
    {
        self.m_Type = TOPICDETAILCELL_IMAGECONTENT_TYPE;
    }
    else if ([tag isEqualToString:@"emoji"])
    {
        self.m_Type = TOPICDETAILCELL_EMOJI_TYPE;
    }
    else if ([tag isEqualToString:@"face"])
    {
        self.m_Type = TOPICDETAILCELL_FACE_TYPE;
    }
    else if ([tag isEqualToString:@"a"])
    {
        NSDictionary *content = [dic dictionaryForKey:@"content"];
        contentData = content;
        
        NSString *contentTag = [content stringForKey:@"tag"];
        
        if ([contentTag isEqualToString:@"text"])
        {
            self.m_Type = TOPICDETAILCELL_TEXTLINK_TYPE;
        }
        else if ([contentTag isEqualToString:@"img"])
        {
            self.m_Type = TOPICDETAILCELL_IMAGELINK_TYPE;
        }
        
        NSString *contentType = [dic stringForKey:@"type"];
        if ([contentType isEqualToString:@"topic"])
        {
            self.m_LinkType = HMTopicDetailCellView_LinkType_Message;
            self.m_LinkTopicId = [dic stringForKey:@"topic_id"];
        }
        else
        {
            self.m_LinkType = HMTopicDetailCellView_LinkType_Out;
            self.m_LinkUrl = [dic stringForKey:@"href"];
        }
    }
    
    if ([self.m_TopicInfor.m_UserId isEqualToString:masterID])
    {
        self.m_TopicInfor.m_IsMaster = YES;
    }
    else
    {
        self.m_TopicInfor.m_IsMaster = NO;
    }

    switch (m_Type)
    {
        case TOPICDETAILCELL_MASTERHEADER_TYPE:
            [self makeHeader:contentData isMaster:YES];
            break;
            
        case TOPICDETAILCELL_REPLYHEADER_TYPE:
            [self makeHeader:contentData isMaster:NO];
            break;
            
        case TOPICDETAILCELL_MASTERFLOOR_TYPE:
        case TOPICDETAILCELL_REPLYFLOOR_TYPE:
            [self makeFloor:contentData];
            break;
            
        case TOPICDETAILCELL_TEXTCONTENT_TYPE:
        case TOPICDETAILCELL_TEXTLINK_TYPE:
            [self makeText:contentData];
            break;

        case TOPICDETAILCELL_IMAGECONTENT_TYPE:
        case TOPICDETAILCELL_IMAGELINK_TYPE:
            [self makeImage:contentData];
            break;
            
        case TOPICDETAILCELL_EMOJI_TYPE:
            [self makeEmoji:contentData];
            break;
            
        case TOPICDETAILCELL_FACE_TYPE:
            [self makeFace:contentData];
            break;
            
        default:
            break;
    }
}


- (void)makeHeader:(NSDictionary *)dic isMaster:(BOOL)isMaster
{
    self.m_Height = TOPICDETAILCELLTOPVIEW_HEIGHT;
    
    NSString *publishTime = [dic stringForKey:@"create_ts"];
    if (!publishTime)
    {
        publishTime = @"";
    }
    else
    {
        publishTime = [BBTimeUtility stringDateWithPastTimestampDetail:[publishTime doubleValue]];
    }
    self.m_PublishTime = publishTime;

    if (isMaster)
    {
        self.m_TopicInfor.m_Floor = @"0";
    }
}

- (void)makeFloor:(NSDictionary *)dic
{
    NSString *localCity = [dic stringForKey:@"city_name" defaultString:@""];
    self.m_LocalCity = localCity;
    
    NSString *publishTime = [dic stringForKey:@"create_ts"];
    if (!publishTime)
    {
        publishTime = @"";
    }
    else
    {
        publishTime = [BBTimeUtility stringDateWithPastTimestampDetail:[publishTime doubleValue]];
    }
    
    self.m_PublishTime = publishTime;
    
    self.m_Height = TOPICDETAILCELLFLOORVIEW_HEIGHT;
    
    if (self.m_Type == TOPICDETAILCELL_MASTERFLOOR_TYPE)
    {
        NSDictionary *adDic = [dic dictionaryForKey:@"ad"];
        if (adDic)
        {
            self.m_adStatus = [adDic stringForKey:AD_DICT_STATUS_KEY];
            if ([self.m_adStatus isEqual:@"babytree"])
            {
                self.m_adImg = [adDic stringForKey:AD_DICT_NORMAL_IMG_KEY];
                self.m_adUrl = [adDic stringForKey:AD_DICT_URL_KEY];
                self.m_adMonitor = [adDic stringForKey:AD_DICT_MONITOR_KEY];
                self.m_adBannerid = [adDic stringForKey:AD_DICT_BANNERID_KEY];
                self.m_adZoneid = [adDic stringForKey:AD_DICT_ZONEID_KEY];
                self.m_adTitle = [adDic stringForKey:AD_DICT_TITLE_KEY defaultString:@"推广"];

                if ([self.m_adImg isNotEmpty])
                {
                    self.m_Height = self.m_Height + TOPICDETAILCELLFLOOR_AD_EDGE*2 + TOPICDETAILCELLFLOOR_AD_HEIGHT - 16;
                }
            }
            else if ([self.m_adStatus isEqual:@"other"])
            {
                self.m_adUnion = [adDic stringForKey:AD_DICT_UNION_KEY];
                if ([self.m_adUnion isEqual:@"gdt"])
                {
                    self.m_Height = self.m_Height + TOPICDETAILCELLFLOOR_AD_EDGE*2 + GDTMOB_AD_SIZE_320x50.height - 16;
                }
                if ([self.m_adUnion isEqual:@"baidu"])
                {
                    self.m_Height = self.m_Height + TOPICDETAILCELLFLOOR_AD_EDGE*2 + kBaiduAdViewSizeDefaultHeight - 16;
                }
            }
        }
    }
}

- (void)makeText:(NSDictionary *)dic
{
    NSString *text = [dic stringForKey:@"text" defaultString:@""];
    
    text = [text trim];
    
    self.m_Text = text;
    
    self.m_LinkUseBtn = NO;
    
    if (self.m_LinkType > HMTopicDetailCellView_LinkType_None)
    {
        NSRange rang = [text rangeOfString:@"http:"];
        if (rang.location != NSNotFound)
        {
            self.m_LinkUseBtn = YES;
        }
        else
        {
            NSRange rang = [text rangeOfString:@".com/"];
            if (rang.location != NSNotFound)
            {
                self.m_LinkUseBtn = YES;
            }
            else
            {
                NSRange rang = [text rangeOfString:@".cn/"];
                if (rang.location != NSNotFound)
                {
                    self.m_LinkUseBtn = YES;
                }
                else
                {
                    NSRange rang = [text rangeOfString:@".net/"];
                    if (rang.location != NSNotFound)
                    {
                        self.m_LinkUseBtn = YES;
                    }
                }
            }
        }
    }
    
    //[self calcTextHeight];
}

- (void)calcTextHeight
{
    if (m_LinkUseBtn)
    {
        self.m_Height = TOPICDETAILCELL_TEXTLINKBTN_HEIGHT + TOPICDETAILCELL_GAP;
        return;
    }
    
    self.m_ELabelDataArray = [EmojiLabel parserText:m_Text withFont:TOPIC_CONTENT_TEXT_FONT maxWidth:320-TOPIC_ALL_EDGE_DISTANCE*2];
    
    if (m_ELabelDataArray.count)
    {
        EmojiLabelData *emojiLabelData = [m_ELabelDataArray lastObject];
    
        CGRect rect = emojiLabelData.m_Rect;
        CGFloat hei = rect.origin.y + rect.size.height;
        
        self.m_Height = hei + TOPICDETAILCELL_GAP - 4;
    }
    else
    {
        self.m_Height = 0;
    }
}


- (void)makeImage:(NSDictionary *)dic
{
    self.m_ImageHeight = 0;
    self.m_ImageWidth = 0;
    
    NSString *small_height = [HMTopicDetailCellClass getImageHeight:dic];
    if ([small_height isNotEmpty])
    {
        NSString *small_width = [HMTopicDetailCellClass getImageWidth:dic];
        
        if ([small_width isNotEmpty])
        {
            CGFloat height = [small_height doubleValue];
            CGFloat width = [small_width doubleValue];
            
            if (height != 0 && width != 0)
            {
                CGFloat scale = (height / TOPICDETAILCELL_IMAGE_MAXWIDTH) > (width / TOPICDETAILCELL_IMAGE_MAXHEIGHT) ? (height / TOPICDETAILCELL_IMAGE_MAXWIDTH) : (width / TOPICDETAILCELL_IMAGE_MAXHEIGHT);
                
                if (scale > 1)
                {
                    height /= scale;
                    width /= scale;
                }
                
                self.m_ImageHeight = height;
                self.m_ImageWidth = width;
            }
        }
    }
    else
    {
        self.m_ImageHeight = TOPICDETAILCELL_IMAGE_DEFAULTHEIGHT;
        self.m_ImageWidth = TOPICDETAILCELL_IMAGE_DEFAULTWIDTH;
    }

    self.m_PreImageUrl = [dic stringForKey:@"small_src"];

    self.m_ImageUrl = [dic stringForKey:@"b_src"];
    
    if (!m_ImageUrl)
    {
        self.m_ImageUrl = m_PreImageUrl;
    }
    
    self.m_Height = self.m_ImageHeight + TOPICDETAILCELL_GAP;
}

- (void)makeEmoji:(NSDictionary *)dic
{
    self.m_Type = TOPICDETAILCELL_TEXTCONTENT_TYPE;
    self.m_Text = [dic stringForKey:@"key"];
    
    //[self calcTextHeight];
}

- (void)makeFace:(NSDictionary *)dic
{
    self.m_Type = TOPICDETAILCELL_TEXTCONTENT_TYPE;
    NSString *url = [dic stringForKey:@"url"];
    
    if ([url isNotEmpty])
    {
        url = [url getFileName];
        
#if (0)
        NSRange rangedot = [url rangeOfString:@"."];
        if (rangedot.location != NSNotFound)
        {
            url = [url substringWithRange:NSMakeRange(0, rangedot.location)];
        }

        //url = [url stringByReplacingOccurrencesOfString:@".gif" withString:@".png"];
        
        NSRange rang = [url rangeOfString:@"mika"];
        if (rang.location == NSNotFound)
        {
            url = [NSString stringWithFormat:@"<img src=\"bundle://doubao/%@\"/>", url];
        }
        else
        {
            url = [NSString stringWithFormat:@"<img src=\"bundle://mika/%@\"/>", url];
        }
#else
        url = [NSString stringWithFormat:@"<%@>", url];
#endif
    }
    else
    {
        url = @"";
    }
    self.m_Text = url;
    
    //[self calcTextHeight];
}

@end


@implementation HMNewTopicInfor

@synthesize m_IsLoved;
@synthesize totalLoveTime;

@synthesize m_IsMaster;
@synthesize m_IsAdmin;
@synthesize m_UserId;
@synthesize m_UserName;
@synthesize m_UserIcon;
@synthesize m_Floor;
@synthesize m_ContentText;
@synthesize m_BabyAge;
@synthesize m_ReplyID;
@synthesize m_UserSign;

- (void)dealloc
{
    [m_UserId ah_release];
    [m_UserName ah_release];
    [m_UserIcon ah_release];
    [m_Floor ah_release];
    [m_BabyAge ah_release];
    [m_ContentText ah_release];
    
    [m_ReplyID ah_release];
    [m_UserSign ah_release];
    
    [super ah_dealloc];
}

@end


@implementation HMNewReplyInfor
@synthesize m_Position;
@synthesize m_UserId;
@synthesize m_UserName;
@synthesize m_UserIcon;

@synthesize m_ContentText;

@synthesize m_HavePic;

@synthesize m_ShowAll;

- (void)dealloc
{
    [m_Position ah_release];
    [m_UserId ah_release];
    [m_UserName ah_release];
    [m_UserIcon ah_release];
    
    [m_ContentText ah_release];
    
    [super ah_dealloc];
}

@end