//
//  BBHospitalPregnancyListView.h
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHospitalPregnancyCell.h"


@interface BBHospitalPregnancyListView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *pregnancyTable;
    NSMutableArray *pregnancyArray;
    EGORefreshTableHeaderView *_refresh_header_view; 
    BOOL _reloading; 
    EGORefreshPullUpTableHeaderView *_refresh_pull_up_header_view;
    BOOL _pull_up_reloading;
    NSInteger loadedTotalCount;
    NSInteger listTotalCount;
    
    ASIFormDataRequest *myRequest;
    NSString *hospitalId;
    MBProgressHUD *hud;
    UIViewController *viewCtrl;
}

@property (nonatomic, retain)UITableView *pregnancyTable;
@property (nonatomic, retain)NSMutableArray *pregnancyArray;
@property (nonatomic, retain)ASIFormDataRequest *myRequest;
@property (nonatomic, retain)NSString *hospitalId;
@property (nonatomic, retain)MBProgressHUD *hud;
@property (assign) UIViewController *viewCtrl;
- (id)initWithFrame:(CGRect)frame withHospitalId:(NSString *)hosId;

@end
