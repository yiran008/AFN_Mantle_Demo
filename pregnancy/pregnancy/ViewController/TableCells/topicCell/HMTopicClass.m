//
//  HMTopicCellClass.m
//  lama
//
//  Created by mac on 13-12-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMTopicClass.h"
//!!!:bbbbbbb
//#import "HMUser.h"
#import "HMMulImageView.h"



#define TOPIC_CELL_GAP                      8.0f


#define TOPICCELL_IMAGE_DEFAULTWIDTH        200.0f
#define TOPICCELL_IMAGE_DEFAULTHEIGHT       200.0f

#define TOPICCELL_IMAGE_MAXWIDTH            300.0f
#define TOPICCELL_IMAGE_MAXHEIGHT           300.0f

#define TOPIC_BOTTOM_HEIGHT                 32.0f


@implementation HMTopicClass
// 标签
@synthesize m_Mark;
// 话题ID
@synthesize m_TopicId;
// 标题
@synthesize m_Title;
// 摘要
@synthesize m_Summary;
@synthesize m_PicArray;
@synthesize m_ImageHeight;
@synthesize m_ImageWidth;
@synthesize m_PicHeight;
@synthesize m_PicWidth;

// 圈子ID
@synthesize m_CircleId;
// 圈子名称
@synthesize m_CircleName;
// 隐私圈子
@synthesize m_CircleIsPrivate;
// 楼主Id
@synthesize m_MasterId;
// 楼主昵称
@synthesize m_MasterName;
// 楼主头像
@synthesize m_MasterImage;
// 回复数
@synthesize m_ResponseCount;
// 创建时间
@synthesize m_CreateTime;
// 修改时间
//@synthesize m_UpdateTime;
// 最后回复时间
@synthesize m_ResponseTime;

// 赞次数
@synthesize m_PraiseCount;
// 是否赞过
@synthesize m_IsPraised;

// 收藏
@synthesize m_IsFavourite;

// 回复楼层
@synthesize m_Floor;

@synthesize m_ReplyID;


// title行数
@synthesize m_TitleLines;
// summary行数
@synthesize m_SummaryLines;

// 显示圈子
@synthesize m_ShowCircle;
// 无图模式
@synthesize m_IsPicType;

@synthesize m_CellHeight = _m_CellHeight;
@synthesize m_CellShortHeight = _m_CellShortHeight;

@synthesize m_UserSign;

+ (NSString *)getImageHeight:(NSDictionary *)imageLinkDic
{
    NSString *height_str;
    
    height_str = [imageLinkDic stringForKey:@"small_height"];
    
    if (![height_str isNotEmpty])
    {
        return nil;
    }
    
    return height_str;

 /*
    HMUserInfor *userInfor = [HMUser UserInfor];

    NSString *height_str;

    if ([userInfor is3G])
    {
        height_str = [imageLinkDic stringForKey:@"tiny_height"];
    }
    else
    {
        height_str = [imageLinkDic stringForKey:@"small_height"];
    }

    if (![height_str isNotEmpty])
    {
        return nil;
    }

    return height_str;
  */
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
  
   /*
    HMUserInfor *userInfor = [HMUser UserInfor];

    NSString *width_str;

    if ([userInfor is3G])
    {
        width_str = [imageLinkDic stringForKey:@"tiny_width"];
    }
    else
    {
        width_str = [imageLinkDic stringForKey:@"small_width"];
    }

    if (![width_str isNotEmpty])
    {
        return nil;
    }

    return width_str;
    */
}

- (id)init
{
    self = [super init];

    if (self)
    {
        m_TitleLines = 1;
    }

    return self;
}

