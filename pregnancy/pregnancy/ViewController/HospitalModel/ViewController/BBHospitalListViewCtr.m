//
//  BBHospitalListViewCtr.m
//  pregnancy
//
//  Created by mac on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalListViewCtr.h"
#import "BBHospitalCell.h"
#import "BBSetHostpital.h"
#import "BBSelectHospitalArea.h"
#import "HMCircleClass.h"
#import "HMShowPage.h"



@interface BBHospitalListViewCtr ()

@end

@implementation BBHospitalListViewCtr

@synthesize hospitalArray, hospitalTable, myRequest, hud, city,hospitalId,searchText,isSearch,inputActionBar,cityInfo,isBackClickSwitchCityBtn;

- (void)dealloc
{
    [hospitalArray release];
    [hospitalTable release];
    [hud release];
    [city release];
    [hospitalId release];
    [myRequest clearDelegatesAndCancel];
    [myRequest release];
    [searchText release];
    [inputActionBar release];
    [cityInfo release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isSearch = NO;
        isBackClickSwitchCityBtn = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView * imgv = (UIImageView *)[self.view viewWithTag:999];
    imgv.image = [[UIImage imageNamed:@"search_kuang"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 5, 15)];
    [self.searchText setInputAccessoryView:self.inputActionBar];
    if (city!=nil) {
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:[NSString stringWithFormat:@"%@所有医院",self.city]]];
    }
    else {
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"同城医院信息"]];
    }
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.exclusiveTouch = YES;
    [rightButton setFrame:CGRectMake(252, 0, 64, 29)];
    [rightButton setTitle:@"切换城市" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton addTarget:self action:@selector(switchCity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [rightBarButton release];
    
    self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:hud];
    [self refreshData];
    
    //iphone5适配
    IPHONE5_ADAPTATION
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


- (void)refreshData
{
    if (self.hospitalArray == nil) 
    {
        [hud setLabelText:@"加载中..."];
        [hud show:YES];
        
        if (self.myRequest != nil) {
            [self.myRequest clearDelegatesAndCancel];
        }
        if (self.city !=nil)
        {
            self.myRequest = [BBHospitalRequest hospitalListWithCity:self.city withProvinceName:nil withHospitalId:nil];
            [myRequest setDelegate:self];
            [myRequest setDidFinishSelector:@selector(connectFinished:)];
            [myRequest setDidFailSelector:@selector(connectFail:)];
            [myRequest startAsynchronous];
        }
        else 
        {
            self.myRequest = [BBHospitalRequest hospitalListWithCity:nil withProvinceName:nil withHospitalId:self.hospitalId];
            [myRequest setDelegate:self];
            [myRequest setDidFinishSelector:@selector(connectFinished:)];
            [myRequest setDidFailSelector:@selector(connectFail:)];
            [myRequest startAsynchronous];
        }
    }
}

- (IBAction)backAction:(id)sender
{
    if ([self.hud isShow]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchCity:(id)sender
{
    if (isBackClickSwitchCityBtn) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        BBSelectHospitalArea *selectHospitalArea = [[BBSelectHospitalArea alloc] initWithNibName:@"BBSelectHospitalArea" bundle:nil];
        [self.navigationController pushViewController:selectHospitalArea animated:YES];
        [selectHospitalArea release];
    }
    
}

#pragma mark-- ASIFormDataRequest
- (void)connectFinished:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if ([[parserData stringForKey:@"status"] isEqualToString:@"success"]) {
        NSDictionary *resultData = [parserData dictionaryForKey:@"data"];
        self.hospitalArray =(NSMutableArray *)[resultData arrayForKey:@"list"];
        [self.hospitalTable reloadData];
        if (isSearch==YES) {
            [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.searchText.text]];
        }
    } else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[parserData stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)connectFail:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark-- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    
    if (isSearch) {
        number = hospitalArray.count + 1;
    }else {
        number = hospitalArray.count;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.hospitalArray.count && isSearch==YES) {
        NSString *addCellStr = @"addCell";
        UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:addCellStr];
        if (addCell == nil) {
            addCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCellStr] autorelease];
            [addCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addButton.exclusiveTouch = YES;
            addButton.frame = CGRectMake(10, 5, 300, 41);
            [addButton setBackgroundImage:[UIImage imageNamed:@"hospital_add_hospital.png"] forState:UIControlStateNormal];
            [addButton setBackgroundImage:[UIImage imageNamed:@"hospital_add_hospital_pressed.png"] forState:UIControlStateHighlighted];
            [addButton setTitle:@"添加医院信息" forState:UIControlStateNormal];
            [addButton setTitle:@"添加医院信息" forState:UIControlStateHighlighted];
            [addButton setTitleColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [addButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [addButton addTarget:self action:@selector(addHospitalAction:) forControlEvents:UIControlEventTouchUpInside];
            [addCell addSubview:addButton];
            
            UILabel *remind = [[[UILabel alloc]initWithFrame:CGRectMake(10, 52, 300, 26)]autorelease];
            [remind setBackgroundColor:[UIColor clearColor]];
            [remind setFont:[UIFont systemFontOfSize:11]];
            [remind setTextAlignment:NSTextAlignmentCenter];
            remind.text = @"如果您的医院没有在选取列表中点击此处添加";
            [addCell addSubview:remind];
        }
        
        return addCell;
    }
    else 
    {
        NSString *doctorCell = @"BBHospitalCell";
        BBHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:doctorCell];
        if (cell == nil) 
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BBHospitalCell" owner:self options:nil] objectAtIndex:0];
            cell.viewCtrl = self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }   
        
        NSDictionary *item = [hospitalArray objectAtIndex:indexPath.row];
        [cell setData:item];
        
        return cell;
    }
}

