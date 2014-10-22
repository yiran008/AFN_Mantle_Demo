//
//  HMSearchVC.m
//  lama
//
//  Created by songxf on 13-12-30.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "HMSearchVC.h"
#import "HMNavigation.h"
#import "BBUser.h"
#import "HMSearchHistory.h"
#import "NSArray+Category.h"
#import "BBSearchRequest.h"

#import "BBSearchKnowledgeCell.h"
#import "BBSearchKnowledgeCellClass.h"
#import "BBSearchUserCell.h"
#import "BBSearchUserCellClass.h"
#import "HMTopicClass.h"
#import "HMTopicListCell.h"
#import "HMShowPage.h"
#import "BBPersonalViewController.h"
#import "BBKnowledgeLibDetailVC.h"


#define ITEM_BUTTON_HEIGHT 44
#define BUTTON_START_TAG 300

@interface HMSearchVC ()

@property (assign, nonatomic) BOOL isShowHistoryList;

@property (retain, nonatomic) NSString *curKeyword;


@end

@implementation HMSearchVC
@synthesize searchBarView;
@synthesize tabBgImageView;
@synthesize buttonImageView;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [searchBarView release];
    [tabBgImageView release];
    [buttonImageView release];
    [_curKeyword release];
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [searchBarView.textField resignFirstResponder];
    self.isShowKeyboard = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.isShowKeyboard)
    {
      [searchBarView.textField becomeFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = UI_VIEW_BGCOLOR;


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    HMSearchBarView *bar = [[[HMSearchBarView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - SEARCHBAR_MAXWIDTH), 0, SEARCHBAR_MAXWIDTH, 44)] autorelease];
    bar.backgroundColor = [UIColor clearColor];
    self.searchBarView = bar;
    self.searchBarView.delegate = self;
    searchBarView.textField.delegate = self;
    
    [self setNavBarTitleView:bar bgColor:nil leftTitle:nil leftBtnImage:nil leftToucheEvent:nil rightTitle:nil rightBtnImage:nil rightToucheEvent:nil];
    
    self.m_Table.height = DEVICE_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - ITEM_BUTTON_HEIGHT - UI_STATUS_BAR_HEIGHT;
    self.m_Table.top = ITEM_BUTTON_HEIGHT;
    self.m_Table.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:self.m_Table];
    
    // 铺切换tab层
    
    // 整体背景
    self.tabBgImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, ITEM_BUTTON_HEIGHT)] autorelease];
    UIImage *tempImage=  [UIImage imageNamed:@"head_tab_bg"];
    tabBgImageView.image = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 3)];
    [self.view addSubview:tabBgImageView];
    tabBgImageView.userInteractionEnabled = YES;
    
    // button背景
    self.buttonImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 300, 26)] autorelease];
    [tabBgImageView addSubview:buttonImageView];
    buttonImageView.userInteractionEnabled = YES;
    
    // 3个Tab切换按钮
    NSArray *titleArr = @[@"帖子", @"知识", @"用户"];
    for (NSInteger i=0; i<3; i++)
    {
        UIButton *typeBtn = [[[UIButton alloc] initWithFrame:CGRectMake(100*(i), 0, 100, 26)] autorelease];
        typeBtn.exclusiveTouch = YES;
        typeBtn.backgroundColor = [UIColor clearColor];
        [typeBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:123.0/255.0 alpha:1] forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [buttonImageView addSubview:typeBtn];
        [typeBtn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        typeBtn.tag = BUTTON_START_TAG+i;
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [typeBtn addTarget:self action:@selector(changeSearchType:) forControlEvents:UIControlEventTouchUpInside];
        typeBtn.exclusiveTouch = YES;
        if (i == enterSearchType)
        {
            [typeBtn setSelected:YES];
        }
    }
    [self updateTabButtonBgImage];
    
    [self.m_Table bringToFront];
    [self bringSomeViewToFront];
    
    self.isShowHistoryList = YES;
    
    self.m_NoDataView.m_OffsetY = 0;
}


