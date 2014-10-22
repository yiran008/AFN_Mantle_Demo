//
//  EmojiLable.m
//  KeyBoardTest
//
//  Created by sxf on 13-8-7.
//  Copyright (c) 2012年 __babytree__. All rights reserved.
//

#import "EmojiLabel.h"
#import "UIImage+GIF.h"
#import "NSData+GIF.h"
#import "ARCHelper.h"

#define KFacialSizeWidth    24
#define KFacialSizeHeight   24

#define OneLine_AddWidth    20

/*
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EMOJI_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define EMOJI_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif
*/

@interface EmojiLabel ()
+ (CGSize)getTextSize:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineHeight:(CGFloat)lineHeight;
@end

@implementation EmojiLabel
@synthesize m_font;
@synthesize m_highColor;
@synthesize m_isHighlight;
@synthesize m_text;
@synthesize m_textColor;
@synthesize m_fontSize;
@synthesize m_lineSpacing;
@synthesize m_numberofLines;

@synthesize m_DataArray;

-(void)dealloc
{
    [m_textColor ah_release];
    [m_highColor ah_release];
    [m_text ah_release];
    [m_font ah_release];
    
    [m_DataArray ah_release];
    
    [super ah_dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.m_textColor = [UIColor blackColor];
        self.m_highColor = [UIColor whiteColor];
        self.m_font = EMOJILABLE_DEFAULT_FONT;
        self.m_fontSize = [m_font lineHeight];
        self.m_lineSpacing = 0.0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }

    [super drawRect:rect];
    
    if (m_isHighlight)
    {
        [m_highColor set];
    }
    else
    {
        [m_textColor set];
    }

    for (NSInteger i=0; i<m_DataArray.count; i++)
    {
        EmojiLabelData *labelData = [m_DataArray objectAtIndex:i];
        
        if (labelData.m_Type > EmojiLabelText)
        {
            if (labelData.m_Type == EmojiLabelGif)
            {
                UIImageView *view=  [[[UIImageView alloc] init] ah_autorelease];
                view.image = labelData.m_Image;
                view.frame = labelData.m_Rect;
                // for test
                //view.left +=10;
                //view.width -=10;
                // end
                [self addSubview:view];
            }
            else
            {
                [labelData.m_Image drawInRect:labelData.m_Rect];
            }
        }
        else
        {
//            NSLog(@"******____%@", labelData);

            if (IOS_VERSION >= 7.0)
            {
                NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] ah_autorelease];
                paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                paragraphStyle.alignment = NSTextAlignmentLeft;
                // 必须hyphenationFactor = 1.0f，否则lineBreakMode = NSLineBreakByCharWrapping无效
                paragraphStyle.hyphenationFactor = 1.0f;
                paragraphStyle.firstLineHeadIndent = 0.0f;
                paragraphStyle.lineSpacing = 0.0f;
                paragraphStyle.paragraphSpacing = 0.0f;
                paragraphStyle.headIndent = 0.0f;
                paragraphStyle.minimumLineHeight = m_font.lineHeight+4;
                paragraphStyle.maximumLineHeight = labelData.m_LineHeight;
                

                NSDictionary *attributes = @{NSFontAttributeName : m_font,
                                             NSForegroundColorAttributeName : self.m_textColor,
                                             NSParagraphStyleAttributeName : paragraphStyle};

                CGRect rect = labelData.m_Rect;
                // for test
                //rect.size.height += 20;
                //rect.size.width += 20;
                [labelData.m_Text drawWithRect:rect options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            }
            else
            {
                [labelData.m_Text drawInRect:labelData.m_Rect withFont:m_font lineBreakMode:NSLineBreakByCharWrapping];
            }
        }
        
        // for test
//        CGRect frame = CGRectMake(labelData.m_LastPoint.x, labelData.m_LastPoint.y, 20, labelData.m_LineHeight);
//        UIView *view = [[[UIView alloc] initWithFrame:frame] ah_autorelease];
//        view.backgroundColor = [UIColor redColor];
//        [self addSubview:view];
//        
//        [[NSString stringWithFormat:@"%d", labelData.m_EndLine] drawInRect:frame withFont:m_font lineBreakMode:NSLineBreakByCharWrapping];
        // end
    }
}

