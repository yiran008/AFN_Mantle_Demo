//
//  DraftBoxSend.m
//  DraftBox
//
//  Created by mac on 13-4-12.
//  Copyright (c) 2013年 DJ. All rights reserved.
//

#if COMMON_USE_DRATFBOX

#import "HMDraftBoxSend.h"
#import "HMApiRequest.h"

@implementation HMDraftBoxSendOne
@synthesize delegate;
@synthesize m_DraftData;
@synthesize m_PicIndex;

@synthesize m_DataRequest;
@synthesize m_ImageRequest;
@synthesize m_Status;
@synthesize m_IsRunning;


- (void)dealloc
{
    [self stop];
}

- (id)initWithData:(HMDraftBoxData *)draftData index:(NSInteger)index
{
    self = [super init];
    
    if (self)
    {
        self.m_DraftData = draftData;
        self.m_PicIndex = index;
        m_Status = draftData.m_SendStatus;
        s_IsStop = NO;
        m_IsRunning = NO;
    }
    
    return self;
}

- (void)stop
{
    s_IsStop = YES;
    
    if (m_DataRequest)
    {
        [m_DataRequest clearDelegatesAndCancel];
        m_DataRequest = nil;
    }
    
    if (m_ImageRequest)
    {
        [m_ImageRequest clearDelegatesAndCancel];
        m_ImageRequest = nil;
    }
    
    m_IsRunning = NO;
}

- (void)uploadPic:(HMDraftBoxPic *)draftBoxPic
{
    if (m_ImageRequest)
    {
        [m_ImageRequest clearDelegatesAndCancel];
    }
    
    // 停止退出
    if (s_IsStop)
    {
        s_IsStop = NO;
        
        return;
    }
    
    self.m_ImageRequest = [HMApiRequest uploadPhoto:draftBoxPic.m_Photo_data withLoginString:[BBUser getLoginString]];
    [m_ImageRequest setDidFinishSelector:@selector(uploadPhotoFinished:)];
    [m_ImageRequest setDidFailSelector:@selector(uploadPhotoFailed:)];
    [m_ImageRequest setUploadProgressDelegate:self];
    [m_ImageRequest setDelegate:self];
    [m_ImageRequest startAsynchronous];
}

- (void)uploadText:(BOOL)isReply;
{
    if (m_DataRequest)
    {
        [m_DataRequest clearDelegatesAndCancel];
    }
    
    // 停止退出
    if (s_IsStop)
    {
        s_IsStop = NO;
        
        return;
    }
    
    // 回复判断
    if (isReply)
    {
        //self.m_DataRequest = [BBTopicRequest replyTopicWithLoginString:[HMUser getLoginString] withTopicID:m_DraftData.m_Discuz_id withContent:m_DraftData.m_Content withPhotoID:m_DraftData.m_Photo_id withPosition:m_DraftData.m_Position withReferID:m_DraftData.m_Refer_id];
    }
    else
    {
//        NSString *content;
//        if (m_DraftData.m_Doctor_name != nil)
//        {
//            content = [NSString stringWithFormat:@"%@有关%@医生的讨论", m_DraftData.m_Content, m_DraftData.m_Doctor_name];
//        }
//        else
//        {
//            content = m_DraftData.m_Content;
//        }

        NSString *content = m_DraftData.m_Content;
        NSString *contentstring = [content parameterEmojis];
        NSString *title = m_DraftData.m_Title;
        NSString *titlestring = [title parameterEmojis];
        
        NSMutableString *photoIdList = [NSMutableString stringWithString:@""];
        
        for (HMDraftBoxPic *draftBoxPic in m_DraftData.m_PicArray)
        {
            if (photoIdList.length == 0)
            {
                [photoIdList appendString:draftBoxPic.m_Photo_id];
            }
            else
            {
                [photoIdList appendFormat:@",%@", draftBoxPic.m_Photo_id];
            }
        }
        
        self.m_DataRequest = [HMApiRequest createTopicWithLoginString:[BBUser getLoginString] gourpID:m_DraftData.m_Group_id title:titlestring content:contentstring photoIDList:photoIdList is_question:m_DraftData.m_HelpMark];
    }
    
    [m_DataRequest setDidFinishSelector:@selector(uploadTextFinished:)];
    [m_DataRequest setDidFailSelector:@selector(uploadTextFailed:)];
    [m_DataRequest setUploadProgressDelegate:nil];
    [m_DataRequest setDelegate:self];
    [m_DataRequest startAsynchronous];
}


