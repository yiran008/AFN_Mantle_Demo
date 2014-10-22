//
//  BBSearchUserCellClass.m
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBSearchUserCellClass.h"

@implementation BBSearchUserCellClass

+ (BBSearchUserCellClass *)getSearchUserClass:(NSDictionary *)dict
{
    BBSearchUserCellClass *item = [[BBSearchUserCellClass alloc] init];
    
    if([[dict stringForKey:@"enc_user_id"] isNotEmpty])
    {
        item.user_encodeID = [dict stringForKey:@"enc_user_id"];
    }
    else
    {
        item.user_encodeID = @"";
    }
    
    if([[dict stringForKey:@"avatar_url"] isNotEmpty])
    {
        item.user_avatar = [dict stringForKey:@"avatar_url"];
    }
    else
    {
        item.user_avatar = @"";
    }
    
    if([[dict stringForKey:@"nickname"] isNotEmpty])
    {
        item.user_name = [dict stringForKey:@"nickname"];
    }
    else
    {
        item.user_name = @"";
    }
    
    if([[dict stringForKey:@"baby_age"] isNotEmpty])
    {
        item.user_age = [dict stringForKey:@"baby_age"];
    }
    else
    {
        item.user_age = @"";
    }
    
    if([[dict stringForKey:@"location_name"] isNotEmpty])
    {
        item.user_position = [dict stringForKey:@"location_name"];
    }
    else
    {
        item.user_position = @"";
    }
    
    NSMutableArray *nicknameArr = [NSMutableArray arrayWithArray:[dict arrayForKey:@"nickname_hl"]];
    item.m_nicknameArr = [[NSArray alloc] initWithArray:nicknameArr];

    if([[dict stringForKey:@"level_num"] isNotEmpty])
    {
        item.user_level = [dict stringForKey:@"level_num"];
    }
    else
    {
        item.user_level = @"0";
    }
    
    if([[dict stringForKey:@"follow_status"] isNotEmpty])
    {
        item.attentionStatus = [dict intForKey:@"follow_status"];
    }
    
    // 计算cell高度
    item.cellHeight = 78;

    return item;
}

/**

  * 注释内容为：宝宝昵称搜索关键字标红处理
 
-(void)setM_nicknameArr:(NSArray *)m_nicknameArr
{
    self.user_name = [self stringWithArr:m_nicknameArr];
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:self.user_name];
    NSInteger curLeng = 0;
    for (NSInteger i=0; i<[m_nicknameArr count]; i++)
    {
        NSDictionary *dic = [m_nicknameArr objectAtIndex:i];
        NSString *str = [dic stringForKey:@"text"];
        
        NSInteger nextLenth = str.length;
        if (nextLenth + curLeng > mutaString.length)
        {
            nextLenth = mutaString.length - curLeng;
        }
        
        if ([[dic stringForKey:@"tag"] isEqualToString:@"hl"])
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHex:0x7799CC]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        else
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor blackColor]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        curLeng += nextLenth;
    }
    self.m_nicknameAttribut = mutaString;
}

- (NSString *)stringWithArr:(NSArray *)arr
{
    NSMutableString *str = [NSMutableString string];
    for (NSInteger i=0; i<[arr count]; i++)
    {
        NSDictionary *dic = [arr objectAtIndex:i];
        [str appendString:[dic stringForKey:@"text"]];
    }
    return str;
}
**/

@end
