//
//  HMSearchBarView.m
//  lama
//
//  Created by songxf on 13-12-26.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMSearchBarView.h"

@implementation HMSearchBarView
@synthesize delegate;

- (void)dealloc
{
    [_bgImageView release];
    [_textField release];
    [_searchIconButton release];
    [_cancleButton release];
    delegate = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImage *origin = [UIImage imageNamed:@"search_bar_bg"];

        UIImageView *vv = [[[UIImageView alloc] initWithFrame:CGRectMake(5, (44-28)/2, INPUTVIEW_WIDTH_SMALL, 28)] autorelease];
        vv.image = [origin resizableImageWithCapInsets:UIEdgeInsetsMake(5, 30, 5, 50)];
        self.bgImageView = vv;
        vv.userInteractionEnabled = YES;
        [self addSubview:vv];
        
        UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(30, 0, INPUTVIEW_WIDTH_SMALL-30, 28)] autorelease];
        field.placeholder = @"请输入关键词";
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.backgroundColor = [UIColor clearColor];
        field.returnKeyType = UIReturnKeySearch;
        field.font = [UIFont systemFontOfSize:14];
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.bgImageView addSubview:field];
        self.textField = field;
        
        UIButton *btn1 = [[[UIButton alloc] initWithFrame:CGRectMake(1, 0, 28, 28)] autorelease];
        [btn1 setImage:[UIImage imageNamed:@"search_bar_icon"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(beginEditingSearchText:) forControlEvents:UIControlEventTouchUpInside];
        btn1.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 6, 6);
        btn1.exclusiveTouch = YES;
        [self.bgImageView addSubview:btn1];
        self.searchIconButton = btn1;
        
        UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(SEARCHBAR_MAXWIDTH-50, 0, 50, 44)] autorelease];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(cancleSearch:) forControlEvents:UIControlEventTouchUpInside];
        btn.exclusiveTouch = YES;
        [self addSubview:btn];
        self.cancleButton = btn;
//        btn.hidden = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Button Action

- (void)beginEditingSearchText:(UIButton *)btn
{
    [self.textField becomeFirstResponder];
}

- (void)cancleSearch:(UIButton *)btn
{
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    [self setUserInputEnabled:YES];
    if (delegate && [delegate respondsToSelector:@selector(searchBarViewCancleSearch)])
    {
        [delegate searchBarViewCancleSearch];
    }

    __block UITextField *_field = self.textField;
    __block UIImageView *_vv = self.bgImageView;
    __block UIButton *_btn = self.cancleButton;
    [UIView animateWithDuration:0.25f animations:^{
        [_vv setFrame:CGRectMake((SEARCHBAR_MAXWIDTH-INPUTVIEW_WIDTH_SMALL)/2-15, (44-28)/2, INPUTVIEW_WIDTH_SMALL, 28)];
        _field.width = INPUTVIEW_WIDTH_SMALL - 30;
        _btn.hidden = YES;
    }];
}

- (void) setUserInputEnabled:(BOOL)inputEnable
{
    self.textField.userInteractionEnabled = inputEnable;
    self.searchIconButton.userInteractionEnabled = inputEnable;
}

@end
