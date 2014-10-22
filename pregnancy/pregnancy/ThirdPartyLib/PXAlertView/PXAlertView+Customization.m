//
//  PXAlertView+Customization.m
//  PXAlertViewDemo
//
//  Created by Michal Zygar on 21.10.2013.
//  Copyright (c) 2013 panaxiom. All rights reserved.
//

#import "PXAlertView+Customization.h"
#import <objc/runtime.h>

void * const kCancelBGKey = (void * const) &kCancelBGKey;
void * const kOtherBGKey = (void * const) &kOtherBGKey;

// add by DJ
void * const kCancelHBGKey = (void * const) &kCancelHBGKey;
void * const kOtherHBGKey = (void * const) &kOtherHBGKey;

@interface PXAlertView ()

@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;

@end

@implementation PXAlertView (Customization)

- (void)setWindowTintColor:(UIColor *)color
{
    self.backgroundView.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.alertView.backgroundColor = color;
}

- (void)setTitleColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)setMessageColor:(UIColor *)color
{
    self.messageLabel.textColor = color;
}

- (void)setMessageFont:(UIFont *)font
{
    self.messageLabel.font = font;
}

#pragma mark -
#pragma mark Buttons Customization
/*
- (void)setCustomBackgroundColorForButton:(id)sender
{
    if (sender == self.cancelButton && self.cancelButtonBackgroundColor) {
        self.cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
    } else if (sender == self.otherButton && self.otherButtonBackgroundColor) {
        self.otherButton.backgroundColor = self.otherButtonBackgroundColor;
    } else {
        [sender setBackgroundColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1]];
    }
}
*/

- (void)setCancelButtonBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kCancelBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //[self.cancelButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    //[self.cancelButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [self.cancelButton addTarget:self action:@selector(clearCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    self.cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
}

- (UIColor *)cancelButtonBackgroundColor
{
    return objc_getAssociatedObject(self, kCancelBGKey);
}

- (void)setOtherButtonBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kOtherBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //[self.otherButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    //[self.otherButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [self.otherButton addTarget:self action:@selector(clearCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    self.otherButton.backgroundColor = self.otherButtonBackgroundColor;
}

- (UIColor *)otherButtonBackgroundColor
{
    return objc_getAssociatedObject(self, kOtherBGKey);
}

// add by DJ
- (void)setCustomHighLightBGColorForButton:(UIButton *)sender
{
    if (sender == self.cancelButton && self.cancelButtonHighLightBGColor) {
        self.cancelButton.backgroundColor = self.cancelButtonHighLightBGColor;
    } else if (sender == self.otherButton && self.otherButtonHighLightBGColor) {
        self.otherButton.backgroundColor = self.otherButtonHighLightBGColor;
    } else {
        [sender setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)clearCustomHighLightBGColorForButton:(UIButton *)sender
{
    if (sender == self.cancelButton && self.cancelButtonBackgroundColor) {
        self.cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
    } else if (sender == self.otherButton && self.otherButtonBackgroundColor) {
        self.otherButton.backgroundColor = self.otherButtonBackgroundColor;
    } else {
        [sender setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setCancelButtonHighLightBGColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kCancelHBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.cancelButton addTarget:self action:@selector(setCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.cancelButton addTarget:self action:@selector(setCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [self.cancelButton addTarget:self action:@selector(clearCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDragExit];
}

- (UIColor *)cancelButtonHighLightBGColor
{
    return objc_getAssociatedObject(self, kCancelHBGKey);
}

- (void)setOtherButtonHighLightBGColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kOtherHBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.otherButton addTarget:self action:@selector(setCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.otherButton addTarget:self action:@selector(setCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [self.otherButton addTarget:self action:@selector(clearCustomHighLightBGColorForButton:) forControlEvents:UIControlEventTouchDragExit];
}

- (UIColor *)otherButtonHighLightBGColor
{
    return objc_getAssociatedObject(self, kOtherHBGKey);
}
// add end

@end