#pragma mark-- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.hospitalArray.count && isSearch ==YES)
    {
        return 81;
    }
    else {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.hospitalArray.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary *item = [hospitalArray objectAtIndex:indexPath.row];
        HMCircleClass *circleObj  = [[[HMCircleClass alloc]init]autorelease];
        circleObj.m_HospitalID = [item stringForKey:@"id"];
        circleObj.circleId = [item stringForKey:@"group_id"];
        circleObj.circleTitle = [item stringForKey:@"name"];
        [HMShowPage showCircleTopic:self circleClass:circleObj];

    }
}

#pragma mark - eventAction
- (void)addHospitalAction:(id)sender
{
    if([BBUser isLogin])
    {
        BBSetHostpital *setHospitalView = [[[BBSetHostpital alloc] initWithNibName:@"BBSetHostpital" bundle:nil] autorelease];
        [self.navigationController pushViewController:setHospitalView animated:YES];
    }
    else
    {
        BBLogin *login = [[[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil]autorelease];
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[[BBCustomNavigationController alloc]initWithRootViewController:login]autorelease];
        [navCtrl setColorWithImageName:@"navigationBg"];
        login.delegate = self;
        [self.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];
    }
}

#pragma mark - CallBack
- (void)callback
{
    BBSetHostpital *setHospitalView = [[[BBSetHostpital alloc] initWithNibName:@"BBSetHostpital" bundle:nil] autorelease];
    [self.navigationController pushViewController:setHospitalView animated:YES];
}

- (void)loginFinish
{
    BBSetHostpital *setHospitalView = [[[BBSetHostpital alloc] initWithNibName:@"BBSetHostpital" bundle:nil] autorelease];
    [self.navigationController pushViewController:setHospitalView animated:YES];
}

- (IBAction)cancelInput:(id)sender
{
    [self.searchText resignFirstResponder];
}

- (IBAction)search:(id)sender
{
    [self.searchText resignFirstResponder];
    if ( [self.searchText.text length]  < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入不能为空请输入关键字！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    isSearch = YES;
    [hud setLabelText:@"加载中..."];
    [hud show:YES];
    
    if (self.myRequest != nil) {
        [self.myRequest clearDelegatesAndCancel];
    }
    if (cityInfo==nil) {
        self.myRequest = [BBHospitalRequest hospitalListWithKey:self.searchText.text withCityId:nil withProvinceId:nil];
        [myRequest setDelegate:self];
        [myRequest setDidFinishSelector:@selector(connectFinished:)];
        [myRequest setDidFailSelector:@selector(connectFail:)];
        [myRequest startAsynchronous];
    }else {
        NSString *cityName = [cityInfo stringForKey:@"name"];
        if ([cityName rangeOfString:@"北京"].length >0 || [cityName rangeOfString:@"天津"].length >0 || [cityName rangeOfString:@"上海"].length >0 || [cityName rangeOfString:@"重庆"].length >0) {
            self.myRequest = [BBHospitalRequest hospitalListWithKey:self.searchText.text withCityId:nil withProvinceId:[cityInfo stringForKey:@"province_id"]];
            [myRequest setDelegate:self];
            [myRequest setDidFinishSelector:@selector(connectFinished:)];
            [myRequest setDidFailSelector:@selector(connectFail:)];
            [myRequest startAsynchronous];
        }else {
            self.myRequest = [BBHospitalRequest hospitalListWithKey:self.searchText.text withCityId:[cityInfo stringForKey:@"id"] withProvinceId:nil];
            [myRequest setDelegate:self];
            [myRequest setDidFinishSelector:@selector(connectFinished:)];
            [myRequest setDidFailSelector:@selector(connectFail:)];
            [myRequest startAsynchronous];
        }
    }
}

@end