- (void)updateTabButtonBgImage
{
    NSString *str = [NSString stringWithFormat:@"head_tab_btn%ld",(long)curSearchType+1];
    [buttonImageView setImage:[UIImage imageNamed:str]];
}

-(void)setIsShowHistoryList:(BOOL)isShowHistoryList
{
    _isShowHistoryList = isShowHistoryList;
    if (isShowHistoryList)
    {
        self.m_NoDataView.hidden = YES;
        self.m_Table.bounces = NO;
        self.m_Data = [NSMutableArray arrayWithArray:[HMSearchHistory getSearchHistory]];
        [self.m_Table reloadData];
    }
    else
    {
        self.m_Table.bounces = YES;
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

#pragma mark -
#pragma mark 手势收回键盘

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:[self view]];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        gesturePoint = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (location.y - gesturePoint.y >= 30)
        {
            [self.searchBarView.textField resignFirstResponder];
        }
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.searchBarView.textField resignFirstResponder];
}

#pragma mark -
#pragma mark tab change action

- (void)changeSearchType:(UIButton *)typeBtn
{
    NSInteger index = typeBtn.tag-BUTTON_START_TAG;
    if (index!= curSearchType)
    {

        UIButton *oldbtn = (UIButton *)[self.view viewWithTag:BUTTON_START_TAG+curSearchType];
        oldbtn.exclusiveTouch = YES;
        [oldbtn setSelected:NO];
        curSearchType = typeBtn.tag-BUTTON_START_TAG;
        typeBtn.selected = YES;
        [self searchItemWithKeyWord:self.searchBarView.textField.text];
        [self updateTabButtonBgImage];
    }
}

-(void)freshData
{
    if(curSearchType == HMSEARCH_TYPE_TOPIC)
    {
        [MobClick event:@"search_v2" label:@"搜索-帖子总次数"];
    }
    else if(curSearchType == HMSEARCH_TYPE_KNOWLEDGE)
    {
        [MobClick event:@"search_v2" label:@"搜索-知识总次数"];
    }
    else
    {
        [MobClick event:@"search_v2" label:@"搜索-用户总次数"];
    }
    s_LoadedPage = 1;

    if (self.m_Data == nil)
    {
        self.m_Data = [NSMutableArray array];
    }
    
    self.m_NoDataView.hidden = YES;
    
    [self loadNextData];

}

-(void)loadNextData
{
    _refresh_bottom_view.refreshStatus = NO;
    if (self.m_DataRequest!=nil)
    {
        [self.m_DataRequest clearDelegatesAndCancel];
    }
    
    switch (curSearchType)
    {
        case HMSEARCH_TYPE_TOPIC:
            
            [self.m_ProgressHUD setLabelText:@"正在搜索相关帖子"];
            [self.m_DataRequest setDelegate:nil];
            self.m_DataRequest = [BBSearchRequest searchTopicList:self.curKeyword page:s_LoadedPage];
            [self.m_DataRequest setDidFinishSelector:@selector(searchTopicFinished:)];
            [self.m_DataRequest setDidFailSelector:@selector(searchFail:)];
            break;
            
        case HMSEARCH_TYPE_KNOWLEDGE:

            [self.m_ProgressHUD setLabelText:@"正在搜索相关知识"];
            self.m_DataRequest = [BBSearchRequest searchKnowledgeList:self.curKeyword page:s_LoadedPage];
            [self.m_DataRequest setDidFinishSelector:@selector(searchKnowledgeFinished:)];
            [self.m_DataRequest setDidFailSelector:@selector(searchFail:)];
            break;
            
        case HMSEARCH_TYPE_USER:

            [self.m_ProgressHUD setLabelText:@"正在搜索相关用户"];
            self.m_DataRequest = [BBSearchRequest searchUserList:self.curKeyword page:s_LoadedPage];
            [self.m_DataRequest setDidFinishSelector:@selector(searchUserFinished:)];
            [self.m_DataRequest setDidFailSelector:@selector(searchFail:)];
            break;
    }
    
    [self.m_DataRequest setDelegate:self];
    [self.m_DataRequest startAsynchronous];
    [self.searchBarView setUserInputEnabled:NO];
    if ([self.m_Data count] == 0)
    {
        [self.m_ProgressHUD setLabelText:@"加载中..."];
        [self.m_ProgressHUD show:YES];
    }
    
    [self.searchBarView.textField resignFirstResponder];
}