- (BOOL)send
{
    s_IsStop = NO;
    
    if (!m_DraftData)
    {
        return NO;
    }
    
    if (m_IsRunning)
    {
        return NO;
    }
    
    m_IsRunning = YES;
    
    if (m_PicIndex >= 0)
    {
        if (m_PicIndex >= m_DraftData.m_PicArray.count)
        {
            m_IsRunning = NO;
            
            return NO;
        }
        
        HMDraftBoxPic *draftBoxPic = m_DraftData.m_PicArray[m_PicIndex];
        [self uploadPic:draftBoxPic];
    }
    else
    {
        [self uploadText:m_DraftData.m_IsReply];
    }
    
    return YES;
}

#pragma mark - ASIHttpRequest ASIProgressDelegate

// see ASIHttpRequest: + (void)updateProgressIndicator:(id *)indicator withProgress:(unsigned long long)progress ofTotal:(unsigned long long)total
- (void)setProgress:(float)newProgress
{
    // 图片上传进度
    if ([delegate respondsToSelector:@selector(draftBoxUploadOnePicProgress:atIndex:progress:)])
    {
        NSLog(@"draftBoxUploadOnePicProgress: %f", newProgress);
        [self.delegate draftBoxUploadOnePicProgress:m_DraftData atIndex:m_PicIndex progress:newProgress];
    }
}

#pragma mark - ASIHttpRequest Upload Photo Request

- (void)uploadPhotoFinished:(ASIHTTPRequest *)request
{
    m_IsRunning = NO;
    
    NSString *responseString = [request responseString];
    NSDictionary *messageDictionary = [responseString objectFromJSONString];
    
    if (![messageDictionary isDictionaryAndNotEmpty])
    {
        if ([delegate respondsToSelector:@selector(draftBoxUploadOneFail:atIndex:error:)])
        {
            [self.delegate draftBoxUploadOneFail:m_DraftData atIndex:m_PicIndex error:nil];
        }
        
        return;
    }
    
    NSString *errorText = nil;

    NSString *status = [messageDictionary stringForKey:@"status"];
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        HMDraftBoxPic *draftBoxPic = m_DraftData.m_PicArray[m_PicIndex];

        NSDictionary *uploadDic = [messageDictionary dictionaryForKey:@"data"];
        NSArray *uploadArr= [uploadDic arrayForKey:@"photo_list"];
        if (uploadArr.count > 0) {
            draftBoxPic.m_Photo_id = [[uploadArr objectAtIndex:0] stringForKey:@"photo_id"];
        }
       
        if ([draftBoxPic.m_Photo_id isNotEmpty])
        {
            if ([HMDraftBoxDB modifyDraftBoxDBOnePic:m_DraftData atindex:m_PicIndex])
            {
                if ([delegate respondsToSelector:@selector(draftBoxUploadOneSucceed:atIndex:)])
                {
                    [self.delegate draftBoxUploadOneSucceed:m_DraftData atIndex:m_PicIndex];
                }
                
                return;
            }
        }
    }
    else if ([status isEqualToString:@"suspended_user"])
    {
        errorText = @"啊呀呀，孕妈被禁足啦，请联系管管~";
    }

    if ([delegate respondsToSelector:@selector(draftBoxUploadOneFail:atIndex:error:)])
    {
        [self.delegate draftBoxUploadOneFail:m_DraftData atIndex:m_PicIndex error:errorText];
    }
}

