//
//  BBKuaidiPlaceSelectorViewController.m
//  pregnancy
//
//  Created by MAYmac on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBKuaidiPlaceSelectorViewController.h"
#import "BBKuaidiPlaceCell.h"
#import "BBCallTaxiRequest.h"

#define BAIDUAPI_PLACESUGGESTION @"http://api.map.baidu.com/place/v2/suggestion?region=131%20&output=json&ak=ZLbFas0HSSu7AHTQYoYfHbGZ"

@interface BBKuaidiPlaceSelectorViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
}
@property(nonatomic,retain)IBOutlet UITextField * inputTextField;
@property(nonatomic,retain)IBOutlet UITableView * searchTableView;
@property(nonatomic,retain)IBOutlet UIView * naviBar;
//当前搜索框里的有效文字
@property(nonatomic,retain)NSString * lastText;
//placeSuggest接口返回的列表
@property(nonatomic,retain)NSMutableArray * placesArr;
//百度placeSuggest接口请求
@property(nonatomic,retain)ASIFormDataRequest * suggestionRequest;
//当前的地理位置
@property(nonatomic,retain)NSString * geoPlaceStr;
//附近的位置
@property(nonatomic,retain)NSMutableArray * geoPlacesArr;
@property(nonatomic,retain)NSString * cityCode;
@property(nonatomic,retain)IBOutlet UIButton * submmitButton;

@end

@implementation BBKuaidiPlaceSelectorViewController

- (void)dealloc
{
    [_suggestionRequest clearDelegatesAndCancel];
    [_suggestionRequest release];
    [_inputTextField release];
    [_searchTableView release];
    [_lastText release];
    [_placesArr release];
    [_geoPlaceStr release];
    [_naviBar release];
    [_cityCode release];
    [_submmitButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(3, 7, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:backButton];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.exclusiveTouch = YES;
    [back setFrame:CGRectMake(0, 7, 40, 30)];
    [back setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    self.inputTextField.delegate = self;
    [self.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.searchTableView.frame = CGRectMake(self.searchTableView.frame.origin.x, self.searchTableView.frame.origin.y, self.searchTableView.frame.size.width, self.view.height);
    
    UITapGestureRecognizer *tapGr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]autorelease];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    self.view.exclusiveTouch = YES;
    
    self.cityCode = [self.geocoderPalcesDic objectForKey:@"cityCode"];
    if (self.placeSelectorType == BBKuaidiPlaceSelectorTypeEnd)
    {
        self.geocoderPalcesDic = nil;
    }
    
    if (self.geocoderPalcesDic)
    {
        self.geoPlaceStr = [self.geocoderPalcesDic stringForKey:@"formatted_address"];
        self.geoPlacesArr = (NSMutableArray *)[self.geocoderPalcesDic arrayForKey:@"pois"];
    }
    [self.navigationController.navigationBar addSubview: self.naviBar];
    
    self.submmitButton.exclusiveTouch = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)startSugestionRequest
{
    [self.suggestionRequest clearDelegatesAndCancel];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/suggestion?region=%@&output=json&ak=%@",self.cityCode,BAIDU_API_AK]];
    self.suggestionRequest = [ASIFormDataRequest requestWithURL:url];
    [self.suggestionRequest setGetValue:self.lastText forKey:@"query"];
    [self.suggestionRequest setRequestMethod:@"GET"];
    [self.suggestionRequest setDidFinishSelector:@selector(suggestionDataFinish:)];
    [self.suggestionRequest setDidFailSelector:@selector(suggestionDatafail:)];
    [self.suggestionRequest setDelegate:self];
    [self.suggestionRequest startAsynchronous];
}

//监测输入变化
- (void) textFieldDidChange:(id) sender
{
    UITextField *field = (UITextField *)sender;
    if (![[field text]isEqualToString:self.lastText])
    {
        self.lastText = [field text];
        [self startSugestionRequest];
        
        if(self.inputTextField.text && self.inputTextField.text.length)
        {
            self.submmitButton.hidden = NO;
        }else
        {
            self.submmitButton.hidden = YES;
        }
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.inputTextField resignFirstResponder];
}

- (IBAction)backAction:(id)sender
{
    [self.naviBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submmitCurrText:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeSelectedWithPlace:type:)])
    {
        [self.delegate placeSelectedWithPlace:self.inputTextField.text type:self.placeSelectorType];
        //完成工作退出页面
        [self.naviBar removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - requestMethod

- (void)suggestionDataFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[jsonDictionary stringForKey:@"status"]integerValue] == 0)
    {
        self.placesArr = (NSMutableArray *)[jsonDictionary arrayForKey:@"result"];
        self.geoPlacesArr = nil;
        [self.searchTableView reloadData];
    }
}

- (void)suggestionDatafail:(ASIFormDataRequest *)request
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //第一个section是用反解析的数据第一条
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.geoPlaceStr)
        {
            return 1;
        }
    }
    else if (section == 1)
    {
        if (self.placesArr && [self.placesArr count])
        {
            return [self.placesArr count];
        }
        else if(self.geoPlacesArr)
        {
            return [self.geoPlacesArr count];
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identifier = @"BBKuaidiPlaceCell";
        BBKuaidiPlaceCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:
                                 identifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BBKuaidiPlaceCell" owner:self options:nil] objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
        }
        [cell setGeoStrData:self.geoPlaceStr];
        return cell;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"BBKuaidiPlaceCell";
        BBKuaidiPlaceCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:
                                 SimpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BBKuaidiPlaceCell" owner:self options:nil] objectAtIndex:0];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
        }
        if (self.placesArr && indexPath.row < [self.placesArr count])
        {
            [cell setSugestData:[self.placesArr objectAtIndex:indexPath.row]];
        }
        else if(self.geoPlacesArr && indexPath.row < self.geoPlacesArr.count)
        {
            [cell setGeoArrData:[self.geoPlacesArr objectAtIndex:indexPath.row]];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(placeSelectedWithPlace:type:)])
        {
            [self.delegate placeSelectedWithPlace:self.geoPlaceStr type:self.placeSelectorType];
        }
    }
    else
    {
        if(self.placesArr && [self.placesArr count])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(placeSelectedWithPlace:type:)])
            {
                [self.delegate placeSelectedWithPlace:[[self.placesArr objectAtIndex:indexPath.row]stringForKey:@"name"] type:self.placeSelectorType];
            }
        }
        else if(self.geoPlacesArr)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(placeSelectedWithPlace:type:)])
            {
                [self.delegate placeSelectedWithPlace:[[self.geoPlacesArr objectAtIndex:indexPath.row]stringForKey:@"name"] type:self.placeSelectorType];
            }
        }
    }
    //完成工作退出页面
    [self.naviBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
//滑动列表隐藏键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.inputTextField resignFirstResponder];
}

#pragma mark- textFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
