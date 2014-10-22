//
//  BBAttentionType.h
//  pregnancy
//
//  Created by MacBook on 14-9-2.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#ifndef pregnancy_BBAttentionType_h
#define pregnancy_BBAttentionType_h

// 获取列表类型:1-互相关注 2-已关注 3-被关注(对自己而言该用户未关注) 4-加关注
typedef enum
{
    AttentionType_Both_Attention = 1,
    AttentionType_Had_Attention = 2 ,
    AttentionType_Be_Attention = 3,
    AttentionType_Add_Attention = 4,
}AttentionType;

#endif