- (void)uploadPhotoFailed:(ASIHTTPRequest *)request
{
    m_IsRunning = NO;
    
    if ([delegate respondsToSelector:@selector(draftBoxUploadOneFail:atIndex:error:)])
    {
        [self.delegate draftBoxUploadOneFail:m_DraftData atIndex:m_PicIndex error:nil];
    }
}


#pragma mark - ASIHttpRequest Upload Text Request

- (void)uploadTextFinished:(ASIHTTPRequest *)request
{
    m_IsRunning = NO;
    
    NSString *responseString = [request responseString];
    NSDictionary *messageDictionary = [responseString objectFromJSONString];
    
    if (![messageDictionary isDictionaryAndNotEmpty])
    {
        if ([delegate respondsToSelector:@selector(draftBoxUploadOneFail:atIndex:error:)])
        {
            [self.delegate draftBoxUploadOneFail:m_DraftData atIndex:m_PicIndex error:nil];
        }
        
        return;
    }
    
    NSString *errorText = nil;
    
    NSString *status = [messageDictionary stringForKey:@"status"];
    //NSLog(@"status: %@", status);
    if ([status isEqualToString:@"success"] || [status isEqualToString:@"0"])
    {
        NSDictionary *data = [messageDictionary dictionaryForKey:@"data"];
        if ([data isNotEmpty])
        {
            m_DraftData.m_ShareUrl = [data stringForKey:@"share_url" defaultString:@"http://r.babytree.com/khyxw1"];
        }
        else
        {
            m_DraftData.m_ShareUrl = @"http://r.babytree.com/khyxw1";
        }

        if ([HMDraftBoxDB setDraftBoxDBSend:m_DraftData])
        {
            if ([delegate respondsToSelector:@selector(draftBoxUploadOneSucceed:atIndex:)])
            {
                [self.delegate draftBoxUploadOneSucceed:m_DraftData atIndex:m_PicIndex];
            }
            
            return;
        }
    }
    else if ([status isEqualToString:@"forbidden"])
    {
        errorText = @"话题太辣，请改改再发~";
    }
    else if ([status isEqualToString:@"no_posting"] || [status isEqualToString:@"blockedUser"] || [status isEqualToString:@"suspended"])
    {
        errorText = @"啊呀呀，孕妈被禁足啦，请联系管管~";
    }
    else if ([status isEqualToString:@"similar_error"])
    {
        errorText = @"啊呀呀，亲的话题频繁重复了呦~";
    }
    else if ([status isEqualToString:@"question_over_day_limit"])
    {
        errorText = [messageDictionary stringForKey:@"message"];
        if (![errorText isNotEmpty])
        {
            errorText = @"亲，求助太多别人回答不过来呦~";
        }
    }
    else if ([status isEqualToString:@"titleIsNull"])
    {
        
    }

    if (![errorText isNotEmpty])
    {
        errorText = [messageDictionary stringForKey:@"message"];
    }
    if ([delegate respondsToSelector:@selector(draftBoxUploadOneFail:atIndex:error:)])
    {
        [self.delegate draftBoxUploadOneFail:m_DraftData atIndex:m_PicIndex error:errorText];
    }
}

- (void)uploadTextFailed:(ASIHTTPRequest *)request
{
    m_IsRunning = NO;
    
    if ([delegate respondsToSelector:@selector(draftBoxUploadOneFail:atIndex:error:)])
    {
        [self.delegate draftBoxUploadOneFail:m_DraftData atIndex:m_PicIndex error:nil];
    }
}

@end


#pragma mark - draftBoxSend

@implementation HMDraftBoxSend
@synthesize delegate;
@synthesize m_DraftSendArray;
@synthesize m_DraftBoxSendOne;
@synthesize m_PicIndex;

