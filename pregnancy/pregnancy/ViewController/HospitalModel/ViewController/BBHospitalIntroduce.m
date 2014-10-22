//
//  BBHospitalIntroduce.m
//  pregnancy
//
//  Created by whl on 14-9-1.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBHospitalIntroduce.h"
#import "BBHospitalIntroduceView.h"
#import "BBCustemSegment.h"
#import "BBHospitalDoctorCell.h"
#import "BBDoctorPostListView.h"

@interface BBHospitalIntroduce ()

@property (nonatomic, strong) BBHospitalIntroduceView *s_HospitalIntroView;
@property (nonatomic, strong) NSMutableArray *s_DoctorArray;

@end

@implementation BBHospitalIntroduce

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
    [self setNavBar:@"关于医院" bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
    
    [self addCustemSegment];
    self.m_HosType = BBHosIntroduce;
    
    //添加医院介绍
    self.s_HospitalIntroView = [[[NSBundle mainBundle] loadNibNamed:@"BBHospitalIntroduceView" owner:self options:nil] objectAtIndex:0];
    self.s_HospitalIntroView.viewCtrl = self;
    self.s_HospitalIntroView.frame = CGRectMake(0, 45, 320, IPHONE5_ADD_HEIGHT(460));
    [self.s_HospitalIntroView initSubViewsWithHospitalId:self.m_HospitalID];
    [self.view addSubview:self.s_HospitalIntroView];

    //添加医生讨论
    self.m_Table.top = 44;
    self.m_Table.height = DEVICE_HEIGHT -108;

}

-(void)addCustemSegment
{
    __weak __typeof (self) weakself = self;
    
    NSArray *items = @[@{@"text":@"医院介绍"}, @{@"text":@"医生讨论"}];
    
    BBCustemSegment  *segmented = [[BBCustemSegment alloc] initWithFrame:CGRectMake(30, 10, 260, 26)
                                                  items:items
                                      andSelectionBlock:^(NSUInteger segmentIndex) {
                                          __strong __typeof (weakself) strongself = weakself;
                                          if (strongself)
                                          {
                                              if (strongself.m_HosType == segmentIndex)
                                              {
                                                  return;
                                              }
                                              
                                              if (segmentIndex == 0)
                                              {
                                                  strongself.m_HosType = BBHosIntroduce;
                                              }
                                              else if (segmentIndex == 1)
                                              {
                                                  strongself.m_HosType = BBHosDoctor;
                                              }
                                              [self setCurrentViewData];
                                        }
                                      }];
    segmented.color = [UIColor whiteColor];
    segmented.borderWidth = 1.f;
    segmented.borderColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    segmented.selectedColor = [UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1];
    segmented.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                  NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:83/255.0 blue:123/255.0 alpha:1]};
    segmented.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIImage *tempImage=  [UIImage imageNamed:@"head_tab_bg"];
    self.m_TopView.image = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 3)];
    [self.view addSubview:segmented];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setCurrentViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setCurrentViewData
{
    [self.s_HospitalIntroView setHidden:YES];
    [self.m_Table setHidden:YES];

    switch (self.m_HosType)
    {
        case BBHosIntroduce:
        {
            [MobClick event:@"discuz_v2" label:@"关于医院-医院介绍pv"];
            [self.s_HospitalIntroView setHidden:NO];
            [self.s_HospitalIntroView refreshData];
        }
            break;
        case BBHosDoctor:
        {
            [MobClick event:@"discuz_v2" label:@"关于医院-医生讨论pv"];
            [self.m_Table setHidden:NO];
            [self refreshData];
        }
            break;
            
        default:
            break;
    }
}

- (void)refreshData
{
    if (self.s_DoctorArray.count > 0)
    {
        return;
    }
    
    [self.m_ProgressHUD setLabelText:@"加载中..."];
    [self.m_ProgressHUD show:YES];
    
    [self.m_DataRequest clearDelegatesAndCancel];
    self.m_DataRequest = [BBHospitalRequest hospitalDoctorListWithHospitalId:self.m_HospitalID];
    [self.m_DataRequest setDelegate:self];
    [self.m_DataRequest setDidFinishSelector:@selector(connectFinished:)];
    [self.m_DataRequest setDidFailSelector:@selector(connectFail:)];
    [self.m_DataRequest startAsynchronous];
}

#pragma mark-- ASIFormDataRequest
- (void)connectFinished:(ASIFormDataRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self changeNoDataViewWithHiddenStatus:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
        return;
    }
    if ([[parserData stringForKey:@"status"] isEqualToString:@"success"])
    {
        self.s_DoctorArray = (NSMutableArray *) [[parserData dictionaryForKey:@"data"] arrayForKey:@"list"];
        if (self.s_DoctorArray.count == 0)
        {
            [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_PROMPT];

        }
        [self.m_Table reloadData];
    }
    else
    {
        [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_DATAERROR];
    }
}

- (void)connectFail:(ASIFormDataRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self changeNoDataViewWithHiddenStatus:NO withType:HMNODATAVIEW_NETERROR];

}


#pragma mark-- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.s_DoctorArray count] > 0)
    {
        return [self.s_DoctorArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *doctorCell = @"BBHospitalDoctorCell";
    BBHospitalDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:doctorCell];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBHospitalDoctorCell" owner:self options:nil] objectAtIndex:0];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < [self.s_DoctorArray count])
    {
        NSDictionary *item = [self.s_DoctorArray objectAtIndex:indexPath.row];
        [cell setData:item];
        cell.groupId = self.m_CircleID;
    }
    return cell;
}

#pragma mark-- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.s_DoctorArray count])
    {
        NSDictionary *item = [self.s_DoctorArray objectAtIndex:indexPath.row];
        
        BBDoctorPostListView *doctorPostListView = [[BBDoctorPostListView alloc] initWithNibName:@"BBDoctorPostListView" bundle:nil];
        doctorPostListView.doctorData = item;
        doctorPostListView.groupId = self.m_CircleID;
        [self.navigationController pushViewController:doctorPostListView animated:YES];
    }
}

#pragma mark - HMNoDataViewDelegate andOtherFunctions

-(void)freshFromNoDataView
{
    [self refreshData];
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus
{
    [self changeNoDataViewWithHiddenStatus:theHiddenStatus withType:HMNODATAVIEW_CUSTOM];
}

-(void)changeNoDataViewWithHiddenStatus:(BOOL)theHiddenStatus withType:(HMNODATAVIEW_TYPE)theType
{
    self.m_NoDataView.m_Type = theType;
    self.m_NoDataView.hidden = theHiddenStatus;
}



@end
