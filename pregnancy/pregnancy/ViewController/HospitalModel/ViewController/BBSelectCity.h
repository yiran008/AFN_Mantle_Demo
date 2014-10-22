//
//  BBSelectCity.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSelectArea.h"

@interface BBSelectCity : BaseViewController<UITableViewDelegate,UITableViewDataSource>{

    UITableView *cityTableView;
    NSMutableArray *data;
    NSString *provinceCode;
    id<BBSelectAreaCallBack> selectAreaCallBackHander;
    id<BBSelectPersonalCityCallBack>selectPersonalCityCallBackHander;

    BOOL PersonalEditChoice;
}
@property (nonatomic,strong) UITableView *cityTableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSString *provinceCode;
@property (assign) id<BBSelectAreaCallBack> selectAreaCallBackHander;
@property (assign) id<BBSelectPersonalCityCallBack>selectPersonalCityCallBackHander;

@property (assign) BOOL PersonalEditChoice;

@end