- (void)dealloc
{
    [m_DraftBoxSendOne stop];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.m_DraftSendArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (NSInteger)getFirstIndex:(HMDraftBoxData *)draftData
{
    NSInteger index;
    
    if (draftData.m_SendStatus >= DraftBoxStatus_SendPicSucceed)
    {
        return -1;
    }
        
    for (index = 0; index < draftData.m_PicArray.count; index++)
    {
        HMDraftBoxPic *draftBoxPic = draftData.m_PicArray[index];
        if (!draftBoxPic.m_IsUpload)
        {
            return index;
        }
    }
    
    return -1;
}

- (void)prepareDraftBoxData:(NSString *)userId
{
    self.m_DraftSendArray = [NSMutableArray arrayWithArray:[HMDraftBoxDB getDraftBoxDBSendList:userId isSending:NO]];
}

- (BOOL)sendDraftBoxData
{
    if (![m_DraftSendArray isNotEmpty] || [m_DraftSendArray count] == 0)
    {
        return NO;
    }
    
    HMDraftBoxData *draftBoxData = [m_DraftSendArray objectAtIndex:0];
    
    if (self.m_DraftBoxSendOne == nil)
    {
        self.m_PicIndex = [self getFirstIndex:draftBoxData];
        self.m_DraftBoxSendOne = [[HMDraftBoxSendOne alloc] initWithData:draftBoxData index:m_PicIndex];
        m_DraftBoxSendOne.delegate = self;
        
        if (![m_DraftBoxSendOne send])
        {
            if ([delegate respondsToSelector:@selector(draftBoxSendFail:atIndex:error:)])
            {
                [self.delegate draftBoxSendFail:draftBoxData atIndex:m_PicIndex error:nil];
            }
        }
    }
    else
    {
        if (!m_DraftBoxSendOne.m_IsRunning)
        {
            m_DraftBoxSendOne.m_DraftData = [m_DraftSendArray objectAtIndex:0];
            self.m_PicIndex = [self getFirstIndex:draftBoxData];
            m_DraftBoxSendOne.m_PicIndex = m_PicIndex;
            
            if (![m_DraftBoxSendOne send])
            {
                if ([delegate respondsToSelector:@selector(draftBoxSendFail:atIndex:error:)])
                {
                    [self.delegate draftBoxSendFail:draftBoxData atIndex:m_PicIndex error:nil];
                }
            }
        }
    }
    
    return YES;
}

- (BOOL)sendWithDraftBoxData:(HMDraftBoxData *)draftData
{
    if (!draftData || draftData.m_IsSent)
    {
        return NO;
    }
    
    if (![HMDraftBoxDB setDraftBoxDB:draftData isSending:YES])
    {
        return NO;
    }
    
    NSInteger index = [m_DraftSendArray indexOfObject:draftData];
    
    if (index == NSNotFound)
    {
        [m_DraftSendArray addObject:draftData];
        
        return [self sendDraftBoxData];
    }
    
    return NO;
}

- (void)stop
{
    if (!m_DraftBoxSendOne.m_IsRunning)
    {
        [m_DraftBoxSendOne stop];
    }
}

#pragma mark - draftBoxSendOneDelegate

- (void)draftBoxUploadOnePicProgress:(HMDraftBoxData *)draftData atIndex:(NSInteger)index progress:(float)progress
{
    
}

- (void)draftBoxUploadOneSucceed:(HMDraftBoxData *)draftData atIndex:(NSInteger)index
{
    if (index < 0)
    {
        [m_DraftSendArray removeObject:draftData];
    }
    
    if ([delegate respondsToSelector:@selector(draftBoxSendSucceed:atIndex:)])
    {
        [self.delegate draftBoxSendSucceed:draftData atIndex:index];
    }
        
    [self sendDraftBoxData];
}

- (void)draftBoxUploadOneFail:(HMDraftBoxData *)draftData atIndex:(NSInteger)index error:(NSString *)errorText
{
    [HMDraftBoxDB setDraftBoxDB:draftData isSending:NO];
    
    [m_DraftSendArray removeObject:draftData];
    
    if ([delegate respondsToSelector:@selector(draftBoxSendFail:atIndex:error:)])
    {
        [self.delegate draftBoxSendFail:draftData atIndex:index error:errorText];
    }
    
    [self sendDraftBoxData];
}

@end


#endif
