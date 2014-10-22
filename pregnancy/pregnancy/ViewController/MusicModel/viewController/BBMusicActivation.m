//
//  BBMusicActivation.m
//  pregnancy
//
//  Created by whl on 14-4-22.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBMusicActivation.h"
#import "ZXScanMusicQR.h"
#import "BBSupportTopicDetail.h"

#define TOP_BUTTON_Y (86)
#define BOTTOM_BUTTOM_Y (151)

@interface BBMusicActivation ()
@property (nonatomic, retain) HMNoDataView *m_NoDataView;
@end

@implementation BBMusicActivation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _m_ScanDic = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = @"";
    if([self.m_ScanDic count]>0)
    {
        title = [self.m_ScanDic stringForKey:@"sec_title"];
        NSString *description = [self.m_ScanDic stringForKey:@"sec_description"];
        NSString *buyMark = [self.m_ScanDic stringForKey:@"sec_buy_button"];
        NSString *scanMark = [self.m_ScanDic stringForKey:@"sec_scan_mark"];
        
        if(![title isNotEmpty] || ![description isNotEmpty] || ![buyMark isNotEmpty] || ![scanMark isNotEmpty])
        {
            self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_DATAERROR];
            [self.view addSubview:self.m_NoDataView];
            self.m_NoDataView.m_ShowBtn = NO;
            self.m_NoDataView.delegate = self;
            self.m_NoDataView.hidden = NO;
        }
        else
        {
            self.reminderLabel.text = description;
            [self.buyPregnancyBoxButton setTitle:buyMark forState:UIControlStateNormal];
            [self.scanMarkButton setTitle:scanMark forState:UIControlStateNormal];
            
        }
    }
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:title]];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    ((UIButton*)[self.view viewWithTag:100]).exclusiveTouch = YES;
    ((UIButton*)[self.view viewWithTag:101]).exclusiveTouch = YES;
    
    [self refreshButtonLocation];
    
    self.buyPregnancyBoxButton.exclusiveTouch = YES;
    self.scanMarkButton.exclusiveTouch = YES;

}

- (void)refreshButtonLocation{

    if ([[self.m_ScanDic stringForKey:@"jump_url"] isNotEmpty]) {
        
        self.buyPregnancyBoxBgView.hidden = NO;
        self.scanMarkBgView.hidden = NO;
        
        self.buyPregnancyBoxBgView.top = TOP_BUTTON_Y;
        self.scanMarkBgView.top = BOTTOM_BUTTOM_Y;
        
    }else{
        
        self.buyPregnancyBoxBgView.hidden = YES;
        self.scanMarkBgView.hidden = NO;
        
        self.scanMarkBgView.top = TOP_BUTTON_Y;
    }

}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)boxActivation:(id)sender
{
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:[_m_ScanDic stringForKey:@"jump_url"]];
    NSString *title = @"";
    if([self.m_ScanDic count]>0)
    {
        title = [self.m_ScanDic stringForKey:@"buy_title"];
    }
    [exteriorURL setTitle:title];
    [self.navigationController pushViewController:exteriorURL animated:YES];
   
}

-(IBAction)scanActivation:(id)sender
{
    ZXScanMusicQR *scan = [[ZXScanMusicQR alloc] initWithNibName:nil bundle:nil];
    scan.categoryInfo = self.m_ScanDic;
    [self.navigationController pushViewController:scan animated:YES];
}

@end
