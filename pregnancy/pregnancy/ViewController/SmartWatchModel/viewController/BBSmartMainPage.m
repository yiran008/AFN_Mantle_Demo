//
//  BBSmartMainPage.m
//  pregnancy
//
//  Created by whl on 13-11-13.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBSmartMainPage.h"
#import "BBSupportTopicDetail.h"
@interface BBSmartMainPage ()

@end

@implementation BBSmartMainPage

- (void)dealloc
{
    [_relieveBindRequest clearDelegatesAndCancel];
    [_relieveBindRequest release];
    [_loadProgress release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"孕期手表B-Smart"];
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
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.exclusiveTouch = YES;
    [rightItemButton setFrame:CGRectMake(0, 0, 72, 34)];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightItemButton setTitle:@"关于手表" forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(aboveSmart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [self.navigationItem setRightBarButtonItem:commitBarButton];
    [commitBarButton release];
    
    self.loadProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.loadProgress];
}

- (IBAction)backAction:(id)sender
{
//    for (UIViewController *viewCtrl in [self.navigationController viewControllers])
//    {
//        if ([viewCtrl isKindOfClass:[BBMainPage class]]) {
//            [self.navigationController popToViewController:viewCtrl animated:YES];
//            break;
//        }
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)aboveSmart:(id)sender
{
#if USE_SMARTWATCH_MODEL
    [MobClick event:@"watch_v2" label:@"关于手表"];
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:[NSString stringWithFormat:@"%@/watch/mpay.php",BABYTREE_URL_SERVER]];
    [exteriorURL setTitle:@"宝宝树B－Smart手表"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
    [exteriorURL release];
#endif
}


- (IBAction)smartWeightPage:(id)sender
{
    [MobClick event:@"watch_v2" label:@"体重记录"];
    BBSmartWeighetView *smartWeightView = [[[BBSmartWeighetView alloc]initWithNibName:@"BBSmartWeighetView" bundle:nil] autorelease];
    [self.navigationController pushViewController:smartWeightView animated:YES];
}
- (IBAction)smartContraction:(id)sender
{
    [MobClick event:@"watch_v2" label:@"宫缩计数"];
    BBSmartContractionView *smartContractionView = [[[BBSmartContractionView alloc]initWithNibName:@"BBSmartContractionView" bundle:nil] autorelease];
    [self.navigationController pushViewController:smartContractionView animated:YES];
}
- (IBAction)smartFetalMove:(id)sender
{
    [MobClick event:@"watch_v2" label:@"胎动计数"];
    BBSmartFetalmoveView *smartFetalmoveView = [[[BBSmartFetalmoveView alloc]initWithNibName:@"BBSmartFetalmoveView" bundle:nil] autorelease];
    [self.navigationController pushViewController:smartFetalmoveView animated:YES];
}
- (IBAction)smartTakeWalk:(id)sender
{
    [MobClick event:@"watch_v2" label:@"散步记录"];
    BBSmartTakeWalkView *smartTakeWalkView = [[[BBSmartTakeWalkView alloc]initWithNibName:@"BBSmartTakeWalkView" bundle:nil] autorelease];
    [self.navigationController pushViewController:smartTakeWalkView animated:YES];
}

-(IBAction)smartInstructions:(id)sender
{
#if USE_SMARTWATCH_MODEL
    BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
    exteriorURL.isShowCloseButton = NO;
    [exteriorURL setLoadURL:[NSString stringWithFormat:@"%@/watch/mintroduce.php",BABYTREE_URL_SERVER]];
    [exteriorURL setTitle:@"手表说明"];
    [self.navigationController pushViewController:exteriorURL animated:YES];
    [exteriorURL release];
#endif
}


-(IBAction)relieveWatchBind:(id)sender
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"确认解除绑定吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] autorelease];
    alertView.tag = 122;
    [alertView show];
    
}

-(void)relieveWatchBildRequest
{
    [self.loadProgress show:YES];
    [self.relieveBindRequest clearDelegatesAndCancel];
    self.relieveBindRequest = [BBSmartRequest relieveWatchBinding];
    [self.relieveBindRequest setDidFinishSelector:@selector(relieveWatchBindFinish:)];
    [self.relieveBindRequest setDidFailSelector:@selector(relieveWatchBindFail:)];
    [self.relieveBindRequest setDelegate:self];
    [self.relieveBindRequest startAsynchronous];

}

- (void)relieveWatchBindFinish:(ASIFormDataRequest *)request
{
     [self.loadProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *jsonData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[jsonData stringForKey:@"status"] isEqualToString:@"success"] || [[jsonData stringForKey:@"status"] isEqualToString:@"user_has_not_bind_the_watch"]) {
        [BBUser setSmartWatchCode:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)relieveWatchBindFail:(ASIFormDataRequest *)request
{
    [self.loadProgress hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 122){
        if (buttonIndex == 1) {
            [self relieveWatchBildRequest];
        }
        
    }
}


@end