-(void)setM_DataArray:(NSMutableArray *)array
{
    if ([m_DataArray isEqual:array])
    {
        return;
    }
    
    [m_DataArray ah_release];
    m_DataArray = array;
    
//    EmojiLableData *emojiLableData = [m_DataArray lastObject];
//    
//    CGRect rect = emojiLableData.m_Rect;
//    CGFloat hei = rect.origin.y + rect.size.height;
//    
//    self.height = hei;
    [self setNeedsDisplay];
}

+ (NSArray *)parserText:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [EmojiLabel parserText:text withFont:font maxWidth:maxWidth maxLines:0];
}


+ (NSArray *)parserText:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxLines:(NSInteger)maxLines
{
    // 测试用
    //maxLines = 0;

    //NSLog(@"%@", text);
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // 解析文本<>, 返回数据
    NSMutableArray *data = [[[NSMutableArray alloc] init] ah_autorelease];
    [EmojiLabel getImageRange:text :data];
    
    if (![data isNotEmpty])
    {
        return nil;
    }
    
    // 初始化EmojiLable解析结果数据
    NSMutableArray *dataArray = [NSMutableArray array];
    
    // 初始化单行高
    // 默认行高
    CGFloat defaultLineHeight = 0;
    defaultLineHeight = font.lineHeight+4;
    // 实际行高
    CGFloat lineHeight = defaultLineHeight;
    
    // 初始化行号
    NSInteger currentLine = 1;
    
    // 多行起始行号
    NSInteger startLine = 1;
   
    // 初始化起始原点坐标
    CGFloat orignX = 0;
    CGFloat orignY = 0;
    
    // 初始化相对于(0, 0)偏移坐标
    CGFloat upX = 0;
    CGFloat upY = 0;
    
    // 初始化最后坐标点--左上
    //CGPoint lastPoint = CGPointZero;
    
    // 初始化单行文本
    NSMutableString *appendStr = [NSMutableString stringWithCapacity:0];
    // 初始化多行文本
    NSMutableArray *lines = [[[NSMutableArray alloc] init] ah_autorelease];
    
    for (NSInteger i=0; i<[data count]; i++)
    {
        // 是否文本
        BOOL btext = YES;
        
        // 获取子字符串
        NSString *subStr = [data objectAtIndex:i];
        
        // 判断是否表情
        if ([subStr hasPrefix:Prefix] && [subStr hasSuffix:Suffix])
        {
            // 获取表情名
            NSString *imageName = [subStr substringWithRange:NSMakeRange(1, subStr.length-2)];
            BOOL isGif = NO;
            // 获取gif表情
            UIImage *img = [EmojiLabel animatedGIFNamed:imageName];
            
            CGFloat imageWidth;
            CGFloat imageHeight;
            
            // 是否Gif表情
            if (!img)
            {
                img = [UIImage imageNamed:imageName];
                
                imageWidth = img.size.width;
                imageHeight = img.size.height;
            }
            else
            {
                isGif = YES;
                
                CGFloat scale = [UIScreen mainScreen].scale;
                
                imageWidth = img.size.width;
                imageHeight = img.size.height;
                
                if (scale > 1.0f)
                {
                    // 因为不是2X名字，强制*2
                    imageWidth = imageWidth * scale;
                    imageHeight = imageHeight * scale;
                }
            }
            
            // 是否表情
            if (img)
            {
                btext = NO;
                
                CGFloat back_lineHeight = lineHeight;
                // 比较表情高度，改变行高
                lineHeight = lineHeight > imageHeight ? lineHeight : imageHeight;
                
                // 表情前文本操作
                if (appendStr.length > 0 || lines.count)
                {
                    if (lines.count)
                    {
                        NSMutableString *str = [NSMutableString stringWithCapacity:0];
                        
                        for (NSInteger i = 0; i<lines.count; i++)
                        {
                            [str appendString:[lines objectAtIndex:i]];
                        }
                        
                        if ([str isNotEmpty])
                        {
                            CGSize size = [EmojiLabel getTextSize:str withFont:font maxWidth:maxWidth lineHeight:defaultLineHeight];
                            
                            EmojiLabelData *labelData = [[[EmojiLabelData alloc] init] ah_autorelease];
                            labelData.m_Type = EmojiLabelText;
                            labelData.m_Text = str;
                            labelData.m_LineHeight = defaultLineHeight;
                            labelData.m_Lines = lines.count;
                            labelData.m_StartLine = startLine;
                            labelData.m_EndLine = startLine + lines.count - 1;
                            
                            labelData.m_Rect = CGRectMake(0, orignY, maxWidth, size.height);
                            orignY = orignY + size.height;
                            
                            labelData.m_LastPoint = CGPointMake(maxWidth, orignY-defaultLineHeight);
                            
                            [dataArray addObject:labelData];
                            //NSLog(@"%@", labelData);
                            
                            orignX = 0;
                            upY = orignY;
                        }
                    }
                    
                    // 最后一行变高
                    if (appendStr.length > 0)
                    {
                        EmojiLabelData *labelData = [[[EmojiLabelData alloc] init] ah_autorelease];
                        labelData.m_Type = EmojiLabelText;
                        labelData.m_Text = appendStr;
                        if (upX + imageWidth > maxWidth)
                        {
                            labelData.m_LineHeight = back_lineHeight;
                        }
                        else
                        {
                            labelData.m_LineHeight = lineHeight;
                        }
                        labelData.m_Lines = 1;
                        labelData.m_StartLine = currentLine;
                        labelData.m_EndLine = currentLine;
                        
                        //labelData.m_Rect = CGRectMake(orignX, orignY+(labelData.m_LineHeight-defaultLineHeight), upX - orignX, defaultLineHeight);
                        labelData.m_Rect = CGRectMake(orignX, orignY+(labelData.m_LineHeight-defaultLineHeight), maxWidth, defaultLineHeight);

                        labelData.m_LastPoint = CGPointMake(upX, orignY);
                        
                        [dataArray addObject:labelData];
                        //NSLog(@"%@", labelData);
                        
                        orignX = upX;
                    }
                    
                    // 刷新单行字符串
                    appendStr = [NSMutableString stringWithCapacity:0];
                    [lines removeAllObjects];
                }
                
                // 表情数据
                // 表情超宽换行
                if (orignX + imageWidth > maxWidth)
                {
                    orignY = orignY + back_lineHeight;
                    upX = 0;
                    orignX = 0;
                    upY = orignY;
                    
                    // 判断最大行
                    if ((maxLines != 0) && (currentLine+1 > maxLines))
                    {
                        break;
                    }
                    else
                    {
                        currentLine++;
                    }
                }
                
                EmojiLabelData *labelData = [[[EmojiLabelData alloc] init] ah_autorelease];
                labelData.m_Type = isGif ? EmojiLabelGif : EmojiLabelImage;
                labelData.m_Image = img;
                labelData.m_Text = imageName;
                labelData.m_LineHeight = lineHeight;
                labelData.m_Lines = 1;
                labelData.m_StartLine = currentLine;
                labelData.m_EndLine = currentLine;
                
                labelData.m_Rect = CGRectMake(orignX, orignY+(lineHeight-imageHeight), imageWidth, imageHeight);
                
                labelData.m_LastPoint = CGPointMake(orignX + imageWidth, orignY);
                
                [dataArray addObject:labelData];
                //NSLog(@"%@", labelData);
                
                orignX = orignX + imageWidth;
                upX = orignX;
            }   // 找到表情资源
        }   // 表情
        
        // 纯文本计算
        if (btext)
        {
            // 分解为单字符
            NSMutableArray *characters = [NSMutableArray array];
            [subStr enumerateSubstringsInRange:NSMakeRange(0, subStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
             {
                 
                 [characters addObject:substring];
                 
             }];
            
            for (NSInteger i=0; i<[characters count]; i++)
            {
                NSString *onestr = [characters objectAtIndex:i];
                
                // 判断换行符
                //if ([onestr isEqualToString:@"\n"] || [onestr isEqualToString:@"\r"])
                if ([onestr isEqualToString:@"\n"])
                {
                    // 表情后的单行文本
                    if (orignX > 0)
                    {
                        if (appendStr.length > 0)
                        {
                            EmojiLabelData *labelData = [[[EmojiLabelData alloc] init] ah_autorelease];
                            labelData.m_Type = EmojiLabelText;
                            labelData.m_Text = appendStr;
                            // 变高
                            labelData.m_LineHeight = lineHeight;
                            labelData.m_Lines = 1;
                            
                            //labelData.m_Rect = CGRectMake(orignX, orignY+(lineHeight-defaultLineHeight), upX - orignX, defaultLineHeight);
                            labelData.m_Rect = CGRectMake(orignX, orignY+(lineHeight-defaultLineHeight), maxWidth, defaultLineHeight);

                            labelData.m_LastPoint = CGPointMake(upX, orignY);
                            
                            [dataArray addObject:labelData];
                            //NSLog(@"%@", labelData);
                            
                            // 刷新字符串
                            appendStr = [NSMutableString stringWithCapacity:0];
                        }
                        
                        orignY = orignY + lineHeight;
                        upY = orignY;
                    }
                    else
                    {
                        // 插入换行
                        [appendStr appendString:@"\n"];
                        if (lines.count == 0)
                        {
                            startLine = currentLine;
                        }
                        // 添加到多行文本中
                        [lines addObject:appendStr];
                        
                        // 刷新单行字符串
                        appendStr = [NSMutableString stringWithCapacity:0];
                    }
                    
                    orignX = 0;
                    
                    // 回复初始文本行高
                    lineHeight = defaultLineHeight;
                    
                    // 判断最大行
                    if ((maxLines != 0) && (currentLine+1 > maxLines))
                    {
                        break;
                    }
                    else
                    {
                        currentLine++;
                    }
                    
                    continue;
                }
                
                NSString *newStr = [NSString stringWithFormat:@"%@%@", appendStr, onestr];
                
                // 计算文本尺寸
                CGSize newSize;
                //newSize = [newStr sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth+40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
                newSize = [self getTextSize:newStr withFont:font maxWidth:maxWidth+40 lineHeight:defaultLineHeight];
                
                // 文本超宽换行
                if (orignX + newSize.width > maxWidth)
                {
                    // 表情后文本
                    if (orignX > 0)
                    {
                        if (appendStr.length > 0)
                        {
                            EmojiLabelData *labelData = [[[EmojiLabelData alloc] init] ah_autorelease];
                            labelData.m_Type = EmojiLabelText;
                            labelData.m_Text = appendStr;
                            labelData.m_LineHeight = lineHeight;
                            labelData.m_Lines = currentLine;
                            
                            //labelData.m_Rect = CGRectMake(orignX, orignY+(lineHeight-defaultLineHeight), upX - orignX, defaultLineHeight);
                            labelData.m_Rect = CGRectMake(orignX, orignY+(lineHeight-defaultLineHeight), maxWidth, defaultLineHeight);

                            labelData.m_LastPoint = CGPointMake(upX, orignY);
                            
                            [dataArray addObject:labelData];
                            //NSLog(@"%@", labelData);
                            
                            // 刷新单行字符串
                            appendStr = [NSMutableString stringWithCapacity:0];
                            // 清空多行文本中
                            [lines removeAllObjects];
                        }
                        
                        orignY = orignY + lineHeight;
                        upY = orignY;
                        
                        orignX = 0;
                        upX = 0;
                        
                        // 回复初始文本行高
                        lineHeight = defaultLineHeight;
                        
                        if ((maxLines != 0) && (currentLine+1 > maxLines))
                        {
                            break;
                        }
                        else
                        {
                            currentLine++;
                        }
                        
                        [appendStr appendString:onestr];
                        
                        continue;
                    }
                    
                    upX = 0;
                    
                    if (lines.count == 0)
                    {
                        startLine = currentLine;
                    }
                    // 添加到多行文本中
                    [lines addObject:appendStr];
                    //[linesStr appendString:appendStr];
                    
                    // 刷新字符串
                    appendStr = [NSMutableString stringWithCapacity:0];
                    
                    // 判断最大行
                    if ((maxLines != 0) && (currentLine+1 > maxLines))
                    {
                        break;
                    }
                    else
                    {
                        currentLine++;
                    }
                    
                    [appendStr appendString:onestr];
                }
                else
                {
                    [appendStr appendString:onestr];
                    
                    upX = orignX + newSize.width;
                }
            } // for
        } // 文本
    }   // for data
    
    // 处理文操作文本
    if (appendStr.length > 0 || lines.count)
    {
        if (lines.count)
        {
            NSMutableString *str = [NSMutableString stringWithCapacity:0];
        
            for (NSInteger i = 0; i<lines.count; i++)
            {
                [str appendString:[lines objectAtIndex:i]];
            }
            
            if ([str isNotEmpty])
            {
                CGSize size = [EmojiLabel getTextSize:str withFont:font maxWidth:maxWidth lineHeight:defaultLineHeight];
                
                EmojiLabelData *labelData = [[[EmojiLabelData alloc] init] ah_autorelease];
                labelData.m_Type = EmojiLabelText;
                labelData.m_Text = str;
                labelData.m_LineHeight = defaultLineHeight;
                labelData.m_Lines = lines.count;
                labelData.m_StartLine = startLine;
                labelData.m_EndLine = startLine + lines.count - 1;
                
                labelData.m_Rect = CGRectMake(0, orignY, maxWidth, size.height);
                orignY = orignY + size.height;
                
                labelData.m_LastPoint = CGPointMake(maxWidth, orignY-defaultLineHeight);
                
                [dataArray addObject:labelData];
                //NSLog(@"%@", labelData);
                
                orignX = 0;
                upY = orignY;
            }
        }
        
        if (appendStr.length > 0)
        {
            EmojiLabelData *labelData = [[[EmojiLabelData alloc] init] ah_autorelease];
            labelData.m_Type = EmojiLabelText;
            labelData.m_Text = appendStr;
            labelData.m_LineHeight = lineHeight;
            labelData.m_Lines = currentLine;
        
            //labelData.m_Rect = CGRectMake(orignX, orignY+lineHeight-defaultLineHeight, upX - orignX, defaultLineHeight);
            labelData.m_Rect = CGRectMake(orignX, orignY+lineHeight-defaultLineHeight, maxWidth, defaultLineHeight);

            labelData.m_LastPoint = CGPointMake(upX, orignY);;
        
            [dataArray addObject:labelData];
            //NSLog(@"%@", labelData);
        }
    }
    
    return dataArray;
}

+ (CGSize)getTextSize:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineHeight:(CGFloat)lineHeight
{
    CGSize size = CGSizeZero;
    
    if (IOS_VERSION >= 7.0)
    {
        NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] ah_autorelease];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        // 必须hyphenationFactor = 1.0f，否则lineBreakMode = NSLineBreakByCharWrapping无效
        paragraphStyle.hyphenationFactor = 1.0f;
        paragraphStyle.firstLineHeadIndent = 0.0f;
        //paragraphStyle.lineSpacing = 1.0f;
        paragraphStyle.paragraphSpacing = 0.0f;
        paragraphStyle.headIndent = 0.0f;
        paragraphStyle.minimumLineHeight = lineHeight;
        paragraphStyle.maximumLineHeight = lineHeight;
        
        
        NSDictionary *attributes = @{NSFontAttributeName : font,
                                    NSParagraphStyleAttributeName : paragraphStyle};
        
        size = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    }
    else
    {
        size = [text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    }

    return size;
}

