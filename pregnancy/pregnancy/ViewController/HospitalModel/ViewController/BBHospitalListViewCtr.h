//
//  BBHospitalListViewCtr.h
//  pregnancy
//
//  Created by mac on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHospitalRequest.h"


@interface BBHospitalListViewCtr : BaseViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    CallBack,
    BBLoginDelegate
>
{
    IBOutlet UITableView *hospitalTable;
    
    NSString *city;
    NSString *hospitalId;
    ASIFormDataRequest *myRequest;
    MBProgressHUD *hud;
    NSMutableArray *hospitalArray;
    UITextField *searchText;
    BOOL isSearch;
    IBOutlet    UIToolbar   *inputActionBar;
    NSDictionary *cityInfo;
    BOOL isBackClickSwitchCityBtn;
}

@property (nonatomic, retain) IBOutlet UITableView *hospitalTable;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *hospitalId;
@property (nonatomic, retain) ASIFormDataRequest *myRequest;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) NSMutableArray *hospitalArray;
@property (nonatomic, strong) IBOutlet UITextField *searchText;
@property (assign) BOOL isSearch;
@property (nonatomic, strong) IBOutlet    UIToolbar   *inputActionBar;
@property (nonatomic, strong) NSDictionary *cityInfo;
@property (assign) BOOL isBackClickSwitchCityBtn;
- (void)addHospitalAction:(id)sender;
- (IBAction)cancelInput:(id)sender;
- (IBAction)search:(id)sender;
@end
