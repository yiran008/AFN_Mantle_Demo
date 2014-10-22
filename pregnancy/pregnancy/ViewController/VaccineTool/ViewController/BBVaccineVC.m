//
//  BBVaccineVC.m
//  pregnancy
//
//  Created by Heyanyang on 14-9-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBVaccineVC.h"
#import "BBVaccineCell.h"
#import "BBSupportTopicDetail.h"
#import "BBAutoCalculationSize.h"

static NSString *fileName = @"vaccineData.plist";
static float topViewHeight = 36.0;
static float topViewTop = 0.0;

@interface BBVaccineVC ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    BBVaccineCellDelegate
>
{
    BOOL isRedColor;
    NSInteger CountdownNum;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *s_TableView;

@end

@implementation BBVaccineVC

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
    [self addCustomNav];
    [self addTableView];
    [self tableViewDataSourceInit];
}

-(void)addCustomNav
{
    self.navigationItem.title = @"疫苗时间表";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    backButton.exclusiveTouch = YES;
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (void)addTopView
{
    CGFloat theFontSize = 15.0f;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, topViewTop, 320, topViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *CountdownIcon = [[UIImageView alloc]initWithFrame:CGRectMake(130, 11, 14, 14)];
    CountdownIcon.image = [UIImage imageNamed:@"vaccine_icon_countDownIcon@2x"];
    [topView addSubview:CountdownIcon];
    
    UILabel *ageStageStrLabelLeft = [[UILabel alloc]initWithFrame:CGRectMake(CountdownIcon.right+3, 0, 120, topViewHeight)];
    ageStageStrLabelLeft.font = [UIFont systemFontOfSize:theFontSize];
    ageStageStrLabelLeft.textColor = [UIColor colorWithHex:0x858585];
    ageStageStrLabelLeft.text = [NSString stringWithFormat:@"%@",@"距离下次疫苗还有"];
    [topView addSubview:ageStageStrLabelLeft];
    
    CGSize rect = CGSizeMake(MAXFLOAT, topViewHeight);
    CGSize size = [BBAutoCalculationSize  autoCalculationSizeRect:rect withFont:[UIFont systemFontOfSize:theFontSize] withString:[NSString stringWithFormat:@"%d",CountdownNum]];
    UILabel *ageStageStrLabelMiddle = [[UILabel alloc]initWithFrame:CGRectMake(ageStageStrLabelLeft.right, 0, size.width, topViewHeight)];
    ageStageStrLabelMiddle.font = [UIFont systemFontOfSize:theFontSize];
    ageStageStrLabelMiddle.textColor = [UIColor colorWithHex:0xFF537B];
    ageStageStrLabelMiddle.text = [NSString stringWithFormat:@"%d",CountdownNum];
    [topView addSubview:ageStageStrLabelMiddle];

    UILabel *ageStageStrLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(ageStageStrLabelMiddle.right, 0, 15, topViewHeight)];
    ageStageStrLabelRight.font = [UIFont systemFontOfSize:theFontSize];
    ageStageStrLabelRight.textColor = [UIColor colorWithHex:0x858585];
    ageStageStrLabelRight.text = [NSString stringWithFormat:@"%@",@"天"];
    [topView addSubview:ageStageStrLabelRight];

    UIView *downLineView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.height, UI_SCREEN_WIDTH, 1)];
    downLineView.backgroundColor = [UIColor colorWithHex:0xBFBFBF];
    [topView addSubview:downLineView];
    
    self.s_TableView.top += topViewHeight;
    self.s_TableView.height -= topViewHeight;
}

- (void)addTableView
{
    self.s_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topViewTop, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    self.s_TableView.backgroundColor = [UIColor clearColor];
    self.s_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.s_TableView.dataSource = self;
    self.s_TableView.delegate = self;
    self.s_TableView.bounces = YES;
    [self.view addSubview:self.s_TableView];
}