//+ (NSArray *)parserText:(NSString *)text withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxLines:(NSInteger)maxLines lineSpace:(CGFloat)lineSpace
//{
//    return nil;
//}


-(void)setM_text:(NSString *)str
{
    if ([m_text isEqual:str])
    {
        return;
    }

    [m_text ah_release];
    m_text = str ;

    //[self setNeedsDisplay];
}

- (void)setM_textColor:(UIColor *)textColor
{
    if ([m_textColor isEqual:textColor])
    {
        return;
    }
    
    [m_textColor ah_release];
    m_textColor = textColor;

    [self setNeedsDisplay];
}

- (void)setM_highColor:(UIColor *)highColor
{
    if ([m_highColor isEqual:highColor])
    {
        return;
    }
    
    [m_highColor ah_release];
    m_highColor = highColor;
    
    [self setNeedsDisplay];
}

- (void)setM_isHighlight:(BOOL)isHighlight
{
    m_isHighlight = isHighlight;
    
    [self setNeedsDisplay];
}

- (void)setM_font:(UIFont *)font
{
    if (![font isEqual:self.m_font])
    {
        [m_font ah_release];
        m_font = font;
        self.m_fontSize = [font lineHeight];

        //[self setNeedsDisplay];
    }
}

- (void)sizeToFit
{
    EmojiLabelData *emojiLabelData = [self.m_DataArray lastObject];
    
    CGRect rect = emojiLabelData.m_Rect;
    CGFloat hei = rect.origin.y + rect.size.height;
    
    self.height = hei;
    
    [self setNeedsDisplay];
}

