//
//  BBSelectArea.h
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBSelectAreaCallBack <NSObject>
- (void)selectAreaCallBack:(id)object;
@end

@protocol BBSelectPersonalAreaCallBack <NSObject>
- (void)selectPersonalAreaCallBack:(id)object;
@end

@protocol BBSelectPersonalCityCallBack <NSObject>
- (void)selectPersonalCityCallBack:(id)object;
@end

@interface BBSelectArea : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *areaTableView;
    NSMutableArray *selectedCityData;
    NSMutableArray *hotAreaData;
    id<BBSelectAreaCallBack> selectAreaCallBackHander;
}
@property (nonatomic,strong) UITableView *areaTableView;
@property (nonatomic,strong) NSMutableArray *selectedCityData;
@property (nonatomic,strong) NSMutableArray *hotAreaData;
@property (assign) id<BBSelectAreaCallBack> selectAreaCallBackHander;

+ (void)insertSelectedCity:(id)object;
+ (NSMutableArray *)getSelectedCityList;
@end
