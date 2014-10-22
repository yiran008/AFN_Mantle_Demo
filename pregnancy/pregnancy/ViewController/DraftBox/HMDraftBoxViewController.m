//
//  BBDraftBoxViewController.m
//  pregnancy
//
//  Created by mac on 13-5-7.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#if COMMON_USE_DRATFBOX

#import "HMDraftBoxViewController.h"
#import "HMNavigation.h"
#import "BBUser.h"
#import "HMDraftBoxDB.h"
//#import "HMShadeGuideControl.h"
#import "HMShowPage.h"

@interface HMDraftBoxViewController ()

@end

@implementation HMDraftBoxViewController
@synthesize m_TableView;
@synthesize m_MessageArray;
@synthesize m_NoDataView;

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
//    self.umeng_VCname = @"草稿箱页面";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBar:@"草稿箱" bgColor:nil leftTitle:nil leftBtnImage:@"backButton" leftToucheEvent:@selector(backAction:) rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
    
    if (!m_TableView)
    {
        self.m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
        [m_TableView setDelegate:self];
        [m_TableView setDataSource:self];
        [m_TableView setClipsToBounds:YES];
        [m_TableView setShowsVerticalScrollIndicator:NO];
        [m_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [m_TableView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:m_TableView];
    }

    self.m_NoDataView = [[HMNoDataView alloc] initWithType:HMNODATAVIEW_CUSTOM];
    [self.m_TableView addSubview:self.m_NoDataView];
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.delegate = self;
    self.m_NoDataView.hidden = YES;

    if (!m_MessageArray)
    {
        self.m_MessageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [self freshMessageData];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)freshMessageData
{
    self.m_NoDataView.hidden = YES;

    //NSLog(@"freshMessageData");
    if (m_TableView)
    {
        [m_MessageArray removeAllObjects];
        [m_MessageArray addObjectsFromArray:[HMDraftBoxDB getDraftBoxDBSendList:[BBUser getEncId] isSending:NO]];
    
        [m_TableView reloadData];
        
        //NSLog(@"m_MessageArray count = %d", m_MessageArray.count);
        
        if ([m_MessageArray isNotEmpty])
        {
//            [HMShadeGuideControl controlWithDraftBox];
        }
        else
        {
            self.m_NoDataView.m_MessageType = HMNODATAMESSAGE_PROMPT_DRAFT;
            self.m_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
            self.m_NoDataView.m_PromptImage = [UIImage imageNamed:@"nodata_caogao"];
            self.m_NoDataView.hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshMessageData) name:DIDCHANGE_DRAFTBOX object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDCHANGE_DRAFTBOX object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_MessageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messageCellIdentifier = @"draftCellIdentifier";

    HMDraftBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMDraftBoxCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellStyle];
    }
    
    NSInteger index = indexPath.row;
    HMDraftBoxData *draftBoxData = [m_MessageArray objectAtIndex:index];
    
    [cell setCellContent:draftBoxData];
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    //NSLog(@"select is %d",index);
    HMDraftBoxData *draftBoxData = [m_MessageArray objectAtIndex:index];

    if (draftBoxData.m_IsReply)
    {
        /*
        HMReplyTopic *replyTopic = [[[HMReplyTopic alloc]initWithNibName:@"BBReplyTopic" bundle:nil] autorelease];
        [self.navigationController pushViewController:replyTopic animated:YES];
        [replyTopic setMessageWithDraft:draftBoxData];
         */
    }
    else
    {
        [HMShowPage showCreateTopic:self delegate:self draft:draftBoxData];
    }
}


#pragma mark - HMNoDataViewDelegate

-(void)freshFromNoDataView
{
    [self freshMessageData];
}


#pragma mark -
#pragma mark HMCreateTopicViewControllerDelegate

- (void)createTopicViewControllerDidFinished:(HMCreateTopicViewController *)createTopicViewController
{
    [self freshMessageData];
}


#pragma mark -
#pragma mark HMDraftBoxCellDelegate

- (void)draftBoxCellDidSelected:(HMDraftBoxCell *)circleCell
{
    NSIndexPath *cellIndexPath = [self.m_TableView indexPathForCell:circleCell];
    [self tableView:self.m_TableView didSelectRowAtIndexPath:cellIndexPath];
}

- (void)draftBoxCell:(HMDraftBoxCell *)circleCell changeTopState:(BOOL)topState
{
    if (topState)
    {
        NSArray *cellArray = self.m_TableView.visibleCells;
        
        for (HMDraftBoxCell *cell in cellArray)
        {
            if (cell.m_CellStateLeft && cell != circleCell)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    [cell resetCellStateLeft];
                }];
                
                break;
            }
        }
    }
}


- (void)deleteDraft:(HMDraftBoxData *)draftBoxData
{        
    if ([HMDraftBoxDB removeDraftBoxDB:draftBoxData])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_DRAFTBOX object:nil];
    }
    
    //[self freshMessageData];
}

@end

#endif

