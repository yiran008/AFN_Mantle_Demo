//
//  BBSelectMoreArea.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSelectMoreArea.h"
#import "BBSelectStyleCell.h"
#import "BBAreaDB.h"
#import "BBSelectCity.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "MobClick.h"

@implementation BBSelectMoreArea

@synthesize data;
@synthesize provinceTableView;
@synthesize selectAreaCallBackHander;
@synthesize selectPersonalAreaCallBackHander;
@synthesize selectPersonalCityCallBackHander;
@synthesize PersonalEditChoice;

-(void)dealloc
{
    [data release];
    [provinceTableView release];
    
    [super dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"更多地区";
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
    
    self.data = [BBAreaDB provinceList];
    self.provinceTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, IPHONE5_ADD_HEIGHT(416)) style:UITableViewStylePlain] autorelease];
    provinceTableView.delegate = self;
    provinceTableView.dataSource = self;
    [self.view addSubview:provinceTableView];
    provinceTableView.backgroundColor = [UIColor clearColor];
    [provinceTableView reloadData];
    
    //iphone5适配
    IPHONE5_ADAPTATION
    
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
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
    self.provinceTableView = nil;
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
    static NSString *CellIdentifier = @"BBSelectStyleCell";
         
    BBSelectStyleCell *cell = (BBSelectStyleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BBSelectStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17.];
    }
    cell.textLabel.text =[[data objectAtIndex:indexPath.row] stringForKey:@"province_name"];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBSelectCity *selectCity = [[[BBSelectCity alloc]initWithNibName:@"BBSelectCity" bundle:nil] autorelease];
    selectCity.provinceCode = [[data objectAtIndex:indexPath.row] stringForKey:@"province_code"];
    if(PersonalEditChoice==YES)
    {
        selectCity.PersonalEditChoice=YES;
        selectCity.selectPersonalCityCallBackHander = self.selectPersonalCityCallBackHander;
        NSMutableDictionary *info = [[BBAreaDB provinceList] objectAtIndex:indexPath.row];
        [BBAreaDB insertSelectedProvince:info];
        [selectPersonalAreaCallBackHander selectPersonalAreaCallBack:info]; 
        NSLog(@"area=%@",[info stringForKey:@"province_name"]);
    }
    else {
        selectCity.selectAreaCallBackHander = self.selectAreaCallBackHander;
    }
    [self.navigationController pushViewController:selectCity animated:YES];

}
@end
