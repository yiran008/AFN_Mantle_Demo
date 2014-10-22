//
//  BBMusicViewController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-15.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBMusicViewController.h"
#import "BBMusicDownloadCell.h"
#import "BBMusicListCell.h"
#import "BBMusicDB.h"
#import "BBDownloadManager.h"
#import "BBMusicRequest.h"

@interface BBMusicViewController ()
@property (nonatomic, retain) BBMusicPlayerController   *musicViewPlayer;
@property (nonatomic, retain) NSMutableArray           *itemArray;
@property (nonatomic, retain) NSMutableArray           *downloadItemArray;
@property (nonatomic, retain) UITableView       *musicListTable;
@property (nonatomic, retain) NSDictionary      *currentMusicInfo;
@property (nonatomic, assign) int               currenPlayIndex;
@property (nonatomic, assign) int               lastPlayIndex;
@property (nonatomic, assign) int               currentSelectRow;
@property (nonatomic, assign) MusicShowType     musicShowType;
@property (nonatomic, retain) ASIFormDataRequest    *musicRequest;
@property (nonatomic, retain) UIButton          *allButton;
@property (nonatomic, retain) UIButton          *localButton;
@property (nonatomic, retain) UIImageView       *showTypeImageView;
@property (nonatomic, assign) NSMutableArray    *currentMusicItems;
@property (nonatomic, assign) MusicPlayType     musicPlayType;
@property (nonatomic, retain) UILabel           *tipLabel;
@property (nonatomic, retain) MBProgressHUD         *progressHUD;


@end

@implementation BBMusicViewController

- (void)dealloc
{
    [_musicTypeInfo release];
    [_musicViewPlayer release];
    [_itemArray release];
    [_downloadItemArray release];
    [_musicListTable release];
    [_currentMusicInfo release];
    [_musicRequest clearDelegatesAndCancel];
    [_musicRequest release];
    [_allButton release];
    [_localButton release];
    [_showTypeImageView release];
    [_tipLabel release];
    [_progressHUD release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    self.currenPlayIndex = 0;
    self.lastPlayIndex = 0;
    self.currentSelectRow = -1;
    self.musicShowType = showAllMusic;
    self.musicPlayType = netMusic;
    self.downloadItemArray = [[[NSMutableArray alloc] init] autorelease];
    [self setNavigationBar];
    [self addTitleLabel];
    [self addBackButton];
    [self addTopBg];
    [self addAllButton];
    [self addLocalButton];
    [self addShowTypeImageView];
    [self addButtonSeparate];
    [self addMusicTable];
    [self addProgressHUD];
    [self requestVideoList];
    [BBDownloadManager sharedInstance].musicViewController = self;
    self.allButton.exclusiveTouch = YES;
    self.localButton.exclusiveTouch = YES;
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if ([BBDownloadManager sharedInstance].isBackFromBackground) {
        [BBDownloadManager sharedInstance].isBackFromBackground = NO;
        [[BBDownloadManager sharedInstance] restartDownload];
    }
}

- (void)addProgressHUD {
    self.progressHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:self.progressHUD];
    
}

- (void)openMusicList
{
    self.currenPlayIndex = 0;
    self.lastPlayIndex = 0;
    self.currentSelectRow = -1;
    self.musicShowType = showAllMusic;
    self.musicPlayType = netMusic;
    self.downloadItemArray = [[[NSMutableArray alloc] init] autorelease];
    [self setNavigationBar];
    [self addTitleLabel];
    [self addBackButton];
    [self addTopBg];
    [self addAllButton];
    [self addLocalButton];
    [self addShowTypeImageView];
    [self addButtonSeparate];
    [self addMusicTable];
    [self requestVideoList];
    [BBDownloadManager sharedInstance].musicViewController = self;

}

- (void)addTipLabel {
    self.tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, (DEVICE_HEIGHT - 20 - 44) /2 - 10, 300, 20)] autorelease];
    self.tipLabel.text = @"当前列表无数据";
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tipLabel];
}

