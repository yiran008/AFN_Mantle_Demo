//
//  BBSelectMoreArea.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSelectArea.h"

@interface BBSelectMoreArea : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *data;
    UITableView *provinceTableView;
    id<BBSelectAreaCallBack> selectAreaCallBackHander;
    id<BBSelectPersonalAreaCallBack>selectPersonalAreaCallBackHander;
    id<BBSelectPersonalCityCallBack>selectPersonalCityCallBackHander;

    BOOL PersonalEditChoice;
    
}
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UITableView *provinceTableView;
@property (assign) id<BBSelectAreaCallBack> selectAreaCallBackHander;
@property (assign) id<BBSelectPersonalAreaCallBack>selectPersonalAreaCallBackHander;
@property (assign) id<BBSelectPersonalCityCallBack>selectPersonalCityCallBackHander;

@property (assign) BOOL PersonalEditChoice;
@end
