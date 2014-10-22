//
//  BBToolsNewVC.m
//  pregnancy
//
//  Created by liumiao on 9/15/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBToolsNewVC.h"
#import "BBToolsRequest.h"
#import "BBToolOpreation.h"
#import "BBToolCell.h"
#import "BBToolCollectionHeader.h"
#import "BBToolCollectionFooter.h"
#import "BBSupportTopicDetail.h"

#define TOOL_COUNT_PER_ROW_DEFAULT 3
#define TOOL_MIN_WIDTH 56
#define TOOL_MIN_HEIGHT 96
#define BOTTOM_VIEW_TAG 999
#define SELECT_URL_ALERT_TAG 200
#define CUSTOM_URL_ALERT_TAG 201
#define RENSHOU_URL_NAME @"http://www-int2.sino-life.com/SL_LEM/thirdPartyHandel/main.do?loginId=BBTREE"
#define RENSHOU_URL_IP @"http://192.168.9.166:45040/SL_LEM/thirdPartyHandel/main.do?loginId=BBTREE"
static NSString *toolCellIdentifier = @"BBToolCell";
static NSString *toolHeaderIdentifier = @"BBToolCollectionHeader";
static NSString *toolFooterIdentifier = @"BBToolCollectionFooter";

@interface BBToolsNewVC ()<BBToolOpreationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *s_ToolCollectionView;

@property (nonatomic,strong)NSMutableDictionary *s_ToolsData;

@property (nonatomic,strong)NSArray *s_KindArray;

@property (nonatomic,strong)NSDictionary *s_ToolNewStateDict;

// 请求绑定手表状态的request
@property (nonatomic, strong) ASIFormDataRequest *s_BindStatusRequest;

// 获取工具页列表request
@property (nonatomic, strong) ASIFormDataRequest *s_GetToolsListRequest;

@property (nonatomic, assign)NSInteger s_ToolCountPerRow;

@end

@implementation BBToolsNewVC

@synthesize s_ToolOperation;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"工具";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    [self.view setBackgroundColor:RGBColor(239, 239, 244, 1)];
    [self.s_ToolCollectionView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [topView setBackgroundColor:RGBColor(239, 239, 244, 1)];
    [self.s_ToolCollectionView addSubview:topView];
    [self.s_ToolCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    
    self.s_ToolsData = [[NSMutableDictionary alloc]init];
    self.s_KindArray = [[NSArray alloc]init];
    self.s_ToolOperation  = [[BBToolOpreation alloc]init];
    self.s_ToolCountPerRow = TOOL_COUNT_PER_ROW_DEFAULT;
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([BBToolCell class]) bundle:[NSBundle mainBundle]];
    [self.s_ToolCollectionView registerNib:cellNib forCellWithReuseIdentifier:toolCellIdentifier];
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([BBToolCollectionHeader class]) bundle:[NSBundle mainBundle]];
    [self.s_ToolCollectionView registerNib:headerNib  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:toolHeaderIdentifier];
    
    UINib *footerNib = [UINib nibWithNibName:NSStringFromClass([BBToolCollectionFooter class]) bundle:[NSBundle mainBundle]];
    [self.s_ToolCollectionView registerNib:footerNib  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:toolFooterIdentifier];
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *renshouItem = [[UIBarButtonItem alloc]initWithTitle:@"人寿  " style:UIBarButtonItemStyleBordered target:self action:@selector(renshouButtonClicked)];
        renshouItem;
    });
        
}

