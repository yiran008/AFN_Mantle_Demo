//
//  BBRecordMainPage.m
//  pregnancy
//
//  Created by babytree on 13-9-26.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBRecordMainPage.h"
#import "BBPublishRecord.h"
#import "BBCustemSegment.h"

@interface BBRecordMainPage ()

@property (strong, nonatomic) IBOutlet UIImageView *s_TopBgView;
@end

@implementation BBRecordMainPage

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_recordMoonView release];
    [_recordParkView release];
    [_s_TopBgView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecordMoonView:) name:UPADATE_RECORD_MOON_VIEW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecordParkView:) name:UPADATE_RECORD_PARK_VIEW object:nil];
    }
    return self;
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
    
    UIButton *addRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addRecordButton.exclusiveTouch = YES;
    [addRecordButton setFrame:CGRectMake(0, 0, 40, 30)];
    [addRecordButton setImage:[UIImage imageNamed:@"community_pulish_h"] forState:UIControlStateNormal];
    [addRecordButton addTarget:self action:@selector(addRecord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addRecordBarButton = [[UIBarButtonItem alloc] initWithCustomView:addRecordButton];
    [self.navigationItem setRightBarButtonItem:addRecordBarButton];
    [addRecordBarButton release];
    
    UIImage *tempImage=  [UIImage imageNamed:@"head_tab_bg"];
    self.s_TopBgView.image = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 3)];
    __block typeof (self) weakself = self;
    BBCustemSegment *segmented=[[[BBCustemSegment alloc] initWithFrame:CGRectMake(60, 9, 200, 26) items:@[@{@"text":@"我的心情",},@{@"text":@"心情广场"}]
                                                    andSelectionBlock:^(NSUInteger segmentIndex) {
                                                        __strong __typeof (weakself) strongself = weakself;
                                                        if (strongself)
                                                        {
                                                        if (segmentIndex == 0)
                                                        {
                                                            [strongself recordMoon];
                                                        }
                                                        else
                                                        {
                                                            [strongself recordPark];
                                                        }}}] autorelease];
    segmented.color = [UIColor whiteColor];
    segmented.borderWidth = 1.f;
    segmented.borderColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    segmented.selectedColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    segmented.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1]};
    segmented.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                         NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.view addSubview:segmented];
    
    if ([self.navigationItem.title isEqualToString:@"心情广场"]) {
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"心情广场"]];
        self.recordMoonView = [[[BBRecordMoonView alloc]initWithFrame:CGRectMake(0, 44, 320, IPHONE5_ADD_HEIGHT(372))]autorelease];
        [self.view addSubview:self.recordMoonView];
        [self.recordMoonView setHidden:YES];
        self.recordParkView = [[[BBRecordParkView alloc]initWithFrame:CGRectMake(0, 44, 320, IPHONE5_ADD_HEIGHT(372))]autorelease];
        [self.view addSubview:self.recordParkView];
        [self.recordParkView setHidden:NO];
        if ([self.recordParkView.dataArray count]==0) {
            [self.recordParkView refresh];
        }
    }else{
        [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"心情记录"]];
        [MobClick event:@"mood_v2" label:@"我的心情页面"];
        self.recordMoonView = [[[BBRecordMoonView alloc]initWithFrame:CGRectMake(0, 44, 320, IPHONE5_ADD_HEIGHT(372))]autorelease];
        [self.view addSubview:self.recordMoonView];
        [self.recordMoonView setHidden:NO];
        if ([self.recordMoonView.dataArray count]==0) {
            [self.recordMoonView refresh];
        }
        self.recordParkView = [[[BBRecordParkView alloc]initWithFrame:CGRectMake(0, 44, 320, IPHONE5_ADD_HEIGHT(372))]autorelease];
        [self.view addSubview:self.recordParkView];
        [self.recordParkView setHidden:YES];
    }
    
    IPHONE5_ADAPTATION
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRecord{
    BBPublishRecord *publishRecord = [[[BBPublishRecord alloc]initWithNibName:@"BBPublishRecord" bundle:nil]autorelease];
    BBCustomNavigationController *navCtrl = [[[BBCustomNavigationController alloc]initWithRootViewController:publishRecord]autorelease];
    [navCtrl setColorWithImageName:@"navigationBg"];
    [self.navigationController presentViewController:navCtrl animated:YES completion:^{
        
    }];
    
}
-(void)updateRecordMoonView:(NSNotification*)notify {
    NSDictionary *dic = notify.userInfo;
    if (dic == nil) {
        [self.recordMoonView refresh];
    }else{
    if ([[dic stringForKey:@"is_private"] isNotEmpty]) {
        [self uploadRecordTableViewData:self.recordMoonView.dataArray withModifyData:dic];
    }else{
        [self deleteRecordTableViewData:self.recordMoonView.dataArray withDeleteMoodID:[dic stringForKey:@"mood_id"]];
    }
        [self.recordMoonView.tableView reloadData];
    }
}
-(void)updateRecordParkView:(NSNotification*)notify {
    NSDictionary *dic = notify.userInfo;
    if ([self.recordParkView.dataArray count]>0) {
        [self deleteRecordTableViewData:self.recordParkView.dataArray withDeleteMoodID:[dic stringForKey:@"mood_id"]];
        [self.recordParkView.tableView reloadData];
    }
}
- (void)viewDidUnload {
    self.s_TopBgView = nil;
    [super viewDidUnload];
}

