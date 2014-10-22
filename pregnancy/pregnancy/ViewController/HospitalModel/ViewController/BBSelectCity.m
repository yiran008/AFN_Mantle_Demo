//
//  BBSelectCity.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSelectCity.h"
#import "BBAreaDB.h"
#import "BBSelectArea.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "MobClick.h"

@implementation BBSelectCity
@synthesize cityTableView;
@synthesize data;
@synthesize provinceCode;
@synthesize selectAreaCallBackHander;
@synthesize selectPersonalCityCallBackHander;
@synthesize PersonalEditChoice;

-(void)dealloc
{
    [cityTableView release];
    [data release];
    [provinceCode release];
    
    [super dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"城市选择";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.navigationItem.title = @"城市选择";

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    self.data = [BBAreaDB cityList:provinceCode];
    self.cityTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, IPHONE5_ADD_HEIGHT(416)) style:UITableViewStylePlain] autorelease];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    [self.view addSubview:cityTableView];
    [cityTableView reloadData];
    
    cityTableView.backgroundColor = [UIColor colorWithRed:244./255 green:244./255 blue:244./255 alpha:244./255];
    
    IPHONE5_ADAPTATION
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    self.cityTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - IBAction Event Handler Mehthod

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.];
    cell.textLabel.text = [[data objectAtIndex:indexPath.row] stringForKey:@"name"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *info = [data objectAtIndex:indexPath.row];
    if(PersonalEditChoice==YES)
    {
        [BBSelectArea insertSelectedCity:info];
        [selectPersonalCityCallBackHander selectPersonalCityCallBack:info]; 
        NSLog(@"city=%@",[info   stringForKey:@"name"]);
    }
    else {
        [BBSelectArea insertSelectedCity:info];
        [selectAreaCallBackHander selectAreaCallBack:info];
    }
}

@end
