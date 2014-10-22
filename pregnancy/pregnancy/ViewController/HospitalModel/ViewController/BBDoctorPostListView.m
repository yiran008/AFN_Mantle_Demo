//
//  BBNewBirthclubListView.m
//  pregnancy
//
//  Created by babytree babytree on 12-5-10.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBDoctorPostListView.h"
#import "BBSelectMoreArea.h"
#import "HMShowPage.h"

#define kHospitalDoctorPostCoverImgTag 59822

@implementation BBDoctorPostListView

@synthesize navigationTitle;
@synthesize headTitleLabel;
@synthesize groupId;
@synthesize bbDoctorPostListViewData;
@synthesize listView;
@synthesize doctorData;

- (void)dealloc
{
    [navigationTitle release];
    [headTitleLabel release];
    [groupId release];
    [bbDoctorPostListViewData release];
    [listView release];
    [doctorData release];
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = [NSString stringWithFormat:@"%@医生的讨论", [self.doctorData stringForKey:@"name"]];
    self.view.backgroundColor = UI_VIEW_BGCOLOR;

    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:navigationTitle]];


    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.exclusiveTouch = YES;
    [commitButton setFrame:CGRectMake(0, 0, 40, 30)];
    [commitButton setImage:[UIImage imageNamed:@"community_pulish_h"] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(createTopic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];

    //创建模板
   self.bbDoctorPostListViewData = [[[BBDoctorPostListViewData alloc]init]autorelease];
    //初始化模板数据
    bbDoctorPostListViewData.doctorName = [self.doctorData stringForKey:@"name"];
    bbDoctorPostListViewData.groupId = self.groupId;
    bbDoctorPostListViewData.refreshTopicCallBackHandler = self;
    //初始化代理样式
    BBTopicListViewCell *topicListViewCell = [[[BBTopicListViewCell alloc]init]autorelease];
    //初始化listView需要传入样式和数据，其中withBBListViewContent要求是继承BBListViewInfo且实现BBListViewDataDelegate
    self.listView = [[[BBListView alloc] initWithFrame:CGRectMake(0, 36, 320, IPHONE5_ADD_HEIGHT(380)) withBBListViewCellDelegate:topicListViewCell withBBListViewData:bbDoctorPostListViewData]autorelease];
    listView.viewCtrl = self;
    topicListViewCell.listView = listView;
    [self.view addSubview:listView];
    
    listView.refreshSetImageBg = self;
    UIImageView *coverImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, IPHONE5_ADD_HEIGHT(390))] autorelease];
    [coverImage setImage:[UIImage imageNamed:@"hospital_cover_img5.png"]];
    coverImage.tag = kHospitalDoctorPostCoverImgTag;
    coverImage.hidden = YES;
    [listView addSubview:coverImage];
    
    [self.listView refresh];
    
    self.headTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8, 12, 260, 14)]autorelease];
    headTitleLabel.text = navigationTitle;
    [headTitleLabel setTextColor:[UIColor blackColor]];
    [headTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headTitleLabel setFont:[UIFont systemFontOfSize:15]];
    UIView *headView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 36)]autorelease];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:headTitleLabel];
    [self.view addSubview:headView];
    
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
    // Return YES for supported orientations
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


#pragma mark - BBRefreshSetImageBg
-(void)refreshSetImageBg:(id) object
{
    UIImageView *imageView = (UIImageView *)[listView viewWithTag:kHospitalDoctorPostCoverImgTag];
    if (self.listView.requestData != nil && self.listView.requestData.count > 0) {
        imageView.hidden = YES;
    }
    else {
        imageView.hidden = NO;
    }
}


#pragma mark - IBAction Event Handler Mehthod

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginFinish
{
    [HMShowPage showCreateTopic:self circleId:self.groupId circleName:self.navigationTitle];
}

- (void)callback
{
    [HMShowPage showCreateTopic:self circleId:self.groupId circleName:self.navigationTitle];
}

- (void)createTopic
{
    if([BBUser isLogin])
    {
      [HMShowPage showCreateTopic:self circleId:self.groupId circleName:self.navigationTitle];
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

- (void)refreshCallBack:(NSString *)count{
    headTitleLabel.text = [NSString stringWithFormat:@"%@(%@帖)",navigationTitle,count];
}

- (void)refreshCallBack{
    [self.listView addTopicRefresh];
}
@end