-(void)renshouButtonClicked
{
    UIAlertView *selectUrlAlert = [[UIAlertView alloc]initWithTitle:@"人寿URL" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"www-int2.sino-life.com",@"192.168.9.166:45040",@"自定义URL", nil];
    selectUrlAlert.tag = SELECT_URL_ALERT_TAG;
    [selectUrlAlert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == SELECT_URL_ALERT_TAG)
    {
        NSInteger firstOtherIndex = [alertView firstOtherButtonIndex];
        if (buttonIndex == firstOtherIndex)
        {
            [self pushWebViewOfUrl:RENSHOU_URL_NAME];
        }
        else if (buttonIndex == firstOtherIndex+1)
        {
            [self pushWebViewOfUrl:RENSHOU_URL_IP];
        }
        else if (buttonIndex == firstOtherIndex+2)
        {
            UIAlertView *customUrlAlert = [[UIAlertView alloc]initWithTitle:@"输入新URL" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [customUrlAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            customUrlAlert.tag = CUSTOM_URL_ALERT_TAG;
            UITextField *inputTextField = [customUrlAlert textFieldAtIndex:0];
            inputTextField.text = RENSHOU_URL_NAME;
            inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [customUrlAlert show];
        }
    }
    else if (alertView.tag == CUSTOM_URL_ALERT_TAG)
    {
        NSInteger firstOtherIndex = [alertView firstOtherButtonIndex];
        if (buttonIndex == firstOtherIndex)
        {
            UITextField *inputTextField = [alertView textFieldAtIndex:0];
            NSString *url = inputTextField.text;
            [self pushWebViewOfUrl:url];
        }
    }
}

-(void)pushWebViewOfUrl:(NSString*)url
{
    NSString *trimedUrl = [url trim];
    if ([trimedUrl isNotEmpty])
    {
        BBSupportTopicDetail *exteriorURL = [[BBSupportTopicDetail alloc] initWithNibName:@"BBSupportTopicDetail" bundle:nil];
        exteriorURL.isShowCloseButton = NO;
        exteriorURL.hidesBottomBarWhenPushed = YES;
        [exteriorURL setLoadURL:trimedUrl];
        [self.navigationController pushViewController:exteriorURL animated:YES];
    }
}

-(void)adjustBottomView
{
    UIView *bottomView = [self.s_ToolCollectionView viewWithTag:BOTTOM_VIEW_TAG];
    CGFloat height = [self.s_ToolCollectionView.collectionViewLayout collectionViewContentSize].height;
    if (height < self.s_ToolCollectionView.height)
    {
        height = self.s_ToolCollectionView.height;
    }
    if (bottomView == nil || !bottomView.superview)
    {
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, height, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [bottomView setBackgroundColor:RGBColor(239, 239, 244, 1)];
        [self.s_ToolCollectionView addSubview:bottomView];
        bottomView.tag = BOTTOM_VIEW_TAG;
    }
    else
    {
        bottomView.top = height;
    }
}

-(void)reloadData
{
    self.s_ToolNewStateDict = [BBToolOpreation toolsState];
    [self.s_ToolCollectionView reloadData];
    [self adjustBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_s_BindStatusRequest clearDelegatesAndCancel];
    [_s_GetToolsListRequest clearDelegatesAndCancel];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateToolList];
    [self updateBindStatus];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSDictionary *toolState = [BBToolOpreation toolsState];
    BOOL needReset = NO;
    //检查是否需要刷新页面
    for (NSString *key in [self.s_ToolsData allKeys])
    {
        NSMutableArray *toolModelsArray = [self.s_ToolsData objectForKey:key];
        for (BBToolModel* model in toolModelsArray)
        {
            if ([toolState boolForKey:model.name])
            {
                [BBToolOpreation setToolsState:NO forTool:model.name];
                needReset = YES;
            }
        }
    }

    if (needReset)
    {
        [self reloadData];
    }
}

#pragma mark- 更新工具数据

-(void)updateToolList
{
    //由于最新的工具页数据可能已经在外部更新了，所以每次进入页面都要重新读取一次最新的数据并刷新页面
    NSDictionary *localActionDataDict = [BBToolOpreation getToolActionDataOfType:ToolPageTypeTool];
    
    if ([self successHandleToolData:localActionDataDict])
    {
        [self reloadData];
        [BBToolOpreation setToolActionData:localActionDataDict ofType:ToolPageTypeTool];
    }
    //发请求。。。
    [self.s_GetToolsListRequest clearDelegatesAndCancel];
    self.s_GetToolsListRequest  = [BBToolsRequest getToolsListRequest:@"toolpage"];
    [self.s_GetToolsListRequest setDelegate:self];
    [self.s_GetToolsListRequest setDidFailSelector:@selector(getToolsListRequestFailed:)];
    [self.s_GetToolsListRequest setDidFinishSelector:@selector(getToolsListRequestFinished:)];
    [self.s_GetToolsListRequest startAsynchronous];
}

-(BOOL)successHandleToolData:(NSDictionary*)toolDict
{
    self.s_ToolCountPerRow = [[toolDict stringForKey:@"column_count"] intValue]==0 ? TOOL_COUNT_PER_ROW_DEFAULT:[[toolDict stringForKey:@"column_count"] intValue];
    
    NSArray *totalToolArray = [toolDict arrayForKey:@"tool_list"];
    
    NSArray *kindArray = [toolDict arrayForKey:@"tool_type_list"];
    if ([kindArray count] == 0)
    {
        return NO;
    }
    NSArray *filteredArray = [BBToolOpreation getCurrentVersionSupportedToolsArray:totalToolArray];
    if ([filteredArray count] == 0)
    {
        return NO;
    }
    // 通过比较得知哪些是新工具
    NSMutableArray *oldToolTotalArray = [[NSMutableArray alloc]init];
    for (NSString *key in [self.s_ToolsData allKeys])
    {
        NSMutableArray *toolModelsArray = [self.s_ToolsData objectForKey:key];
        [oldToolTotalArray addObjectsFromArray:toolModelsArray];
    }
    if ([oldToolTotalArray count] != 0)
    {
        [BBToolOpreation compareOldTools:oldToolTotalArray withNewTools:filteredArray];
    }

    // [孕育工具, 育儿工具, 其它工具, ...]
    self.s_KindArray = [[NSArray alloc]initWithArray:kindArray];
    
    NSMutableSet *toolTypeSet = [NSMutableSet set];
    for (NSDictionary *aTypeDict in self.s_KindArray)
    {
        NSString *type = [aTypeDict stringForKey:@"name"];
        if ([type isNotEmpty])
        {
            [toolTypeSet addObject:type];
        }
    }
    [self.s_ToolsData removeAllObjects];
    for (BBToolModel *toolModel in filteredArray)
    {
        if ([toolModel.toolKind isNotEmpty] && [toolTypeSet containsObject:toolModel.toolKind])
        {
            NSMutableArray *toolModelsArray = (NSMutableArray*)[self.s_ToolsData objectForKey:toolModel.toolKind];
            if ([toolModelsArray isNotEmpty])
            {
                [toolModelsArray addObject:toolModel];
                [self.s_ToolsData setObject:toolModelsArray forKey:toolModel.toolKind];
            }
            else
            {
                NSMutableArray *aNewItemsArray = [[NSMutableArray alloc]initWithObjects:toolModel, nil];
                [self.s_ToolsData setObject:aNewItemsArray forKey:toolModel.toolKind];
            }
            
        }
    }
    if ([self.s_ToolsData isDictionaryAndNotEmpty])
    {
        return YES;
    }
    return NO;
}

- (void)getToolsListRequestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *responseData = [parser objectWithString:responseString error:&error];
    if (error != nil)
    {
        return;
    }
    if ([[responseData stringForKey:@"status"] isEqualToString:@"success"])
    {
        //数据返回
        NSDictionary *data = [responseData dictionaryForKey:@"data"];
        if ([self successHandleToolData:data])
        {
            [self reloadData];
            [BBToolOpreation setToolActionData:data ofType:ToolPageTypeTool];
        }
    }
    else
    {
        //[AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
    }
}