- (CGPoint)lastPoint
{
    EmojiLabelData *emojiLabelData = [self.m_DataArray lastObject];
    
    return emojiLabelData.m_LastPoint;
}

- (CGFloat)lastHeight
{
    EmojiLabelData *emojiLabelData = [self.m_DataArray lastObject];
    
    return emojiLabelData.m_LineHeight;
}

- (CGRect)lastRect:(CGFloat)width
{
    EmojiLabelData *emojiLabelData = [self.m_DataArray lastObject];
    
    CGRect rect = CGRectMake(self.left + emojiLabelData.m_LastPoint.x, self.top + emojiLabelData.m_LastPoint.y, width, emojiLabelData.m_LineHeight);
    
    return rect;
}


//解析输入的文本，根据文本信息分析出那些是表情，那些是文字。
+ (void)getImageRange:(NSString *)message :(NSMutableArray *)array
{
	NSRange range = [message rangeOfString:@"<"];
        
	NSRange range1 = [message rangeOfString:@">"];
    
    if (range.length && range1.length && range1.location<range.location)
    {
        NSString *before = [message substringWithRange:NSMakeRange(0, range.location)];
        [array addObject:before];
        
        NSString *str = [message substringFromIndex:range.location];
        
        [self getImageRange:str :array];
        
        return;
    }

    //判断当前字符串是否还有表情的标志。
    if (range.length && range1.length)
    {
        NSString *before = [message substringWithRange:NSMakeRange(0, range1.location)];
        NSRange range2 = [before rangeOfString:@"<" options:NSBackwardsSearch];
        if (range2.location != range.location)
        {
            NSString *before =  [message substringWithRange:NSMakeRange(0, range2.location)];
            [array addObject:before];
            message = [message substringFromIndex:range2.location];
            range = [message rangeOfString:@"<"];
            range1 = [message rangeOfString:@">"];
        }
        if (range.location>0 && range1.location>range.location)
        {
            [array addObject:[message substringToIndex:range.location]];
            // <>
            NSString *subStr;
            subStr = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            [array addObject:subStr];
            
            NSString *str = [message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }
        else
        {
            NSString *nextstr = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""])
            {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }
            else
            {
                return;
            }
        }
    }
    else if (message.length)
    {
        [array addObject:message];
    }
}

