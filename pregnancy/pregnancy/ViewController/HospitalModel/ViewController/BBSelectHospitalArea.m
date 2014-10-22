//
//  BBSelectHospitalArea.m
//  pregnancy
//
//  Created by babytree babytree on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSelectHospitalArea.h"
#import "BBSelectHospitalAreaCell.h"
#import "BBHospitalListViewCtr.h"
#import "BBSelectHospital.h"
#import "BBAreaDB.h"

@interface BBSelectHospitalArea ()

@end

@implementation BBSelectHospitalArea

@synthesize hostpitalAreaData;
@synthesize startEnterFlag;
@synthesize city;
- (void)dealloc
{
    [hostpitalAreaData release];
    [city release];
    
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        startEnterFlag = NO;
        self.city = nil;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];

    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
 
    if (city!=nil) {
        self.title = @"选择地区";
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"选择地区"]];
        self.hostpitalAreaData = [BBAreaDB cityList:[city stringForKey:@"province_code"]];
    }else {
        self.title = @"选择医院所在地区";
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"选择医院所在地区"]];
        self.hostpitalAreaData = [BBAreaDB provinceList];
    }
    
    
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [hostpitalAreaData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBSelectHospitalAreaCell";
    BBSelectHospitalAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSelectHospitalAreaCell" owner:self options:nil] objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (city!=nil) {
        [cell.text setText:[[hostpitalAreaData objectAtIndex:indexPath.row] stringForKey:@"shortname"]];
    }else {
        [cell.text setText:[[hostpitalAreaData objectAtIndex:indexPath.row] stringForKey:@"province_name"]];
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (city!=nil) {
        if (startEnterFlag==YES) {
            BBSelectHospital *selectHospital = [[[BBSelectHospital alloc]initWithNibName:@"BBSelectHospital" bundle:nil]autorelease];
            selectHospital.key = [[hostpitalAreaData objectAtIndex:indexPath.row] stringForKey:@"shortname"];
            selectHospital.isProvince = YES;
            [self.navigationController pushViewController:selectHospital animated:YES];
        } else {
            BBHospitalListViewCtr *hospitalView = [[[BBHospitalListViewCtr alloc] initWithNibName:@"BBHospitalListViewCtr" bundle:nil] autorelease];
            hospitalView.city = [[hostpitalAreaData objectAtIndex:indexPath.row] stringForKey:@"shortname"];
            hospitalView.cityInfo = [hostpitalAreaData objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:hospitalView animated:YES];
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        }
    }else {
        BBSelectHospitalArea *selectHospitalArea = [[[BBSelectHospitalArea alloc] initWithNibName:@"BBSelectHospitalArea" bundle:nil] autorelease];
        selectHospitalArea.city = [hostpitalAreaData objectAtIndex:indexPath.row];
        selectHospitalArea.startEnterFlag = startEnterFlag;
        [self.navigationController pushViewController:selectHospitalArea animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }

}

- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