- (BOOL)searchItemWithKeyWord:(NSString *)str
{
    if ([str trim].length == 0)
    {
        return NO;
    }
    
    self.isShowHistoryList = NO;
    self.curKeyword = [str trim];
    [self trimHistory];

    [self.m_Data removeAllObjects];
    [self.m_Table reloadData];

    [self freshData];
    

    return YES;
}

#pragma mark -
#pragma mark 检测已经缓存数据类型与当前tab是否出现差错
// 检测已经缓存数据类型与当前tab是否出现差错
- (BOOL)checkDataError
{
    if (self.m_Data.count)
    {
        id obj = [self.m_Data objectAtIndex:0];
        
        NSString *dataType = @"数据类型错误";
        if ([obj isKindOfClass:[NSString class]])
        {
            dataType = @"历史记录data";
        }
        else if ([obj isKindOfClass:[HMTopicClass class]])
        {
            dataType = @"帖子data";
        }
        else if ([obj isKindOfClass:[BBSearchKnowledgeCellClass class]])
        {
            dataType = @"知识data";
        }
        else if ([obj isKindOfClass:[BBSearchUserCellClass class]])
        {
            dataType = @"用户data";
        }
        
        NSString *curPageType = @"";
        BOOL isError = NO;
        if (self.isShowHistoryList)
        {
            curPageType = @"历史记录Type";
            if (![obj isKindOfClass:[NSString class]])
            {
                isError = YES;
            }
        }
        else
        {
            switch (curSearchType)
            {
                case HMSEARCH_TYPE_TOPIC:
                    curPageType = @"搜索帖子Type";
                    if (![obj isKindOfClass:[HMTopicClass class]])
                    {
                        isError = YES;
                    }
                    break;
                case HMSEARCH_TYPE_KNOWLEDGE:
                    curPageType = @"搜索知识Type";
                    if (![obj isKindOfClass:[BBSearchKnowledgeCellClass class]])
                    {
                        isError = YES;
                    }
                    break;
                case HMSEARCH_TYPE_USER:
                    curPageType = @"搜索用户Type";
                    if (![obj isKindOfClass:[BBSearchUserCellClass class]])
                    {
                        isError = YES;
                    }
                    break;
                default:
                    break;
            }
        }
        
        if (isError)
        {
            // 报告错误
            [MobClick event:@"error_check" label:[NSString stringWithFormat:@"发现%@对应%@",curPageType,dataType]];
        }
        return isError;
    }
    return NO;
}

// 检测load到的数据与当前tab是否出现差错
- (BOOL)checkLoadDataErrorWithType:(HMSEARCHTYPE)type
{
    NSString *dataType = @"帖子data";
    if (type == HMSEARCH_TYPE_KNOWLEDGE)
    {
        dataType = @"知识data";
    }
    else if (type == HMSEARCH_TYPE_USER)
    {
        dataType = @"用户data";
    }
    
    NSString *curPageType = @"历史记录Type";
    switch (curSearchType)
    {
        case HMSEARCH_TYPE_TOPIC:
            curPageType = @"搜索帖子Type";
            break;
        case HMSEARCH_TYPE_KNOWLEDGE:
            curPageType = @"搜索知识Type";
            break;
        case HMSEARCH_TYPE_USER:
            curPageType = @"搜索用户Type";
            break;
    }
    
    BOOL isError = NO;
    if (self.isShowHistoryList)
    {
        isError = YES;
    }
    if ( curSearchType != type)
    {
        isError = YES;
    }
    
    if (isError)
    {
        // 报告错误
        [MobClick event:@"error_check" label:[NSString stringWithFormat:@"load到不匹配%@的%@",curPageType,dataType]];
    }
    
    return isError;
}


