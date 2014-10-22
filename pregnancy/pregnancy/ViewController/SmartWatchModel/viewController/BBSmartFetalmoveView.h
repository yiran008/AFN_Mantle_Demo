//
//  BBSmartFetalmoveView.h
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BBSmartFetalmoveView : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *chartView;
@property (nonatomic, strong) ASIFormDataRequest *chartRequest;
@property (nonatomic, strong) IBOutlet UIImageView *chartImage;
@property (nonatomic, strong) IBOutlet UILabel *changeLabel;


@property (nonatomic, strong) IBOutlet UIView *sheetView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *loadProgress;
@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) IBOutlet UIView *sheetDetailView;
@property (nonatomic, strong) IBOutlet UITableView *detailTableView;
@property (nonatomic, strong) IBOutlet UILabel *sheetTitle;
@property (nonatomic, strong) NSString *changeString;

@property (nonatomic, strong) IBOutlet UIButton *chengeButton;

@end
