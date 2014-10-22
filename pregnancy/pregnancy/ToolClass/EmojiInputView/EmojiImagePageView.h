//
//  wiEmojiImagePageView.h
//  wiIos
//
//  Created by qq on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EMOJI_WIDTH     42
#define EMOJI_HEIGHT    42
#define EMOJI_TOPGAP    5
#define EMOJI_LEFTGAP   13

#define EMOJI_LINE              3
#define EMOJI_ONELINE_COUNT     7
#define EMOJI_ONEPAGE_COUNT     (EMOJI_ONELINE_COUNT*EMOJI_LINE)
#define EMOJI_VIEW_HEIGHT       (EMOJI_HEIGHT*EMOJI_LINE+2*EMOJI_TOPGAP)


@protocol EmojiImagePageViewDelegate;

@interface EmojiImagePageView : UIView
{
    NSArray *m_EmojiCodeArray;
}

@property (nonatomic, assign) id <EmojiImagePageViewDelegate> delegate;

@property (nonatomic, retain) NSArray *m_EmojiCodeArray;

- (id)initWithEmojiArray:(NSArray *)array;

- (void)drawPageAtIndex:(NSInteger)index;

@end


@protocol EmojiImagePageViewDelegate
- (void)selectedEmojiatIndex:(NSInteger)index;

@end