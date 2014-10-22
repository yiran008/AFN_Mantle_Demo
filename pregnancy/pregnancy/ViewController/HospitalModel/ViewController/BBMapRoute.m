//
//  BBMapRoute.m
//  pregnancy
//
//  Created by babytree babytree on 12-10-25.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBMapRoute.h"

@interface BBMapRoute ()

@end

@implementation BBMapRoute
@synthesize hospitalLatitude;
@synthesize hospitalLongitude;
@synthesize hospitalName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.hospitalName;

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:hospitalName]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    ///////// 请参阅：正则表达式 相关概念
    // 正则表达式，是指一个用来描述或者匹配一系列符合某个句法规则的字符串的单个字符串。
    // 在很多文本编辑器或其他工具里，正则表达式通常被用来检索和/或替换那些符合某个模式的文本内容。许多程序设计语言都支持利用正则表达式进行字符串操作。
    /*    
     1.将RegexKitLite类添加到工程中。
     2.工程中添加libicucore.dylib frameworks。
     3.现在所有的nsstring对象就可以调用RegexKitLite中的方法了。
     */  
    NSString *email = @"wujian1360@163.com";
    NSLog(@"%d",[email isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"]);
    //返 回YES，证明是email格式，需要注意的是RegexKitLite用到的正则表达式和wiki上的略有区别。
    
    NSString *searchString = @"http://www.example.com:8080/index.html";
    NSString *regexString  = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSInteger portInteger = [[searchString stringByMatching:regexString capture:1L] integerValue];
    NSLog(@"portInteger: ‘%ld’", (long)portInteger);
    //portInteger: ‘8080′,求端口号
    // 2008-10-15 08:52:52.500 host_port[8021:807] portInteger: ‘8080′
    //取 string中http的例子。
    
	MapView* mapView = [[[MapView alloc] initWithFrame:
						 CGRectMake(0, 0, self.view.frame.size.width, IPHONE5_ADD_HEIGHT(self.view.frame.size.height))] autorelease];
	
	[self.view addSubview:mapView];
	
	Place* p1 = [[[Place alloc] init] autorelease];
	p1.name = self.hospitalName;
	p1.description = self.hospitalName;
	p1.latitude = self.hospitalLatitude-0.0060;
	p1.longitude = self.hospitalLongitude-0.0065;
    PlaceMark *placeMark = [[[PlaceMark alloc] initWithPlace:p1] autorelease];
    [mapView.mapView addAnnotation:placeMark];

    //设置地图比例
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude=self.hospitalLatitude-0.0060;
    centerCoordinate.longitude = self.hospitalLongitude-0.0065;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate,3000,3000);
    MKCoordinateRegion adjustedRegion = [mapView.mapView regionThatFits:viewRegion];
    [mapView.mapView setRegion:adjustedRegion animated:YES];
//	Place* p2 = [[[Place alloc] init] autorelease];
//	p2.name = @"左岸公社";
//	p2.description = @"海淀桥";
//	p2.latitude = 39.984149;
//	p2.longitude = 116.305143;
//	[mapView showRouteFrom:p1 to:p2];
    
    //iphone5适配
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


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