- (void)removeTipLabel {
    if (self.tipLabel) {
        [self.tipLabel removeFromSuperview];
        self.tipLabel = nil;
    }
}

#pragma mark - create interface
- (void)addTopBg
{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    imageView.image = [UIImage imageNamed:@"top_tab"];
    [self.view addSubview:imageView];
}

- (void)setNavigationBar {
    [self.navigationController setColorWithImageName:@"navigationBg"];
}

- (void)addTitleLabel {
    NSString *title = @"";
    if([self.musicTypeInfo count]>0)
    {
        title = [self.musicTypeInfo stringForKey:@"sec_title"];
    }
    UILabel *titleLabel = [BBNavigationLabel customNavigationLabel:title];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)addBackButton {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
}

- (void)addShowTypeImageView {
    self.showTypeImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 38, 160, 2)] autorelease];
    self.showTypeImageView.image = [UIImage imageNamed:@"music_type_select"];
    [self.view addSubview:self.showTypeImageView];
}

- (void)addAllButton {
    self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allButton.exclusiveTouch = YES;
    [self.allButton setTitleColor:[UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1] forState:UIControlStateNormal];
    self.allButton.frame = CGRectMake(0, 0, 159, 38);
    [self.allButton setTitleColor:[UIColor colorWithRed:170/255. green:170/255. blue:170/255. alpha:1] forState:UIControlStateHighlighted];
    [self.allButton addTarget:self action:@selector(changeMusicShowType:) forControlEvents:UIControlEventTouchUpInside];
    self.allButton.tag = showAllMusic;
    [self.allButton setTitle:@"音乐库" forState:UIControlStateNormal];
    [self.view addSubview:self.allButton];
}

- (void)addLocalButton {
    self.localButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.localButton.exclusiveTouch = YES;
    [self.localButton setTitleColor:[UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1] forState:UIControlStateNormal];
    [self.localButton setTitleColor:[UIColor colorWithRed:170/255. green:170/255. blue:170/255. alpha:1] forState:UIControlStateHighlighted];
    self.localButton.tag = showDownloadMusic;
    
    self.localButton.frame = CGRectMake(161, 0, 159, 38);
    [self.localButton addTarget:self action:@selector(changeMusicShowType:) forControlEvents:UIControlEventTouchUpInside];
    [self.localButton setTitle:@"本地音乐" forState:UIControlStateNormal];
    [self.localButton setTitle:@"本地音乐" forState:UIControlStateHighlighted];
    [self.view addSubview:self.localButton];
    //iPhone5C 的情况下，如果[self.localButton setHighlighted:YES] 在[self.localButton setTitle:@"本地音乐" forState:UIControlStateNormal] 之前调用，会产生页面第一次加载的时候，button文字不显示bug，所以这里调整了语句的顺序
    [self.localButton setHighlighted:YES];
    
}

- (void)addButtonSeparate
{
    UIImageView *separate = [[[UIImageView alloc] initWithFrame:CGRectMake(159, 0, 1, 38)] autorelease];
    separate.image = [UIImage imageNamed:@"buttonSeparate"];
    [self.view addSubview:separate];
}

- (void)addMusicTable
{
    self.musicListTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, DEVICE_HEIGHT - 20 - 44 - 45 - 60) style:UITableViewStylePlain] autorelease];
    self.musicListTable.backgroundColor = [UIColor clearColor];
    self.musicListTable.delegate = self;
    self.musicListTable.dataSource = self;
    self.musicListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:self.musicListTable];
    [self.view addSubview:self.musicListTable];
}

