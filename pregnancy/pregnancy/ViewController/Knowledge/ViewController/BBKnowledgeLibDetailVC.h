//
//  BBKnowledgeLibVC.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-29.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSearchKnowledgeCellClass.h"

@interface BBKnowledgeLibDetailVC : BaseViewController
- (id)initWithID:(NSString *)knowledgeID;
@property(nonatomic,strong)BBSearchKnowledgeCellClass *sharedData;
@property(nonatomic,assign)BOOL m_ReadKnowledgeFromWebOnly;
@end
