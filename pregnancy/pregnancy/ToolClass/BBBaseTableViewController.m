//
//  BBBaseTableViewController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-12-31.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBBaseTableViewController.h"

@interface BBBaseTableViewController ()

@end

@implementation BBBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
#endif

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}


@end