#pragma mark -
#pragma mark 搜索结果检测

- (void)showNoDataNoticeWithType:(HMNODATAVIEW_TYPE)type withTitle:(NSString *)title
{
    self.m_NoDataView.m_Type = type;
    self.m_NoDataView.m_PromptText = title;
    self.m_NoDataView.m_ShowBtn = NO;
    self.m_NoDataView.hidden = NO;
}

- (BOOL)showNoDataNoticeWithType:(HMNODATAVIEW_TYPE)type
{
    if ((type == HMNODATAVIEW_DATAERROR || type == HMNODATAVIEW_NETERROR) && ![self.m_Data count])
    {
        self.m_NoDataView.m_Type = type;
        self.m_NoDataView.hidden = NO;
    }
    else if (self.m_Data.count == 0)
    {
        self.m_NoDataView.m_MessageType = HMNODATAMESSAGE_PROMPT_SEARCH;
        self.m_NoDataView.m_Type = HMNODATAVIEW_PROMPT;
        self.m_NoDataView.hidden = NO;
    }
    else
    {
        self.m_NoDataView.hidden = YES;
        return NO;
    }
    return YES;
}



#pragma mark -
#pragma mark search request delete

// 搜索帖子
- (void)searchTopicFinished:(ASIHTTPRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self.searchBarView setUserInputEnabled:YES];
    [self hideEGORefreshView];
    
    // 如果数据与当前的展示tab不匹配，不解析数据，不清理已经缓存数据
    if ([self checkLoadDataErrorWithType:HMSEARCH_TYPE_TOPIC])
    {
        return;
    }
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
    if (![dictData isDictionaryAndNotEmpty])
    {
        [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:@"数据错误"];
        return ;
    }
    
    if ([[dictData objectForKey:@"status"] isEqualToString:@"success"])
    {
        [MobClick event:@"search_v2" label:@"搜索成功总次数"];
        s_LoadedTotalCount = [dictData intForKey:@"total"];
        if ([[[dictData objectForKey:@"data"] arrayForKey:@"list"] count] == 0 && self.m_Data.count == 0)
        {
            [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:[NSString stringWithFormat:@"%@\n%@",@"抱歉,",@"没有找到相关的内容，换个词重新搜索吧"]];
        }
        else
        {
            if (s_LoadedPage == 1)
            {
                [self.m_Data removeAllObjects];
            }
            s_LoadedPage++;

            NSArray *topicArray = [[dictData objectForKey:@"data"] arrayForKey:@"list"];
            if ([topicArray isNotEmpty])
            {
                for (NSDictionary *clumn in topicArray)
                {
                    if (![clumn isDictionaryAndNotEmpty])
                    {
                        continue;
                    }
                    HMTopicClass *item = [[HMTopicClass alloc] init];
                    
                    item.m_TopicId = [clumn stringForKey:@"topic_id"];
                    
                    if ([clumn boolForKey:@"is_top"])
                    {
                        item.m_Mark = TopicMark_Top;
                    }
                    if ([clumn boolForKey:@"is_new"])
                    {
                        item.m_Mark |= TopicMark_New;
                    }
                    if ([clumn boolForKey:@"is_elite"])
                    {
                        item.m_Mark |= TopicMark_Extractive;
                    }
                    if ([clumn boolForKey:@"is_question"])
                    {
                        item.m_Mark |= TopicMark_Help;
                    }
                    if ([clumn boolForKey:@"has_pic"])
                    {
                        item.m_Mark |= TopicMark_HasPic;
                    }

                    NSString *title = @"";
                    
                    if (item.m_Mark & TopicMark_Extractive)
                    {
                        title = @"     ";
                    }
                    
                    if (item.m_Mark & TopicMark_Help)
                    {
                        if ([title isNotEmpty])
                        {
                            title = [NSString stringWithFormat:@"%@%@", title, @"     "];
                        }
                        else
                        {
                            title =  @"     ";
                        }
                    }

                    
                    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[clumn arrayForKey:@"title_hl"]];
                    if ([title isNotEmpty])
                    {
                        NSMutableDictionary *firDic = [NSMutableDictionary dictionary];
                        [firDic setObject:@"text" forKey:@"tag"];
                        [firDic setObject:title forKey:@"text"];
                        [arr1 insertObject:firDic atIndex:0];
                    }
                    
                    item.m_TitleArr = arr1;
                    item.m_MasterName = [clumn stringForKey:@"nickname"];

                    NSString *dateStr = [clumn stringForKey:@"create_time"];
                    NSDate *day = [NSDate dateFromString:dateStr];
                    if (day)
                    {
                        item.m_CreateTime = [day timeIntervalSince1970];
                    }
                    else
                    {
                        item.m_CreateTime = 0;
                    }
                    item.m_ResponseTime = [clumn intForKey:@"last_response_ts"];
                    if (item.m_ResponseTime == 0)
                    {
                        item.m_ResponseTime = item.m_CreateTime;
                    }
                    item.m_ResponseCount = [clumn intForKey:@"response_count"];
                    
                    // 图片数组
                    NSArray *photoArr = [clumn arrayForKey:@"photo_list"];
                    if ([photoArr count] > 0)
                    {
                        BOOL catchRec = NO;
                        NSMutableArray *picArr = [[NSMutableArray alloc] initWithCapacity:0];
                        NSInteger i = 0;
                        for (NSDictionary *dict in photoArr)
                        {
                            if (i > 2)
                            {
                                break;
                            }
                            NSDictionary *innerDict = [dict dictionaryForKey:@"middle"];
                            NSString *photoStr = [innerDict stringForKey:@"url"];
                            if (!catchRec)
                            {
                                item.m_PicHeight = [innerDict floatForKey:@"height"];
                                item.m_PicWidth = [innerDict floatForKey:@"width"];
                            }
                            catchRec = YES;
                            
                            [picArr addObject:photoStr];
                            i++;
                        }
                        item.m_PicArray = picArr;
                        [picArr release];
                    }
                    
                    [item calcHeight];
                    [self.m_Data addObject:item];
                    [item release];
                }

            }
            else
            {
                _refresh_bottom_view.refreshStatus = YES;
            }
            
            [self.m_Table reloadData];
        }
    }
    else
    {
        if (![self showNoDataNoticeWithType:HMNODATAVIEW_CUSTOM])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
    }
}

