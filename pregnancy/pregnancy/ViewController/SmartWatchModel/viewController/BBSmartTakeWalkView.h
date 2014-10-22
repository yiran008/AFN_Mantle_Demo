//
//  BBSmartTakeWalkView.h
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BBSmartTakeWalkView : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *chartView;
@property (nonatomic, strong) ASIFormDataRequest *chartRequest;
@property (nonatomic, strong) IBOutlet UILabel *checkLabel;
@property (nonatomic, strong) IBOutlet UIImageView *chartImage;


@property (nonatomic, strong) IBOutlet UIView *sheetView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *loadProgress;
@property (nonatomic, strong) NSArray *tableData;

@end
