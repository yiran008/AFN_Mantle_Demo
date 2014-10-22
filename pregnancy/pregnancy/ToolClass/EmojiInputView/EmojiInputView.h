//
//  wiEmojiInputView.h
//  wiIos
//
//  Created by qq on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiImagePageView.h"
#import "HMPageControl.h"

//    mood 
//    natural
//    life 
//    traffic
//    symbol
typedef NS_ENUM(NSUInteger, EMOJI_TYPE)
{
    EMOJI_CATEGORY_MOOD = 0,     //心情
    EMOJI_CATEGORY_NATURAL ,     //自然
    EMOJI_CATEGORY_LIFE,         //生活
    EMOJI_CATEGORY_TRAFFIC,      //交通
    EMOJI_CATEGORY_SYMBOL,       //符号
    EMOJI_CATEGORY_LAMA          //辣妈筛选
};


@protocol EmojiInputViewDelegate;

@interface EmojiInputView : UIView
<
    UIScrollViewDelegate,
    EmojiImagePageViewDelegate
>
{
    HMPageControl *s_PageControl;
    UIScrollView *s_ScrollView;
    UISegmentedControl *s_SegmentedControl;

    BOOL s_PageControlUsed;
    
    EMOJI_TYPE s_CurrentCategory;
}

@property (nonatomic, assign) id <EmojiInputViewDelegate> delegate;

@property (nonatomic, retain) NSDictionary *m_EmojiDic;

@property (nonatomic, retain) NSMutableArray *m_EmojiCodeArray;
@property (nonatomic, retain) NSMutableArray *m_EmojiViews;
@property (nonatomic, retain) NSMutableArray *m_BtnArray;

- (void)changeEmojiCategoryByIndex:(EMOJI_TYPE)emojiType;

@end

@protocol EmojiInputViewDelegate

- (void)switchEmojiInputView;
- (void)deleteEmoji;

- (void)setEmojiFromEmojiInputView:(NSString *)emojiStr;


@end
