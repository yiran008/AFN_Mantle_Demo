//
//  HMEmptyView.m
//  lama
//
//  Created by Heyanyang on 13-7-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMNoDataView.h"

@implementation HMNoDataView
@synthesize delegate;

- (void)dealloc
{
    [_m_PromptText release];
    [_m_PromptImage release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = UI_VIEW_BGCOLOR;
    }
    return self;
}

//thePicTypeNum是icon图片类型，thePromptWords是提示文字内容。
- (id)initWithType:(HMNODATAVIEW_TYPE)type
{
    self = [super init];
    
    if (self)
    {
        self.frame = UI_WHOLE_SCREEN_FRAME;

        s_ImageView = [[[UIImageView alloc] init] autorelease];
        s_ImageView.frame = CGRectMake(0, 0, HMNODATA_DEFAULT_IMAGEWIDTH, HMNODATA_DEFAULT_IMAGEHEIGHT);
        [self addSubview:s_ImageView];
        if (IS_IPHONE5)
        {
            [s_ImageView centerHorizontallyInSuperViewWithTop:HMNODATA_DEFAULT_TOPGAPIPHONE5];
            _m_OffsetY = HMNODATA_DEFAULT_TOPGAPIPHONE5;
        }
        else
        {
            [s_ImageView centerHorizontallyInSuperViewWithTop:HMNODATA_DEFAULT_TOPGAP];
            _m_OffsetY = HMNODATA_DEFAULT_TOPGAP;
        }
        
        s_Label = [[[UILabel alloc] initWithFrame:CGRectMake(20, s_ImageView.bottom+4, 280, 60)] autorelease];
        s_Label.font = [UIFont systemFontOfSize:14];
        s_Label.textColor = [UIColor colorWithHex:0x999999];
        s_Label.textAlignment = NSTextAlignmentCenter;
        s_Label.backgroundColor = [UIColor clearColor];
        s_Label.numberOfLines = 3;
        [self addSubview:s_Label];
        
        s_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        s_Btn.frame = CGRectMake(105, s_Label.bottom+10, 110, 36);
        [s_Btn setTitle:@"刷新" forState:UIControlStateNormal];
        [s_Btn setBackgroundImage:[UIImage imageNamed:@"nodata_btn"] forState:UIControlStateNormal];
        s_Btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [s_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [s_Btn addTarget:self action:@selector(freshPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:s_Btn];
        s_Btn.exclusiveTouch = YES;
        
        self.m_Type = type;
    }
    
    return self;
}

- (NSString *)getMessage:(HMNODATA_MESSAGE)messageId
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HMNoDataView"
                                                          ofType:@"plist"];


    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    
    if (messageId == HMNODATAMESSAGE_NONE)
    {
        messageId = HMNODATAMESSAGE_PROMPT_COM;
    }
    
    if (messageId < array.count)
    {
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@", array[messageId]];
        [str replaceOccurrencesOfString:@"\\n" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
        return str;
    }

    return @"";
}

- (void)freshWithType:(HMNODATAVIEW_TYPE)type
{
    self.m_PromptText = @"";
    self.m_ShowBtn = NO;

    switch (type)
    {
            // 网络或服务器问题
        case HMNODATAVIEW_NETERROR:
            self.m_PromptText = [self getMessage:HMNODATAMESSAGE_NETERROR];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            self.m_ShowBtn = YES;
            break;

        case HMNODATAVIEW_DATAERROR:
            self.m_PromptText = [self getMessage:HMNODATAMESSAGE_DATAERROR];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            self.m_ShowBtn = YES;
            break;

            // 通用无数据
        case HMNODATAVIEW_PROMPT:
            self.m_PromptText = [self getMessage:self.m_MessageType];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            break;
            
            // 圈子
        case HMNODATAVIEW_CIRCLE:
            self.m_PromptText = [self getMessage:self.m_MessageType];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            break;
            
            // 关注-无人
        case HMNODATAVIEW_FOLLOW:
            self.m_PromptText = [self getMessage:self.m_MessageType];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            break;

            // 收藏
        case HMNODATAVIEW_FAVORITE:
            self.m_PromptText = [self getMessage:HMNODATAMESSAGE_FAVORITE];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            break;
            
            // 消息
        case HMNODATAVIEW_MESSAGE:
            self.m_PromptText = [self getMessage:self.m_MessageType];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            break;

            // 话题
        case HMNODATAVIEW_TOPIC:
            self.m_PromptText = [self getMessage:self.m_MessageType];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_topic"];
            break;

            // 回复
        case HMNODATAVIEW_REPLY:
            self.m_PromptText = [self getMessage:self.m_MessageType];
            self.m_PromptImage = [UIImage imageNamed:@"nodata_neterror"];
            break;

            // 自定义
        case HMNODATAVIEW_CUSTOM:
        default:
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (HMNODATAVIEW_TYPE)m_Type
{
    return _m_Type;
}

- (void)setM_Type:(HMNODATAVIEW_TYPE)type
{
    _m_Type = type;
    
    [self freshWithType:type];
}

- (NSString *)m_PromptText
{
    return _m_PromptText;
}

- (void)setM_PromptText:(NSString *)promptText
{
    if ([_m_PromptText isEqualToString:promptText])
    {
        return;
    }
    
    [_m_PromptText release];
    
    _m_PromptText = [promptText retain];
    
    s_Label.text = _m_PromptText;
}

- (UIImage *)m_PromptImage
{
    return _m_PromptImage;
}

- (void)setM_PromptImage:(UIImage *)promptImage
{
    if ([_m_PromptImage isEqual:promptImage])
    {
        return;
    }
    
    [_m_PromptImage release];
    
    _m_PromptImage = [promptImage retain];
    
    s_ImageView.image = _m_PromptImage;
}

- (BOOL)m_ShowBtn
{
    return _m_ShowBtn;
}

- (void)setM_ShowBtn:(BOOL)showBtn
{
    _m_ShowBtn = showBtn;
    
    s_Btn.hidden = !showBtn;
}


- (CGFloat)m_OffsetY
{
    return _m_OffsetY;
}

- (void)setM_OffsetY:(CGFloat)offsetY
{
    _m_OffsetY = offsetY;
    
    s_ImageView.top = offsetY;
    s_Label.top = s_ImageView.bottom+20;
    s_Btn.top = s_Label.bottom+10;
}

- (void)freshPress
{
    if ([self.delegate respondsToSelector:@selector(freshFromNoDataView)])
    {
        [self.delegate freshFromNoDataView];
    }
}

@end
