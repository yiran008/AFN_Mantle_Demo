//
//  BBPlaceholderTextView.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-5-22.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBPlaceholderTextView.h"

@interface BBPlaceholderTextView()
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (assign) BOOL isHasLine;
@end

static NSString *kPlaceholderKey = @"placeholder";
static NSString *kFontKey = @"font";
static NSString *kTextKey = @"text";
static float kUITextViewPadding = 6.0;

@implementation BBPlaceholderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:kPlaceholderKey];
    [self removeObserver:self forKeyPath:kFontKey];
    [self removeObserver:self forKeyPath:kTextKey];
    [_placeholderLabel release];
    [_placeholder release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeFromNib];

    }
    return self;
}

- (void)insertText:(NSString *)text
{
    [super insertText:text];
    [self setNeedsLayout];
}

- (void)awakeFromNib
{
    CGRect frame = CGRectMake(kUITextViewPadding, kUITextViewPadding-1, 0, 0);
    self.placeholderLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    self.placeholderLabel.opaque = NO;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.textColor = [UIColor grayColor];
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.placeholderLabel.font = self.font;
    [self.placeholderLabel sizeToFit];
    [self addSubview:self.placeholderLabel];
    
    // some observations
    NSNotificationCenter *defaultCenter;
    defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(textDidChange:)
                          name:UITextViewTextDidChangeNotification object:self];
    
    [self addObserver:self forKeyPath:kPlaceholderKey
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kFontKey
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kTextKey
              options:NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIEdgeInsets inset = self.contentInset;
    CGRect frame = self.placeholderLabel.frame;
    frame.size.width = self.bounds.size.width;
    frame.size.width-= kUITextViewPadding + inset.right + inset.left;
    self.placeholderLabel.frame = frame;
    
    if (self.text.length < 1)
    {
        if (!self.placeholderLabel.superview)
        {
            [self addSubview:self.placeholderLabel];
        }
        [self sendSubviewToBack:self.placeholderLabel];
    }
    else
    {
        [self.placeholderLabel removeFromSuperview];
    }
}
- (void)setHasLine:(BOOL)hasLine{
    self.isHasLine = hasLine;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    if (self.isHasLine) {
        //去掉注释划虚线
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:207/255. green:207/255. blue:207/255. alpha:1].CGColor);
        CGContextMoveToPoint(context, 0, 0.0);
        CGContextAddLineToPoint(context, 312.0,0.0);
        CGContextStrokePath(context);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kPlaceholderKey]) {
        self.placeholderLabel.text = [change valueForKey:NSKeyValueChangeNewKey];
        [self.placeholderLabel sizeToFit];
    }
    else if ([keyPath isEqualToString:kFontKey]) {
        self.placeholderLabel.font = [change valueForKey:NSKeyValueChangeNewKey];
        [self.placeholderLabel sizeToFit];
    }
    else if ([keyPath isEqualToString:kTextKey]) {
        NSString *newText = [change valueForKey:NSKeyValueChangeNewKey];
        if (newText.length > 0) {
            [self.placeholderLabel removeFromSuperview];
        } else {
            [self addSubview:self.placeholderLabel];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    self.placeholderLabel.textColor = placeholderTextColor;
}

- (UIColor *)placeholderTextColor
{
    return self.placeholderLabel.textColor;
}

- (void)textDidChange:(NSNotification *)aNotification
{
    [self setNeedsLayout];
}

@end