+ (BOOL)isGif:(NSString *)name
{
    NSRange rangedot = [name rangeOfString:@"."];
    if (rangedot.location != NSNotFound)
    {
        name = [name substringWithRange:NSMakeRange(0, rangedot.location)];
    }

    NSRange rangmika = [name rangeOfString:@"mika"];
    NSString *subpath;
    if (rangmika.location == NSNotFound)
    {
        subpath = @"gif/doubao";
    }
    else
    {
        subpath = @"gif/mika";
    }

    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif" inDirectory:subpath];
    
    NSData *data = [NSData dataWithContentsOfFile:retinaPath];
    
    if (data && [data sd_isGIF])
    {
        return YES;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif" inDirectory:subpath];
    
    data = [NSData dataWithContentsOfFile:path];
    
    if (data && [data sd_isGIF])
    {
        return YES;
    }
    
    return NO;
}

+ (UIImage *)animatedGIFNamed:(NSString *)name
{
    NSRange rangedot = [name rangeOfString:@"."];
    if (rangedot.location != NSNotFound)
    {
        name = [name substringWithRange:NSMakeRange(0, rangedot.location)];
    }
    
    NSRange rangmika = [name rangeOfString:@"mika"];
    NSString *subpath;
    if (rangmika.location == NSNotFound)
    {
        subpath = @"gif/doubao";
    }
    else
    {
        subpath = @"gif/mika";
    }
    
    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif" inDirectory:subpath];
    
    NSData *data = [NSData dataWithContentsOfFile:retinaPath];
    
    if (data && [data sd_isGIF])
    {
        return [UIImage sd_animatedGIFWithData:data];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif" inDirectory:subpath];
    
    data = [NSData dataWithContentsOfFile:path];
    
    if (data && [data sd_isGIF])
    {
        return [UIImage sd_animatedGIFWithData:data];
    }
    
    return nil;
}


@end


@implementation EmojiLabelData
@synthesize m_Type;
@synthesize m_Text;
@synthesize m_Image;
@synthesize m_Rect;

@synthesize m_StartLine;
@synthesize m_EndLine;

@synthesize m_LineHeight;

@synthesize m_LastPoint;

@synthesize m_Lines;

@synthesize m_Color;


- (void)dealloc
{
    [m_Text ah_release];
    [m_Image ah_release];
    [m_Color ah_release];
    
    [super ah_dealloc];
}


- (void)setImageName:(NSString *)name
{
    NSString *ImageName = [NSString stringWithFormat:@"%@", name];

    self.m_Text = ImageName;
    
    NSRange rangedot = [name rangeOfString:@"."];
    if (rangedot.location != NSNotFound)
    {
        name = [name substringWithRange:NSMakeRange(0, rangedot.location)];
    }
    
    NSRange rangmika = [name rangeOfString:@"mika"];
    NSString *subpath;
    if (rangmika.location == NSNotFound)
    {
        subpath = @"gif/doubao";
    }
    else
    {
        subpath = @"gif/mika";
    }
    
    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif" inDirectory:subpath];
    
    NSData *data = [NSData dataWithContentsOfFile:retinaPath];
    
    if (data && [data sd_isGIF])
    {
        self.m_Image = [UIImage sd_animatedGIFWithData:data];
        self.m_Type = EmojiLabelGif;
        
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif" inDirectory:subpath];
    
    data = [NSData dataWithContentsOfFile:path];
    
    if (data && [data sd_isGIF])
    {
        self.m_Image = [UIImage sd_animatedGIFWithData:data];
        self.m_Type = EmojiLabelGif;
        
        return;
    }
    
    self.m_Image = [UIImage imageNamed:ImageName];
    self.m_Type = EmojiLabelImage;
    
    return;
}

- (NSString *)description
{
    NSString *des = nil;
    
    switch (self.m_Type)
    {
        case EmojiLabelText:
        {
            des = [NSString stringWithFormat:@"%ld %@ -- %@\nformLine: %ld to: %ld\n%@", (long)self.m_Text.length, NSStringFromCGRect(self.m_Rect), NSStringFromCGPoint(self.m_LastPoint), (long)self.m_StartLine, (long)self.m_EndLine, self.m_Text];
        }
            break;
            
        case EmojiLabelImage:
        case EmojiLabelGif:
        {
            des = [NSString stringWithFormat:@"%@ -- %@\nimageName: %@", NSStringFromCGRect(self.m_Rect), NSStringFromCGPoint(self.m_LastPoint), self.m_Text];
        }
            break;
            
        default:
            break;
    }
    
    return des;
}

@end
