//
//  BBSelectHospital.m
//  pregnancy
//
//  Created by babytree babytree on 12-10-24.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSelectHospital.h"
#import "BBSelectHospitalAreaCell.h"
#import "BBHospitalRequest.h"
@interface BBSelectHospital ()

@end

@implementation BBSelectHospital
@synthesize selectHospitalRequest;
@synthesize hud;
@synthesize key;
@synthesize requestData;
@synthesize selectHospitalTableView;
@synthesize isProvince;
- (void)dealloc
{
    [selectHospitalRequest clearDelegatesAndCancel];
    [selectHospitalRequest release];
    [hud release];
    [key release];
    [requestData release];
    [selectHospitalTableView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.requestData  = [[[NSMutableArray alloc]init]autorelease];
        self.isProvince = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //MBProgressHUD显示等待框
    self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:hud];
    self.title = @"选择医院";

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"选择医院"]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    [hud show:YES];
    if (self.selectHospitalRequest != nil) {
        [self.selectHospitalRequest clearDelegatesAndCancel];
    }
    if (isProvince==NO)
    {
        self.selectHospitalRequest = [BBHospitalRequest hospitalListWithKey:key withCityId:nil withProvinceId:nil];
        [selectHospitalRequest setDelegate:self];
        [selectHospitalRequest setDidFinishSelector:@selector(loadDataFinished:)];
        [selectHospitalRequest setDidFailSelector:@selector(loadDataFail:)];
        [selectHospitalRequest startAsynchronous];
    }
    else
    {
        self.selectHospitalRequest = [BBHospitalRequest hospitalListWithCity:key withProvinceName:nil withHospitalId:nil];
        [selectHospitalRequest setDelegate:self];
        [selectHospitalRequest setDidFinishSelector:@selector(loadDataFinished:)];
        [selectHospitalRequest setDidFailSelector:@selector(loadDataFail:)];
        [selectHospitalRequest startAsynchronous];
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
    [self.selectHospitalRequest clearDelegatesAndCancel];
    self.selectHospitalRequest = nil;
    self.hud = nil;
    self.selectHospitalTableView = nil;
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
    return [requestData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BBSelectHospitalAreaCell";    
    BBSelectHospitalAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSelectHospitalAreaCell" owner:self options:nil] objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.rightImage setImage:[UIImage imageNamed:@"hospital_arrow"]];
    } 
    cell.text.text = [[requestData objectAtIndex:indexPath.row]stringForKey:@"name"];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[requestData objectAtIndex:indexPath.row] stringForKey:@"name"];
    NSString *hospitalId = [NSString stringWithFormat:@"%@",[[requestData objectAtIndex:indexPath.row] stringForKey:@"id"]];
    NSString *groupId = [NSString stringWithFormat:@"%@",[[requestData objectAtIndex:indexPath.row] stringForKey:@"group_id"]];
    NSDictionary *category = [[[NSDictionary alloc] initWithObjectsAndKeys:name, kHospitalNameKey, hospitalId, kHospitalHospitalIdKey, groupId, kHospitalGroupIdKey, nil] autorelease];
    [BBHospitalRequest setHospitalCategory:category];
    [BBHospitalRequest setAddedHospitalName:name];
    [BBHospitalRequest setPostSetHospital:@"1"];
    BBMainPage *homePageCtrl = [[[BBMainPage alloc] initWithNibName:@"BBMainPage" bundle:nil] autorelease];
//    BBAppDelegate *appDelegate = (BBAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *allViewControllers = [[[NSMutableArray alloc]init]autorelease];
    [allViewControllers addObject:homePageCtrl];
//    [appDelegate.navigationCtrl setViewControllers:allViewControllers animated:YES];
//    appDelegate.homePageCtrl = homePageCtrl;
}


- (void)loadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *requestListData = [parser objectWithString:responseString error:&error];
    NSString *status = [requestListData stringForKey:@"status"];
    if(error == nil){
        if ([status isEqualToString:@"success"]) {
            //变化部分扔出去 
            if(!hud.isHidden){
                hud.labelText = @"加载完成";
                [hud hide:YES afterDelay:0.2];
            }
            [requestData addObjectsFromArray:[[requestListData dictionaryForKey:@"data"]arrayForKey:@"list"]];
            [selectHospitalTableView reloadData];
        }else{
            if(!hud.isHidden){
                [hud hide:YES];
            }
            [AlertUtil showAlert:@"提示！" withMessage:status];
        }
    }else{
        if(!hud.isHidden){
            [hud hide:YES];
        }
        [AlertUtil showAlert:@"提示！" withMessage:@"加载数据失败"];
    }
}
- (void)loadDataFail:(ASIHTTPRequest *)request
{
    if(!hud.isHidden){
        [hud hide:YES];
    }
    NSError *error = [request error];
    [AlertUtil showErrorAlert:@"亲，您的网络不给力啊" withError:error];
}

- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