- (void)getToolsListRequestFailed:(ASIFormDataRequest *)request
{
    //[AlertUtil showAlert:@"提示！" withMessage:@"亲，您的网络不给力！"];
}

#pragma mark- 获取手表绑定状态

- (void)updateBindStatus
{
    if ([BBUser isLogin])
    {
        [self.s_BindStatusRequest clearDelegatesAndCancel];
        self.s_BindStatusRequest = [BBSmartRequest bindStatus];
        [self.s_BindStatusRequest setDelegate:self];
        [self.s_BindStatusRequest setDidFinishSelector:@selector(bindStatusFinish:)];
        [self.s_BindStatusRequest setDidFailSelector:@selector(bindStatusFail:)];
        [self.s_BindStatusRequest startAsynchronous];
    }
}

- (void)bindStatusFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"]) {
        
        NSString *bluetoothMac = [[data dictionaryForKey:@"data"] stringForKey:@"bluetooth_mac"];
        if ([bluetoothMac isEqualToString:@""]) {
            bluetoothMac = nil;
        }
        if ([BBUser smartWatchCode] == nil && bluetoothMac != nil) {
            [BBUser setSmartWatchCode:bluetoothMac];
        }else if([BBUser smartWatchCode] != nil && bluetoothMac == nil){
            [BBUser setSmartWatchCode:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的账号已经在其他设备上与手表解绑" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)bindStatusFail:(ASIFormDataRequest *)request
{
    
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section >=0 && section < [self.s_KindArray count])
    {
        NSString *toolKindKey = [[self.s_KindArray objectAtIndex:section] stringForKey:@"name"];
        NSArray *toolModelsArray = [self.s_ToolsData arrayForKey:toolKindKey];
        return [toolModelsArray count];
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:toolCellIdentifier forIndexPath:indexPath];
    if (indexPath.section >=0 && indexPath.section < [self.s_KindArray count])
    {
        NSString *toolKindKey = [[self.s_KindArray objectAtIndex:indexPath.section]stringForKey:@"name"];
        NSArray *toolModelsArray = [self.s_ToolsData arrayForKey:toolKindKey];
        if (indexPath.row >= 0 && indexPath.row < [toolModelsArray count])
        {
            BBToolModel *model = [toolModelsArray objectAtIndex:indexPath.row];
            if ([self.s_ToolNewStateDict boolForKey:model.name])
            {
                [cell.m_ToolButton setNewState:YES];
            }
            else
            {
                [cell.m_ToolButton setNewState:NO];
            }
            [cell.m_ToolButton setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:model.holderImg?[UIImage imageNamed:model.holderImg]:nil];
            cell.m_ToolButton.m_IndexData = indexPath;
            cell.m_ToolButton.exclusiveTouch = YES;
            [cell.m_ToolButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.m_ToolNameLabel setText:model.name];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.s_KindArray count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BBToolCollectionFooter *tempFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:toolFooterIdentifier forIndexPath:indexPath];
    if (indexPath.section >=0 && indexPath.section < [self.s_KindArray count])
    {
        NSString *toolKindKey = [[self.s_KindArray objectAtIndex:indexPath.section] stringForKey:@"name"];
        NSArray *toolModelsArray = [self.s_ToolsData arrayForKey:toolKindKey];
        if ([toolModelsArray count]>0)
        {
            if ([kind isEqualToString:UICollectionElementKindSectionHeader])
            {
                BBToolCollectionHeader *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:toolHeaderIdentifier forIndexPath:indexPath];
                headerview.m_ToolKindLabel.text = toolKindKey;
                [headerview.m_TopLine setBackgroundColor:RGBColor(239, 239, 244, 1)];
                UIColor *lineColor = [UIColor colorWithHex:0xbfbfbf];
                [headerview.m_TopLine.layer setBorderColor:lineColor.CGColor];
                [headerview.m_TopLine.layer setBorderWidth:0.5f];
                [headerview.m_BottomLine setBackgroundColor:[UIColor colorWithHex:0xbfbfbf]];
                [headerview.m_BottomLine setSize:CGSizeMake(308, 0.5)];
                return headerview;
            }
            else if([kind isEqualToString:UICollectionElementKindSectionFooter])
            {
                BBToolCollectionFooter *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:toolFooterIdentifier forIndexPath:indexPath];
                return footerview;
            }
        }
    }
    return tempFooter;
}
#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat calWidth = 320/self.s_ToolCountPerRow;
    return CGSizeMake(calWidth>TOOL_MIN_WIDTH?calWidth:TOOL_MIN_WIDTH, TOOL_MIN_HEIGHT);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section >=0 && section < [self.s_KindArray count])
    {
        NSString *toolKindKey = [[self.s_KindArray objectAtIndex:section]stringForKey:@"name"];
        NSArray *toolModelsArray = [self.s_ToolsData arrayForKey:toolKindKey];
        if ([toolModelsArray count]>0)
        {
            return CGSizeMake(320, 61);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section >=0 && section < [self.s_KindArray count])
    {
        NSString *toolKindKey = [[self.s_KindArray objectAtIndex:section] stringForKey:@"name"];
        NSArray *toolModelsArray = [self.s_ToolsData arrayForKey:toolKindKey];
        if ([toolModelsArray count]>0)
        {
            return CGSizeMake(320, 21);
        }
    }
    return CGSizeZero;
}

#pragma mark- 工具点击事件

-(void)toolAction:(BBBadgeButton*)sender
{
    id indexData = sender.m_IndexData;
    if (indexData != nil && [indexData isKindOfClass:[NSIndexPath class]])
    {
        NSIndexPath* indexPath = (NSIndexPath*)indexData;
        if (indexPath.section>=0 && indexPath.section<[self.s_KindArray count])
        {
            NSString *toolKindKey = [[self.s_KindArray objectAtIndex:indexPath.section] stringForKey:@"name"];
            
            NSArray *toolModelsArray = [self.s_ToolsData arrayForKey:toolKindKey];

            if (indexPath.row >=0 && indexPath.row < [toolModelsArray count])
            {
                BBToolModel *model = [toolModelsArray objectAtIndex:indexPath.row];
                [self.s_ToolOperation performActionOfTool:model target:self];
            }
            
        }
    }
}
@end
