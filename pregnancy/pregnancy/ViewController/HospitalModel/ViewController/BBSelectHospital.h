//
//  BBSelectHospital.h
//  pregnancy
//
//  Created by babytree babytree on 12-10-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSelectHospital : BBBaseTableViewController
{
    ASIFormDataRequest *selectHospitalRequest;
    MBProgressHUD *hud;
    NSString *key;
    NSMutableArray *requestData;
    UITableView *selectHospitalTableView;
    BOOL isProvince;
}
@property(nonatomic,strong) ASIFormDataRequest *selectHospitalRequest;
@property(nonatomic,strong) MBProgressHUD *hud;
@property(nonatomic,strong) NSString *key;
@property(nonatomic,strong) NSMutableArray *requestData;
@property(nonatomic,strong) IBOutlet UITableView *selectHospitalTableView;
@property(assign) BOOL isProvince;
@end