- (void)tableViewDataSourceInit
{
    NSString *sandboxFilePath = getDocumentsDirectoryWithFileName(fileName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:sandboxFilePath])
    {
        // copy local file to sandbox
        NSString *localPlistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@",fileName];
        NSError *error;
        [fileManager copyItemAtPath:localPlistPath toPath:sandboxFilePath error:&error];
    }
    NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:sandboxFilePath];
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    int scrollPositionNum = 0;
    for (NSArray *subInRootArray in rootArray)
    {
        NSMutableArray *subInDataArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *vaccineDic in subInRootArray)
        {
            BBVaccineClass *item = [[BBVaccineClass alloc]init];
            item.m_ageStage = vaccineDic[@"ageStage"];
            item.m_doTimesStr = vaccineDic[@"doTimesStr"];
            item.m_isFree = [vaccineDic[@"isFree"] boolValue];
            item.m_isNeed = [vaccineDic[@"isNeed"] boolValue];
            item.m_remark = vaccineDic[@"remark"];
            item.m_tag = [vaccineDic[@"tag"] boolValue];
            item.m_vaccineName = vaccineDic[@"vaccineName"];
            item.m_introduceID = vaccineDic[@"introduceID"];
            item.m_offsetMonth = vaccineDic[@"offsetMonth"];
            
            NSInteger offsetMonthInt = [item.m_offsetMonth integerValue];
            NSDate *currentOffsetMonthDate = [[BBPregnancyInfo dateOfPregnancy] offsetMonth:offsetMonthInt];
            if([currentOffsetMonthDate compareWithAnotherDate:[NSDate getCurrentDateWithSystemTimeZone]] == NSOrderedDescending && !isRedColor)
            {
                item.m_isRemind = YES;
                isRedColor = YES;
                CountdownNum = [[NSDate getCurrentDateWithSystemTimeZone] distanceInDaysToDate:currentOffsetMonthDate]+1;
            }
            CGSize rect = CGSizeMake(MAXFLOAT, 22);
            CGSize size = [BBAutoCalculationSize  autoCalculationSizeRect:rect withFont:[UIFont systemFontOfSize:16.0] withString:item.m_vaccineName];
            item.m_vaccineNameStrWitdh = size.width;
            
            [subInDataArray addObject:item];
        }
        [[subInDataArray lastObject] setM_isHiddenCellLine:YES];
        [self.dataArray addObject:subInDataArray];
        if (!isRedColor)
        {
            scrollPositionNum++;
        }
    }
    
    if (self.dataArray.count > 0)
    {
        if (([BBUser getNewUserRoleState] == BBUserRoleStatePregnant || [BBUser getNewUserRoleState] == BBUserRoleStateHasBaby) && isRedColor)
        {
            [self addTopView];
        }
        [self.s_TableView reloadData];
        if (isRedColor)
        {
            [self.s_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:scrollPositionNum] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }

    }
    else
    {
        [PXAlertView showAlertWithTitle:@"数据错误，请稍后再试！"];
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tmpArr = self.dataArray[section];
    return tmpArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"headerViewId";
    UIView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!sectionHeaderView)
    {
        sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 28+16)];
        sectionHeaderView.backgroundColor = [UIColor whiteColor];
   
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 12)];
        grayView.backgroundColor = [UIColor colorWithHex:0xF0EFF3];
        [sectionHeaderView addSubview:grayView];
        
        if (section != 0)
        {
            UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1)];
            topLineView.backgroundColor = [UIColor colorWithHex:0xBFBFBF];
            [grayView addSubview:topLineView];
        }

        UIView *downLineView = [[UIView alloc]initWithFrame:CGRectMake(0, grayView.height-1, UI_SCREEN_WIDTH, 1)];
        downLineView.backgroundColor = [UIColor colorWithHex:0xBFBFBF];
        [grayView addSubview:downLineView];
        
        NSArray *tmpArr = self.dataArray[section];
        if (tmpArr.count >0)
        {
            BBVaccineClass *item = tmpArr[0];
            NSString *ageStageStr = item.m_ageStage;
            NSInteger offsetMonthInt = [item.m_offsetMonth integerValue];
            NSDate *currentOffsetMonthDate = [[BBPregnancyInfo dateOfPregnancy] offsetMonth:offsetMonthInt];
            
            CGFloat leftPadding = 18.0f;
            CGFloat addPadding = 0.0f;
            if (([BBUser getNewUserRoleState] == BBUserRoleStatePregnant || [BBUser getNewUserRoleState] == BBUserRoleStateHasBaby) && isRedColor)
            {
                UILabel *dateStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftPadding, 19, 128, 23)];
                dateStrLabel.font = [UIFont systemFontOfSize:17];
                dateStrLabel.textColor = [UIColor colorWithHex:0x999797];
                dateStrLabel.text = [BBPregnancyInfo pregnancyDateByStringWithDate: currentOffsetMonthDate];
                if (item.m_isRemind)
                {
                    dateStrLabel.textColor = [UIColor colorWithHex:0xFF537B];
                }
                [sectionHeaderView addSubview:dateStrLabel];
                
                addPadding = dateStrLabel.width + 14;
            }

            UILabel *ageStageStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftPadding + addPadding, 19, 180, 23)];
            ageStageStrLabel.font = [UIFont systemFontOfSize:17];
            ageStageStrLabel.textColor = [UIColor colorWithHex:0x999797];
            ageStageStrLabel.text = ageStageStr;
            if (item.m_isRemind && ([BBUser getNewUserRoleState] == BBUserRoleStatePregnant || [BBUser getNewUserRoleState] == BBUserRoleStateHasBaby))
            {
                ageStageStrLabel.textColor = [UIColor  colorWithHex:0xFF537B];
            }
            [sectionHeaderView addSubview:ageStageStrLabel];
        }
    }
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"BBVaccineCell";
    
    BBVaccineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBVaccineCell" owner:self options:nil] lastObject];
        cell.delegate = self;
       [cell makeCellStyle];
        
    }

    if (indexPath.section < self.dataArray.count && indexPath.row < [self.dataArray[indexPath.section] count])
    {
        BBVaccineClass *item = self.dataArray[indexPath.section][indexPath.row];
        [cell setCellContent:item];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataArray.count && indexPath.row < [self.dataArray[indexPath.section] count])
    {
        BBVaccineClass *item = self.dataArray[indexPath.section][indexPath.row];
        
        [MobClick event:@"tool_vaccine_v2" label:@"名词解释点击次数"];
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        exteriorURL.isShowCloseButton = NO;
        NSString *localUrlStr =[NSString stringWithFormat:@"vaccineIntroduce%@.html",item.m_introduceID];
        [exteriorURL setLoadURL:localUrlStr];
        [exteriorURL setTitle:item.m_vaccineName];
        [self.navigationController pushViewController:exteriorURL animated:YES];
    }
}

#pragma mark -
#pragma mark BBVaccineCell Delegate

-(void)pressTagButtonWithClass:(BBVaccineClass *)vaccineClass updateSuccess:(void (^)(BOOL))success
{
    [MobClick event:@"tool_vaccine_v2" label:@"checkbox点击次数"];
    int i = 0;
    for (NSArray *subArr in self.dataArray)
    {
        int j = 0;
        for (BBVaccineClass *item in subArr)
        {
            if ([vaccineClass isEqual:item])
            {
                NSString *sandboxFilePath = getDocumentsDirectoryWithFileName(fileName);
                NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:sandboxFilePath];
                NSMutableDictionary *dic = rootArray[i][j];
                BOOL tag = [dic[@"tag"] boolValue];
                [dic setBool:!tag forKey:@"tag"];
                BOOL isSuccess = [rootArray writeToFile:sandboxFilePath atomically:YES];
                if (isSuccess)
                {
                    item.m_tag = !item.m_tag;
                    success(YES);
                }
                return;
            }
            j++;
        }
        i++;
    }
}

#pragma mark -
#pragma mark memoryWaring

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
