//
//  BBKuaidiPlaceSelectorViewController.h
//  pregnancy
//
//  Created by MAYmac on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    //传回的是起点
    BBKuaidiPlaceSelectorTypeStart,
    //传回的是终点
    BBKuaidiPlaceSelectorTypeEnd
}BBKuaidiPlaceSelectorType;

@protocol BBKuaidiPlaceSelectorDelegate <NSObject>
@optional
//通知上一层已经选择好的地名
- (void)placeSelectedWithPlace:(NSString *)place type:(BBKuaidiPlaceSelectorType)type;
@end

@interface BBKuaidiPlaceSelectorViewController : BaseViewController
//通知地名的委托
@property(nonatomic,assign)id<BBKuaidiPlaceSelectorDelegate>delegate;
//必填
@property(nonatomic,retain)NSMutableDictionary * geocoderPalcesDic;
//必填
@property(nonatomic,assign)BBKuaidiPlaceSelectorType placeSelectorType;
@end