// 搜索用户结果
- (void)searchUserFinished:(ASIHTTPRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self.searchBarView setUserInputEnabled:YES];
    [self hideEGORefreshView];

    // 如果数据与当前的展示tab不匹配，不解析数据，不清理已经缓存数据
    if ([self checkLoadDataErrorWithType:HMSEARCH_TYPE_USER])
    {
        return;
    }
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
    if (![dictData isDictionaryAndNotEmpty])
    {
        [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:@"数据错误"];
        return ;
    }
    
    NSDictionary *dictList = [dictData dictionaryForKey:@"data"];
    if ([[dictData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [MobClick event:@"search_v2" label:@"搜索成功总次数"];
        
        s_LoadedTotalCount = [dictList intForKey:@"total"];
        
        if ([[dictList arrayForKey:@"user_list"] count] == 0 && self.m_Data.count == 0)
        {
            [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:[NSString stringWithFormat:@"%@\n%@",@"抱歉,",@"没有找到相关的内容，换个词重新搜索吧"]];
        }
        else
        {
            if (s_LoadedPage == 1)
            {
                [self.m_Data removeAllObjects];
            }
            s_LoadedPage++;
            
            NSArray *userArray = [dictList arrayForKey:@"user_list"];
            if ([userArray isNotEmpty])
            {
                for (NSInteger i = 0; i<userArray.count; i++)
                {
                    NSDictionary *userDic = [userArray objectAtIndex:i];
                    BBSearchUserCellClass *userCellClass = [BBSearchUserCellClass getSearchUserClass:userDic];
                    
                    [self.m_Data addObject:userCellClass];
                }
            }
            else
            {
                _refresh_bottom_view.refreshStatus = YES;
            }
            
            [self.m_Table reloadData];
        }
    }
    else
    {
        if (![self showNoDataNoticeWithType:HMNODATAVIEW_CUSTOM])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
    }
}

// 搜索知识
- (void)searchKnowledgeFinished:(ASIHTTPRequest *)request
{
    [self.m_ProgressHUD hide:YES];
    [self.searchBarView setUserInputEnabled:YES];
    [self hideEGORefreshView];
    
    // 如果数据与当前的展示tab不匹配，不解析数据，不清理已经缓存数据
    if ([self checkLoadDataErrorWithType:HMSEARCH_TYPE_KNOWLEDGE])
    {
        return;
    }

    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *dictData = [parser objectWithString:responseString error:&error];
    
    if (![dictData isDictionaryAndNotEmpty])
    {
        [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:@"数据错误"];
        return ;
    }
    
    NSDictionary *dictList = [dictData dictionaryForKey:@"data"];
    if ([[dictData stringForKey:@"status"] isEqualToString:@"success"])
    {
        [MobClick event:@"search_v2" label:@"搜索成功总次数"];
        s_LoadedTotalCount = [dictList intForKey:@"total"];
        if ([[dictList arrayForKey:@"list"] count] == 0 && self.m_Data.count == 0)
        {
            [self showNoDataNoticeWithType:HMNODATAVIEW_PROMPT withTitle:[NSString stringWithFormat:@"%@\n%@",@"抱歉,",@"没有找到相关的内容，换个词重新搜索吧"]];
        }
        else
        {
            if (s_LoadedPage == 1)
            {
                [self.m_Data removeAllObjects];
            }
            
            for (NSDictionary *clumn in [dictList arrayForKey:@"list"])
            {
                if (![clumn isDictionaryAndNotEmpty])
                {
                    continue;
                }
                
                BBSearchKnowledgeCellClass *item = [BBSearchKnowledgeCellClass getSearchKnowledgeClass:clumn];
                
                [self.m_Data addObject:item];
            }
            s_LoadedPage++;
            
            if(![[dictList arrayForKey:@"list"] isNotEmpty])
            {
               _refresh_bottom_view.refreshStatus = YES;
            }
            [self.m_Table reloadData];
        }
    }
    else
    {
        if (![self showNoDataNoticeWithType:HMNODATAVIEW_CUSTOM])
        {
            [PXAlertView showAlertWithTitle:@"网络获取数据错误"];
        }
    }
}


- (void)searchFail:(ASIHTTPRequest *)request
{
    [self.searchBarView setUserInputEnabled:YES];
    
    if (self.m_Data.count == 0)
    {
        self.m_NoDataView.m_Type = HMNODATAVIEW_NETERROR;
        self.m_NoDataView.hidden = NO;
    }
    else
    {
        [PXAlertView showAlertWithTitle:@"亲，网络不给力！"];
    }
    
    [self.m_ProgressHUD hide:YES];
    [self hideEGORefreshView];
}


#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self checkDataError])
    {
        self.m_Data = [NSMutableArray array];
        [self.m_Table reloadData];
        return 0;
    }
    
    if (self.isShowHistoryList)
    {
        tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
        return ([self.m_Data count]>0)? ([self.m_Data count]+1):0;
    }
    
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return [self.m_Data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowHistoryList)
    {
        return SEARCH_HISTORY_CELL_HEIGHT;
    }
    switch (curSearchType)
    {
        case HMSEARCH_TYPE_TOPIC:
        {
            if(indexPath.row < [self.m_Data count])
            {
                HMTopicClass *class = [self.m_Data objectAtIndex:indexPath.row];
                return class.m_CellHeight - 1;
            }
            else
            {
                return 0;
            }
        }
            break;
        case HMSEARCH_TYPE_KNOWLEDGE:
        {
            if(indexPath.row < [self.m_Data count])
            {
                BBSearchKnowledgeCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
                return item.cellHeight;
            }
            else
            {
                return 0;
            }
        }
            break;
        case HMSEARCH_TYPE_USER:
        {
            if(indexPath.row < [self.m_Data count])
            {
                BBSearchUserCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
                return item.cellHeight;
            }
            else
            {
                return 0;
            }
        }
            break;
        default:
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowHistoryList)
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (IOS_VERSION >= 7) {
            tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        }

        static NSString *cellName = @"HMSearchHistoryCell";
        HMSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[[HMSearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        if (indexPath.row < self.m_Data.count)
        {
            NSString *str = [self.m_Data objectAtIndex:indexPath.row];
            [cell setContent:str isRubbish:NO];
        }
        else
        {
            [cell setContent:nil isRubbish:YES];
        }
        
        cell.deleteButton.tag =indexPath.row ;
        cell.delegate = self;
        return cell;
    }
    
    switch (curSearchType)
    {
        case HMSEARCH_TYPE_TOPIC:
        {
            HMTopicClass *class = nil;
            if(indexPath.row < [self.m_Data count])
            {
                class = [self.m_Data objectAtIndex:indexPath.row];
            }
            
            // 置顶帖
            static NSString *cellName = @"HMTopicListCell";
            HMTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicListCell" owner:self options:nil] lastObject];
                [cell makeCellStyle];
            }
            cell.isSearch = YES;
            if (class) {
                [cell setTopicCellData:class topicType:1];
            }
            return cell;

        }
            break;

        case HMSEARCH_TYPE_KNOWLEDGE:
        {
            static NSString *cellName = @"BBSearchKnowledgeCell";
            
            BBSearchKnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSearchKnowledgeCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
            }

            //数据模型
            if(indexPath.row < [self.m_Data count])
            {
                BBSearchKnowledgeCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
                [cell setSearchKnowledgeCell:item];
            }
            
            return cell;
        }
            break;

        case HMSEARCH_TYPE_USER:
        {
            static NSString *taskCellIdentifier = @"BBSearchUserCell";
            BBSearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSearchUserCell" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            
            //数据模型
            if(indexPath.row < [self.m_Data count])
            {
                BBSearchUserCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
                [cell setSearchUserCell:item];
            }
            
            return cell;
        }
            break;

        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowHistoryList)
    {
        if (indexPath.row == self.m_Data.count)
        {
            // 清除历史记录
            [MobClick event:@"search_v2" label:@"全部清除搜索历史"];
            [HMSearchHistory clearSearchHistory];
            self.m_Data = [NSMutableArray array];
            [self.m_Table reloadData];
            [self.searchBarView.textField becomeFirstResponder];
        }
        else
        {
            if(indexPath.row >= [self.m_Data count])
            {
                return;
            }
            NSString *str = [self.m_Data objectAtIndex:indexPath.row];
            self.searchBarView.textField.text = str;
            [self searchItemWithKeyWord:str];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    switch (curSearchType)
    {
        case HMSEARCH_TYPE_TOPIC:
        {
            if(indexPath.row >= [self.m_Data count])
            {
                return;
            }
            
            HMTopicClass *topicClass = [self.m_Data objectAtIndex:indexPath.row];
            
            NSString *tid = topicClass.m_TopicId;
            
            NSString *title = topicClass.m_Title;
            [BBStatistic visitType:BABYTREE_TYPE_TOPIC_SEARCH contentId:tid];
            [HMShowPage showTopicDetail:self topicId:tid topicTitle:title];
        }
            break;
        case HMSEARCH_TYPE_KNOWLEDGE:
        {
            if(indexPath.row >= [self.m_Data count])
            {
                return;
            }
            BBSearchKnowledgeCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
            NSString *knowledgeID = item.knowledgeID;
            
            BBKnowledgeLibDetailVC * kld = [[[BBKnowledgeLibDetailVC alloc]initWithID:knowledgeID]autorelease];
            kld.m_ReadKnowledgeFromWebOnly = YES;
            kld.sharedData = item;
            [self.navigationController pushViewController:kld animated:YES];

        }
            break;
        case HMSEARCH_TYPE_USER:
        {
            if(indexPath.row >= [self.m_Data count])
            {
                return;
            }
            BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
            BBSearchUserCellClass *item = [self.m_Data objectAtIndex:indexPath.row];
            userInformation.userEncodeId = item.user_encodeID;
            userInformation.userName = item.user_name;
            [self.navigationController pushViewController:userInformation animated:YES];
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Notification Center Event
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    __block UITableView *s_table = self.m_Table;
    [UIView animateWithDuration:0.25f animations:^{
        s_table.height = UI_MAINSCREEN_HEIGHT - (keyboardSize.height) - UI_NAVIGATION_BAR_HEIGHT - ITEM_BUTTON_HEIGHT;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    __block UITableView *s_table = self.m_Table;
    [UIView animateWithDuration:0.25f animations:^{
        s_table.height = DEVICE_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - ITEM_BUTTON_HEIGHT - UI_STATUS_BAR_HEIGHT;
    }];
}


#pragma mark -
#pragma mark UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    __block UITextField *_field = textField;
    __block UIImageView *_vv = self.searchBarView.bgImageView;
    __block UIButton *_btn = self.searchBarView.cancleButton;
    
    [UIView animateWithDuration:0.25f animations:^{
        [_vv setFrame:CGRectMake(5, (44-28)/2, INPUTVIEW_WIDTH_BIG, 28)];
        _field.width = INPUTVIEW_WIDTH_BIG - 30;
        _btn.hidden = NO;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 处理搜索
    [textField resignFirstResponder];
    if (![self searchItemWithKeyWord:textField.text])
    {
        [PXAlertView showAlertWithTitle:nil message:@"请输入有效关键词"];
    }

    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.isShowHistoryList = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (result.length == 0 && !self.isShowHistoryList)
    {
        self.isShowHistoryList = YES;
    }
    return YES;
}

- (void)trimHistory
{
    NSMutableArray *arr = nil;
    if (!self.isShowHistoryList)
    {
        arr = [NSMutableArray arrayWithArray:[HMSearchHistory getSearchHistory]];
    }
    else
    {
        arr = self.m_Data;
    }
    
    BOOL find = NO;
    for (NSInteger i=0; i<[arr count]; i++)
    {
        NSString *str = [arr objectAtIndex:i];
        if ([str isEqualToString:self.curKeyword])
        {
            find = YES;
            [arr moveObjectFromIndex:i toIndex:0];
            break;
        }
    }
    
    if (!find)
    {
        [arr insertObject:self.curKeyword atIndex:0];
    }
    
    if ([arr count]>10)
    {
        [arr removeLastObject];
    }
    
    [HMSearchHistory setSearchHistory:arr];
}


- (void)deleteHistory:(NSInteger)index
{
    [MobClick event:@"search_v2" label:@"单个删除历史"];
    [self.m_Data removeObjectAtIndex:index];
    [HMSearchHistory setSearchHistory:self.m_Data];
    [self.m_Table reloadData];
}

#pragma mark -
#pragma mark HMSearchBarView Delegate
// 取消搜索，收回搜索大页面
-(void)searchBarViewCancleSearch
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.m_DataRequest clearDelegatesAndCancel];
    [self.m_ProgressHUD hide:NO];
    self.m_NoDataView.hidden = YES;
    [self hideEGORefreshView];
}

@end
