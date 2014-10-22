//
//  BBSearchKnowledgeCellClass.m
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBSearchKnowledgeCellClass.h"

@implementation BBSearchKnowledgeCellClass

+ (BBSearchKnowledgeCellClass *)getSearchKnowledgeClass:(NSDictionary *)dict
{
    BBSearchKnowledgeCellClass *item = [[BBSearchKnowledgeCellClass alloc] init];
    
    if([[dict stringForKey:@"id"]isNotEmpty])
    {
        item.knowledgeID = [dict objectForKey:@"id"];
    }
    
    if([[dict stringForKey:@"title"] isNotEmpty])
    {
        item.knowledge_title = [dict objectForKey:@"title"];
    }
    else
    {
        item.knowledge_title = @"";
    }
    
    if([[dict stringForKey:@"summary"] isNotEmpty])
    {
        item.knowledge_content = [dict objectForKey:@"summary"];
    }
    else
    {
        item.knowledge_content = @"";
    }
    
    if([[dict dictionaryForKey:@"class"] isNotEmpty])
    {
        if([[[dict objectForKey:@"class"] stringForKey:@"type_name"] isNotEmpty])
        {
            item.knowledge_sourceType = [[dict objectForKey:@"class"] stringForKey:@"type_name"];
        }
        else
        {
            item.knowledge_sourceType = @"";
        }
    }
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[dict arrayForKey:@"title_hl"]]; 
    item.m_knowledgeArr = arr1;
    item.m_SummaryArr = [dict arrayForKey:@"content_hl"];
  
    
    // 计算cell高度
 
    // 计算知识标题高度
    CGSize titleSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(300.0, 1000) withFont:[UIFont systemFontOfSize:16.0] withString:[dict objectForKey:@"title"]];
    item.titleHeight = titleSize.height;
    
    // 计算知识内容高度
   CGSize contentSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(300.0, 1000) withFont:[UIFont systemFontOfSize:14.0] withString:item.knowledge_content];
    
    if(contentSize.height <= 60)
    {
        item.cellHeight = item.titleHeight + 40 + contentSize.height;
    }
    else
    {
        item.cellHeight = item.titleHeight + 40 + 60;
    }
    return item;
}


-(void)setM_knowledgeArr:(NSArray *)m_knowledgeArr
{
    self.knowledge_title = [self stringWithArr:m_knowledgeArr];
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:self.knowledge_title];
    NSInteger curLeng = 0;
    for (NSInteger i=0; i<[m_knowledgeArr count]; i++)
    {
        NSDictionary *dic = [m_knowledgeArr objectAtIndex:i];
        NSString *str = [dic stringForKey:@"text"];
        
        NSInteger nextLenth = str.length;
        if (nextLenth + curLeng > mutaString.length)
        {
            nextLenth = mutaString.length - curLeng;
        }
        
        if ([[dic stringForKey:@"tag"] isEqualToString:@"hl"])
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHex:0xff537b]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        else
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHex:0x444444]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        curLeng += nextLenth;
    }
    self.m_knowledgeAttribut = mutaString;
}

-(void)setM_SummaryArr:(NSArray *)summaryArr
{
    self.knowledge_content = [self stringWithArr:summaryArr];
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:self.knowledge_content];
    NSInteger curLeng = 0;
    for (NSInteger i=0; i<[summaryArr count]; i++)
    {
        NSDictionary *dic = [summaryArr objectAtIndex:i];
        NSString *str = [dic stringForKey:@"text"];
        
        NSInteger nextLenth = str.length;
        if (nextLenth + curLeng > mutaString.length)
        {
            nextLenth = mutaString.length - curLeng;
        }
        
        if ([[dic stringForKey:@"tag"] isEqualToString:@"hl"])
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHex:0xff537b]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        else
        {
            [mutaString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHex:0x444444]
                               range:NSMakeRange(curLeng, nextLenth)];
        }
        curLeng += nextLenth;
    }
    
    self.m_SummaryAttribut = mutaString;
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

@end
