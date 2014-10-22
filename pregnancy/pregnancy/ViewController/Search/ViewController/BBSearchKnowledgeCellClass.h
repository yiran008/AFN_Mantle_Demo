//
//  BBSearchKnowledgeCellClass.h
//  pregnancy
//
//  Created by yxy on 14-4-15.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSearchKnowledgeCellClass : NSObject

// 高亮显示
@property (nonatomic, retain) NSAttributedString *m_knowledgeAttribut;
@property (nonatomic, retain) NSAttributedString *m_SummaryAttribut;

@property (nonatomic, retain) NSArray *m_knowledgeArr;
@property (nonatomic, retain) NSArray *m_SummaryArr;

// 知识ID
@property (nonatomic, strong) NSString *knowledgeID;
// 知识标题
@property (nonatomic, strong) NSString *knowledge_title;
// 知识正文
@property (nonatomic, strong) NSString *knowledge_content;
// 知识来源分类
@property (nonatomic, strong) NSString *knowledge_sourceType;
// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
// 知识标题的高度
@property (nonatomic, assign) CGFloat titleHeight;

+ (BBSearchKnowledgeCellClass *)getSearchKnowledgeClass:(NSDictionary *)dict;

@end
