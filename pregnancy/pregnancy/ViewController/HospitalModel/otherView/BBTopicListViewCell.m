//
//  BBTopicListViewCell.m
//  pregnancy
//
//  Created by babytree babytree on 12-5-10.
//  Copyright (c) 2012年 babytree. All rights reserved.
//
#import "BBTopicListViewCell.h"
#import "BBAppDelegate.h"
#import "HMShowPage.h"
#import "HMTopicClass.h"
#import "HMTopicListCell.h"
#import "BBDoctorPostListView.h"

@implementation BBTopicListViewCell
@synthesize listView;

-(CGFloat)listViewCell:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withData:(NSMutableDictionary *)data
{
    HMTopicClass *class = [self changeDataToClass:data];
    return class.m_CellHeight;
}

//BBListViewCellDelegate的方法
- (UITableViewCell *)listViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withData: (NSMutableDictionary *)data
{ 
    HMTopicClass *class = [self changeDataToClass:data];
    static NSString *cellName = @"HMTopicListCell";
    HMTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMTopicListCell" owner:self options:nil] lastObject];
        [cell makeCellStyle];
    }
    
    [cell setTopicCellData:class topicType:0];
    
    return cell;
}
- (void)listViewCell:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(NSMutableDictionary *)data
{
    NSString *pvCount = [data stringForKey:@"pv_count"];
    if (pvCount!=nil && ![pvCount isEqual:[NSNull null]]) {
        NSInteger count= [pvCount intValue]+1;
        [data setObject:[NSString stringWithFormat:@"%d",count] forKey:@"pv_count"];
        [tableView reloadData];
    }
    if([listView.viewCtrl isKindOfClass:[BBDoctorPostListView class]])
    {
        [BBStatistic visitType:BABYTREE_TYPE_TOPIC_DOCTOR contentId:[data stringForKey:@"id"]];
    }
    [HMShowPage showTopicDetail:listView.viewCtrl topicId:[data stringForKey:@"id"] topicTitle:[data stringForKey:@"title"]];
}
#pragma mark topicDelegate methods
//回复了帖子
- (void)replyTopicFinish:(NSInteger)dataIndex
{
    NSMutableDictionary * group=[listView.requestData objectAtIndex:dataIndex];
    NSString *responseCount = [group stringForKey:@"response_count"];
    if (responseCount!=nil && ![responseCount isEqual:[NSNull null]]) {
        NSInteger count= [responseCount intValue]+1;
        [group setObject:[NSString stringWithFormat:@"%d",count] forKey:@"response_count"];
        [listView.bbTableView reloadData];
    }
}

//对帖子进行了收藏操作
- (void)collectTopicAction:(NSInteger)dataIndex withTopicID:(NSString *)topicID withCollectState:(BOOL)theBool
{
    NSMutableDictionary * group=[listView.requestData objectAtIndex:dataIndex];
    if (theBool) {
        [group setObject:@"1" forKey:@"is_fav"];
    }else {
        [group setObject:@"0" forKey:@"is_fav"];
    }
    
}
//对帖子进行删除
- (void)deleteTopicFinish:(NSInteger)dataIndex{
    [self.listView.requestData removeObjectAtIndex:dataIndex];
    [self.listView.bbTableView reloadData];
}

- (HMTopicClass *)changeDataToClass:(NSMutableDictionary *)data
{
    
    HMTopicClass *item = [[[HMTopicClass alloc] init] autorelease];

    item.m_TopicId = [data stringForKey:@"id"];
    
    if ([data boolForKey:@"is_new"])
    {
        item.m_Mark = TopicMark_New;
    }
    if ([data boolForKey:@"is_elite"])
    {
        item.m_Mark |= TopicMark_Extractive;
    }
    if ([data boolForKey:@"is_question"])
    {
        item.m_Mark |= TopicMark_Help;
    }
    if ([data boolForKey:@"has_pic"])
    {
        item.m_Mark |= TopicMark_HasPic;
    }

    item.m_Title = [data stringForKey:@"title"];
    item.m_MasterName = [data stringForKey:@"author_name"];

    item.m_CreateTime = [data intForKey:@"create_ts"];
    item.m_ResponseTime = [data intForKey:@"last_response_ts"];
    if (item.m_ResponseTime == 0)
    {
        item.m_ResponseTime = item.m_CreateTime;
    }

    item.m_ResponseCount = [data intForKey:@"response_count"];

    [item calcHeight];
    
    // 图片数组
    NSArray *photoArr = [data arrayForKey:@"photo_list"];
    if ([photoArr count] > 0)
    {
        BOOL catchRec = NO;
        NSMutableArray *picArr = [NSMutableArray arrayWithCapacity:0];
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
    }
    
    return item;
}
@end