-(void)uploadRecordTableViewData:(NSMutableArray*)sourceArray withModifyData:(NSDictionary*)modifyDic{
    if ([sourceArray count]>0) {
        for (int i=0; i<[sourceArray count]; i++) {
            if ([[[sourceArray objectAtIndex:i] stringForKey:@"mood_id"]isEqualToString:[modifyDic stringForKey:@"mood_id"]])
            {
                 NSMutableDictionary *currentDic = [[[NSMutableDictionary alloc]init]autorelease];
                [[sourceArray objectAtIndex:i] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([key isEqualToString:@"is_private"] )
                    {
                        [[sourceArray objectAtIndex:i] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                            [currentDic setObject:obj forKey:key];
                        }];
                        [currentDic setObject:[modifyDic stringForKey:@"is_private"] forKey:key];
                    }
                }];
                 [sourceArray removeObjectAtIndex:i];
                 [sourceArray insertObject:currentDic atIndex:i];
                 break;
            }
        }
    }
}

-(void)deleteRecordTableViewData:(NSMutableArray*)sourceArray withDeleteMoodID:(NSString*)deleteMoodID{
    if ([sourceArray count]>0) {
        for (int i=0; i<[sourceArray count]; i++) {
            if ([[[sourceArray objectAtIndex:i] stringForKey:@"mood_id"]isEqualToString:deleteMoodID]) {
                [sourceArray removeObjectAtIndex:i];
                break;
            }
        }
    }
}


- (void)recordMoon
{
    [MobClick event:@"mood_v2" label:@"我的心情页面"];
    
    if ([self.recordMoonView.dataArray count]==0) {
        [self.recordMoonView refresh];
    }
    [self.navigationItem.rightBarButtonItem.customView setHidden:NO];
    [self.recordMoonView setHidden:NO];
    [self.recordParkView setHidden:YES];
     [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"心情记录"]];
    self.navigationItem.title = @"心情记录";
}

- (void)recordPark
{
    [MobClick event:@"mood_v2" label:@"心情广场列表页"];
    if ([self.recordParkView.dataArray count]==0) {
        [self.recordParkView refresh];
    }
    [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
    [self.recordMoonView setHidden:YES];
    [self.recordParkView setHidden:NO];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:@"心情广场"]];
    self.navigationItem.title = @"心情广场";
}
@end