- (void)calcHeight
{
    CGFloat height = TOPIC_CELL_GAP;
    CGFloat sheight = height;

    NSString *title = [NSString spaceWithFont:[UIFont systemFontOfSize:16.0f] top:NO new:(self.m_Mark & TopicMark_New) best:(self.m_Mark & TopicMark_Extractive) help:(self.m_Mark & TopicMark_Help) pic:(self.m_Mark & TopicMark_HasPic) add:0];

    title = [NSString stringWithFormat:@"%@%@", title, self.m_Title];

    CGSize size;

    if (IOS_VERSION < 7.0)
    {
        size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f]];
    }
    else
    {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f]};
        size = [title sizeWithAttributes:attributes];
    }
    
    CGFloat width = 300;
    if (self.m_Mark & TopicMark_Extractive)
    {
        width = 322;
    }
    
    if (self.m_Mark & TopicMark_Help && self.m_Mark & TopicMark_Extractive)
    {
        width = 331;
    }
    
    if (size.width >= width)
    {
        self.m_TitleLines = 2;
        height += TOPIC_CELL_TITLE_TWOLINE_HEIGHT;
    }
    else
    {
        self.m_TitleLines = 1;
        height += TOPIC_CELL_TITLE_ONELINE_HEIGHT;
    }

    sheight = height;

    self.m_ImageHeight = 0;
    self.m_ImageWidth = 0;

    if (self.m_PicArray.count < 3 && self.m_PicArray.count > 0)
    {
        CGFloat height = self.m_PicHeight;
        CGFloat width = self.m_PicWidth;
        
        if (height > 0 && width > 0)
        {
            CGFloat scale = (height / TOPICCELL_IMAGE_MAXWIDTH) > (width / TOPICCELL_IMAGE_MAXHEIGHT) ? (height / TOPICCELL_IMAGE_MAXWIDTH) : (width / TOPICCELL_IMAGE_MAXHEIGHT);

            if (scale > 1)
            {
                height /= scale;
                width /= scale;
            }

            self.m_ImageHeight = height;
            self.m_ImageWidth = width;
        }
        else
        {
            self.m_ImageHeight = TOPICCELL_IMAGE_DEFAULTHEIGHT;
            self.m_ImageWidth = TOPICCELL_IMAGE_DEFAULTWIDTH;
        }
    }
    else if (self.m_PicArray.count >= 3)
    {
        self.m_ImageHeight = 200;
        self.m_ImageWidth = 300;
    }

    if (self.m_ImageWidth != 0)
    {
        height += self.m_ImageHeight + HMMulImageView_DefaultGap*2;
    }

    _m_CellHeight = height + TOPIC_BOTTOM_HEIGHT + 2;
    _m_CellShortHeight = sheight + TOPIC_BOTTOM_HEIGHT + 2;
}

- (CGFloat)m_CellHeight
{
    if (_m_CellHeight == 0)
    {
        [self calcHeight];
    }

    return _m_CellHeight;
    
//    if (self.m_IsPicType)
//    {
//        return _m_CellHeight;
//    }
//    else
//    {
//        return _m_CellShortHeight;
//    }
}

- (CGFloat)m_CellShortHeight
{
    if (_m_CellShortHeight == 0)
    {
        [self calcHeight];
    }

    return _m_CellShortHeight;
}

- (void)setM_Summary:(NSString *)summary
{
    if (m_Summary != summary)
    {
        m_Summary = [summary trim];
    }
}

-(void)setM_TitleArr:(NSArray *)titleArr
{
    self.m_Title = [self stringWithArr:titleArr];
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:self.m_Title];
    NSInteger curLeng = 0;
    for (NSInteger i=0; i<[titleArr count]; i++)
    {
        NSDictionary *dic = [titleArr objectAtIndex:i];
        NSString *str = [dic stringForKey:@"text"];
        
        NSInteger nextLenth = str.length;
        if (nextLenth + curLeng > mutaString.length)
        {
            nextLenth = mutaString.length - curLeng;
        }
        
        if ([[dic stringForKey:@"tag"] isEqualToString:@"hl"])
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHex:0xff537b]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        else
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor blackColor]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        curLeng += nextLenth;
    }
    self.m_TitleAttribut = mutaString;
}

- (NSString *)stringWithArr:(NSArray *)arr
{
    NSMutableString *str = [NSMutableString string];
    for (NSInteger i=0; i<[arr count]; i++)
    {
        NSDictionary *dic = [arr objectAtIndex:i];
        [str appendString:[dic stringForKey:@"text"]];
    }
    return str;
}

@end
