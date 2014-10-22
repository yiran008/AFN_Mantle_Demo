//
//  EmojiLable.h
//  KeyBoardTest
//
//  Created by sxf on 13-8-7.
//  Copyright (c) 2012年 __babytree__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Prefix @"<"
#define Suffix @">"

#define EMOJILABLE_DEFAULT_FONT [UIFont systemFontOfSize:18]


typedef enum
{
    LINETEXT_NULL_TYPE = 0,         //没有任何内容
    LINETEXT_TEXT_TYPE = 1,         //只有文本
    LINETEXT_PIC_TYPE  = 2,         //只有图片
    LINETEXT_TEXTANDPIC_TYPE        //图文并有
} LINETEXTTYPE;


@interface EmojiLabel : UIView

// 文本
@property (nonatomic, retain) NSString *m_text;
// 正常文本颜色
@property (nonatomic, retain) UIColor *m_textColor;
// 高亮文本颜色
@property (nonatomic, retain) UIColor *m_highColor;
// 高亮文本
@property (nonatomic, assign) BOOL m_isHighlight;
// 字体
@property (nonatomic, retain) UIFont *m_font;
// 文本字体大小
@property (nonatomic, assign) CGFloat m_fontSize;

// 行间距  解释:上行文字的底部与下行文字的顶部之间的距离  绘制规则:每行文字绘制时候上、下各留出一半的空隙
@property (nonatomic, assign) CGFloat m_lineSpacing;

// 行数限制
@property (nonatomic, assign) NSInteger m_numberofLines;

@property (nonatomic, retain) NSMutableArray *m_DataArray;

+ (NSArray *)parserText:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
// maxLines限制行数, 0表示不限制行数
+ (NSArray *)parserText:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxLines:(NSInteger)maxLines;

// 在行前加lineSpace文字置底, 未完成不可用
//+ (NSArray *)parserText:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxLines:(NSInteger)maxLines lineSpace:(CGFloat)lineSpace;

- (void)sizeToFit;

- (CGPoint)lastPoint;
- (CGFloat)lastHeight;
- (CGRect)lastRect:(CGFloat)width;

@end



typedef enum
{
    EmojiLabelText = 0,
    EmojiLabelImage,
    EmojiLabelGif
} EmojiLabelDataType;


@interface EmojiLabelData : NSObject
// 类型
@property (nonatomic, assign) EmojiLabelDataType m_Type;
// 文本
@property (nonatomic, retain) NSString *m_Text;
// 图
@property (nonatomic, retain) UIImage *m_Image;

// rect
@property (nonatomic, assign) CGRect m_Rect;


// 行高
@property (nonatomic, assign) CGFloat m_LineHeight;

// 最后坐标
@property (nonatomic, assign) CGPoint m_LastPoint;

// 行数
@property (nonatomic, assign) NSInteger m_Lines;
// 行数范围
@property (nonatomic, assign) NSInteger m_StartLine;
@property (nonatomic, assign) NSInteger m_EndLine;

@property (nonatomic, retain) UIColor *m_Color;


- (void)setImageName:(NSString *)name;

@end