- (void)addMusicControl
{
    if (!self.musicViewPlayer) {
        self.musicViewPlayer = [[[BBMusicPlayerController alloc] initWithMusicInfo:[self.currentMusicItems objectAtIndex:self.currenPlayIndex]] autorelease];
        self.musicViewPlayer.delegate = self;
        self.musicViewPlayer.view.frame = CGRectMake(0, DEVICE_HEIGHT- 20 - 44 - 60, DEVICE_HEIGHT, 60);
        [self addChildViewController:self.musicViewPlayer];
        
        [self.view insertSubview:self.musicViewPlayer.view aboveSubview:self.musicListTable];
        
    }
}

#pragma mark - private method

- (void)requestVideoList {
    [self.progressHUD setLabelText:@"加载中..."];
    [self.progressHUD show:YES];
    [self.musicRequest clearDelegatesAndCancel];
    self.musicRequest = [BBMusicRequest getMusicListWithCategoryID:[self.musicTypeInfo stringForKey:@"category_id"]];
    [self.musicRequest setDidFinishSelector:@selector(getMusicFinish:)];
    [self.musicRequest setDidFailSelector:@selector(getMusicFail:)];
    [self.musicRequest setDelegate:self];
    [self.musicRequest startAsynchronous];
}


- (void)leftButtonAction:(id)sender {
    [BBDownloadManager sharedInstance].musicViewController = nil;
    [self.musicViewPlayer closeMusicPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeMusicShowType:(id)sender
{
    UIButton *selectButton = (UIButton *)sender;
    if (selectButton.tag == self.musicShowType) {
        
    }else {
        [self removeTipLabel];

        self.localButton.highlighted = !self.localButton.highlighted;
        self.allButton.highlighted = !self.allButton.highlighted;
        if (selectButton.tag == showAllMusic) {
            self.musicShowType = showAllMusic;
            self.showTypeImageView.frame = CGRectMake(0, 38, 160, 2);
            if ([self.itemArray count] == 0) {
                [self requestVideoList];
            }
        }else if(selectButton.tag == showDownloadMusic) {
            self.musicShowType = showDownloadMusic;
            [self.downloadItemArray removeAllObjects];
            [self.downloadItemArray addObjectsFromArray:[BBMusicDB getLocalMusic]];
            self.showTypeImageView.frame = CGRectMake(160, 38, 160, 2);
            if ([self.downloadItemArray count] > 0 && !self.musicViewPlayer) {
                self.musicPlayType = localMusic;
                [self changeMusicPlayType];
                [self addMusicControl];
            }
            if ([self.downloadItemArray count] == 0) {
                [self addTipLabel];
            }
        }
        [self.musicListTable reloadData];
    }
    
}


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

- (void)setDownloadStatus:(int)downloadStatus withMusicInfo:(NSMutableDictionary *)music
{
    if (downloadStatus == DOWNLOAD_FINISH) {
        for (int i = 0; i < [self.itemArray count]; i++) {
            NSMutableDictionary *dic = [self.itemArray objectAtIndex:i];
            if ([[music stringForKey:MUSIC_ID] isEqualToString:[dic stringForKey:MUSIC_ID]]) {
                [dic setObject:[NSNumber numberWithInt:DOWNLOAD_FINISH] forKey:MUSIC_STATUS];
                
                [self.downloadItemArray addObject:dic];
                
                if (self.musicShowType == showDownloadMusic) {
                    [self.musicListTable reloadData];
                }else {
                    BBMusicListCell *cell = (BBMusicListCell *)[self.musicListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    if(cell)
                    {
                        [cell changeStatusWith:downloadStatus];
                    }
                }
                
                if (self.musicShowType == showDownloadMusic) {
                    [self removeTipLabel];
                }
                
                return;
            }
        }
        [music setObject:[NSNumber numberWithInt:DOWNLOAD_FINISH] forKey:MUSIC_STATUS];
        [self.downloadItemArray addObject:music];
        if (self.musicShowType == showDownloadMusic) {
            [self.musicListTable reloadData];
        }
    }else {
        for(int j = 0; j < [self.itemArray count]; j++)
        {
            NSMutableDictionary *dict = [self.itemArray objectAtIndex:j];
            if([[music stringForKey:MUSIC_ID] isEqualToString:[dict stringForKey:MUSIC_ID]]) {
                [dict setObject:[NSNumber numberWithInt:downloadStatus] forKey:MUSIC_STATUS];
                BBMusicListCell *cell1 = (BBMusicListCell *)[self.musicListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
                if(cell1)
                {
                    if (self.musicShowType == showAllMusic) {
                        [cell1 changeStatusWith:downloadStatus];
                    }
                }
                return;
            }
        }
        
    }
}

- (void)changeMusicPlayType
{
    if (self.musicPlayType == netMusic) {
        self.currentMusicItems = self.itemArray;
    }else if(self.musicPlayType == localMusic) {
        self.currentMusicItems = self.downloadItemArray;
    }
}

- (void)changePlayingCellColor
{
    BBMusicListCell *lastCell = (BBMusicListCell *)[self.musicListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayIndex inSection:0]];
    BBMusicListCell *currentCell = (BBMusicListCell *)[self.musicListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currenPlayIndex inSection:0]];
    if (lastCell) {
        [lastCell cancelCellPlaying];
    }
    
    if (currentCell) {
        [currentCell setCellPlaying];
    }
}

- (void)playVideoWithIndex:(int)index
{
    NSDictionary *item = [self.currentMusicItems objectAtIndex:index];
//    [self.musicViewPlayer.musicPlayer pause];
    self.musicViewPlayer.musicInfo = item;
    [self.musicViewPlayer play];
    [self changePlayingCellColor];
    self.lastPlayIndex = index;
    
}


- (void)showDownloadCell:(int)index
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:DOWNLOAD_DOWNLOADING],@"downloadStatus", nil];
    
    [self.itemArray insertObject:dic atIndex:index];
    NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.musicListTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:addIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)hideDownloadCell:(int)index
{
    [self.itemArray removeObjectAtIndex:index];
    NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.musicListTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:deleteIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate and UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = 0;
    if (self.musicShowType == showAllMusic) {
        row = [self.itemArray count];
    }else {
        row = [self.downloadItemArray count];
    }
    return row;
    //    return [self.itemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    NSDictionary *item;
    if (self.musicShowType == showAllMusic) {
        item = [self.itemArray objectAtIndex:[indexPath row]];
        
    }else {
        item = [self.downloadItemArray objectAtIndex:[indexPath row]];
    }
    BBMusicListCell *cell = (BBMusicListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[BBMusicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier musicInfo:item] autorelease];
    }
    
    if (self.musicShowType == showAllMusic) {
        cell.cellType = listCellType;
    }else {
        cell.cellType = downloadCellType;
    }
    cell.indexOfRow = indexPath.row;
    cell.delegate = self;
    cell.musicInfo = item;
    [cell resetCell];
    if (indexPath.row == self.currenPlayIndex && self.musicShowType == self.musicPlayType) {
        [cell setCellPlaying];
    }else {
        [cell cancelCellPlaying];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *item;
    if (self.musicShowType == showAllMusic) {
        self.musicPlayType = netMusic;
        [self changeMusicPlayType];
    }else {
        self.musicPlayType = localMusic;
        [self changeMusicPlayType];
    }
    self.currenPlayIndex = indexPath.row;
    [self playVideoWithIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - BBMusicListDelegate

- (void)downloadMusic:(BBMusicListCell *)listCell
{
    [MobClick event:@"music_v2" label:@"下载点击-胎教音乐"];
    NSDictionary *dic = [self.itemArray objectAtIndex:listCell.indexOfRow];
    if ([dic[MUSIC_STATUS] intValue] == DOWNLOAD_FINISH) {
        [AlertUtil showAlert:nil withMessage:@"该音频您已经下载"];
        return;
    }
    [[BBDownloadManager sharedInstance] addDownloadMusic:dic];
    
}

- (void)deleteMusic:(BBMusicListCell *)listCell
{
    
    if ([[listCell.musicInfo stringForKey:MUSIC_ID] isEqualToString:[self.musicViewPlayer.musicInfo stringForKey:MUSIC_ID]]) {//如果视频正在播放则无法删除
        if (self.musicViewPlayer.musicPlayer.state == AudioPlayerStatePlaying) {
            [AlertUtil showAlert:Nil withMessage:@"该音频正在播放中，请终止后再删除"];
            return;
        }
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = nil;
    if ([paths count] > 0)
        documentsDirectory = [paths objectAtIndex:0];
    
    
    
    if ([BBMusicDB deleteMusicWithID:[listCell.musicInfo stringForKey:MUSIC_ID]]) {
        
        NSString  *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[listCell.musicInfo stringForKey:MUSIC_ID]]];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        
        int deleteIndex = -1;
        for (int i = 0; i < [self.downloadItemArray count]; i++) {
            NSDictionary *deleteDic = [self.downloadItemArray objectAtIndex:i];
            if ([[deleteDic stringForKey:MUSIC_ID] isEqualToString:[listCell.musicInfo stringForKey:MUSIC_ID]]) {
                deleteIndex = i;//获取被删除的音频在下载列表中的位置
                break;
            }
        }
        
        if (deleteIndex == -1) {
            return;
        }
        
        if (self.musicPlayType == netMusic) {//当前的播放列表时音乐盒
            if ([[[self.downloadItemArray objectAtIndex:deleteIndex] stringForKey:MUSIC_ID] isEqualToString:[self.musicViewPlayer.musicInfo stringForKey:MUSIC_ID]]) {
                [self.musicViewPlayer stop];//要删除的视频是音乐何种正在播放的视频
            }
        }else {
            if ([[[self.currentMusicItems objectAtIndex:deleteIndex] stringForKey:MUSIC_ID] isEqualToString:[self.musicViewPlayer.musicInfo stringForKey:MUSIC_ID]]) {
                //删除的视频是当前播放（不在播放状态，暂停、未开始播放等）的视频
                [self.musicViewPlayer stop];
                if ([self.currentMusicItems count] == 1) {
                    self.currenPlayIndex = 0;
                    self.musicPlayType = netMusic;
                    if ([self.itemArray count] > 0) {
                        self.currentMusicItems = self.itemArray;
                        self.musicViewPlayer.musicInfo = [self.currentMusicItems objectAtIndex:0];
                        [self.musicViewPlayer resetWithMusicInfo:nil];
                    }else {
                        //待修改：这里有时间处理下
                    }
                }else {
                    if (self.currenPlayIndex == [self.currentMusicItems count] - 1) {
                        self.currenPlayIndex = 0;
                        self.lastPlayIndex = self.currenPlayIndex;
                        self.musicViewPlayer.musicInfo = [self.currentMusicItems objectAtIndex:self.currenPlayIndex];
                        [self.musicViewPlayer resetWithMusicInfo:nil];
                    }else {
                        self.musicViewPlayer.musicInfo = [self.currentMusicItems objectAtIndex:self.currenPlayIndex + 1];
                        [self.musicViewPlayer resetWithMusicInfo:nil];
                    }
                }
            }else {
                if (deleteIndex < self.currenPlayIndex) {
                    self.currenPlayIndex--;
                    self.lastPlayIndex = self.currenPlayIndex;
                }else {
                    
                }
            }

        }
        
        [self.downloadItemArray removeObjectAtIndex:deleteIndex];
        [self.musicListTable reloadData];
        
        //更改音乐盒列表中对应音频的下载状态
        for (NSMutableDictionary *dictionary in self.itemArray) {
            if ([[dictionary stringForKey:MUSIC_ID] isEqualToString:[listCell.musicInfo stringForKey:MUSIC_ID]]) {
                [dictionary setValue:[NSNumber numberWithInt:DOWNLOAD_PRE] forKey:MUSIC_STATUS];
                break;
            }
        }
        
    }
}

#pragma mark - BBMusicPlayerController

- (void)nextMusic:(BBMusicPlayerController *)musicPlayerController
{
    
    if (musicPlayerController.cycleType == orderCycleType) {
        if (self.currenPlayIndex == [self.currentMusicItems count] - 1) {
            self.currenPlayIndex = 0;
        }else {
            self.currenPlayIndex++;
        }
    }else if(musicPlayerController.cycleType == singleCycleType) {
        
    }else if(musicPlayerController.cycleType == randomCycleType) {
        self.currenPlayIndex = arc4random() % [self.currentMusicItems count];
    }
    
    [self playVideoWithIndex:self.currenPlayIndex];
    
}
- (void)preMusic:(BBMusicPlayerController *)musicPlayerController
{
    if (musicPlayerController.cycleType == orderCycleType) {
        if (self.currenPlayIndex == 0) {
            self.currenPlayIndex = [self.currentMusicItems count] - 1;
        }else {
            self.currenPlayIndex--;
        }
    }else if(musicPlayerController.cycleType == singleCycleType) {
        
    }else if(musicPlayerController.cycleType == randomCycleType) {
        self.currenPlayIndex = arc4random() % [self.currentMusicItems count];
    }
    
    [self playVideoWithIndex:self.currenPlayIndex];

}



- (void)musicDidFinish:(BBMusicPlayerController *)musicPlayerController
{
    
    if (musicPlayerController.cycleType == orderCycleType) {
        if (self.currenPlayIndex == [self.currentMusicItems count] - 1) {
            self.currenPlayIndex = 0;
        }else {
            self.currenPlayIndex++;
        }
    }else if(musicPlayerController.cycleType == singleCycleType) {
        
    }else if(musicPlayerController.cycleType == randomCycleType) {
        self.currenPlayIndex = arc4random() % [self.currentMusicItems count];
    }
    
    [self playVideoWithIndex:self.currenPlayIndex];
}

#pragma mark - ASIHttpRequest delegate
- (void)getMusicFinish:(ASIFormDataRequest *)request {
    [self.progressHUD hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *submitReplyData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"出错了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        [self addTipLabel];
        return;
    }
    if ([[submitReplyData stringForKey:@"status"] isEqualToString:@"success"]) {
        self.itemArray = (NSMutableArray *)[[submitReplyData dictionaryForKey:@"data"] arrayForKey:@"list"];
        if ([self.itemArray isKindOfClass:[NSArray class]] && [self.itemArray count] > 0) {
            for (int j = 0; j < [self.itemArray count]; j++) {
                NSMutableDictionary *netDic = (NSMutableDictionary *)[self.itemArray objectAtIndex:j];
                NSDictionary *musicDic = [BBMusicDB getMusicWithID:[netDic stringForKey:@"music_id"]];
                
                
                if (musicDic.isNotEmpty) {
                    [self.itemArray replaceObjectAtIndex:j withObject:musicDic];
                    
                }
                
            }
            [self.musicListTable reloadData];
            //成功加载数据后才会创建播放器
            if (!self.musicViewPlayer) {
                self.musicPlayType = netMusic;
                [self changeMusicPlayType];
            }
            [self addMusicControl];
        }else {
            [self addTipLabel];
        }
        
    }else {
        [self addTipLabel];
    }
}

- (void)getMusicFail:(ASIFormDataRequest *)request {
    [self.progressHUD hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
    [self addTipLabel];
}


#pragma mark -ScanDelegate

- (void)successScanWithResult:(NSString *)result
{
    if ([result isEqualToString:[self.musicTypeInfo stringForKey:@"url"]]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"YES" forKey:[self.musicTypeInfo stringForKey:@"url"]];
        [self openMusicList];
    }else {
        [AlertUtil showAlert:nil withMessage:@"请扫描争取的二维码获取音乐列表"];
    }
}

- (void)cancelScan
{
    [self leftButtonAction:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
