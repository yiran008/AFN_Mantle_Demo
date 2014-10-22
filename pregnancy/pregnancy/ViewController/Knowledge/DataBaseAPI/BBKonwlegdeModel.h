//
//  BBKonwlegdeModel.h
//  pregnancy
//
//  Created by ZHENGLEI on 14-4-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//  知识提醒宝宝发育数据模型

#import <Foundation/Foundation.h>
#import "BBAdModel.h"

//枚举类型数值根据数据库确定
typedef enum {
    knowlegdePeriodPregnancy = 1,
    knowlegdePeriodPrepare = 3,
    knowlegdePeriodParent = 2,
    knowlegdePeriodNone =0
}babyPeriod;

typedef enum
{
    knowlegdeTypeKnowlegde = 1,
    knowlegdeTypeRemind = 2,
    knowlegdeTypeBabyGrowth =3,
    knowlegdeTypeNone = 0
}knowlegdeType;

@interface BBKonwlegdeModel : NSObject

@property(nonatomic,strong)NSString * ID;
@property(nonatomic,assign)babyPeriod period;
@property(nonatomic,assign)knowlegdeType type;
@property(nonatomic,strong)NSString * days;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * imgArrStr;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * description;
@property(nonatomic,strong)NSString * image;
@property(nonatomic,strong)NSString * week;
@property(nonatomic,strong)NSString * weekPlusDay;
@property(nonatomic,strong)BBAdModel * ad;
@property(nonatomic,strong)NSString * category;
@property(nonatomic,strong)NSString *knowledgeStatus;

@property(nonatomic,strong)NSMutableArray * customArr;

//cell运行时扩充字段
@property(nonatomic,assign)int index;
@property(nonatomic,assign)float cellHight;
@property(nonatomic,assign)float textHight;
@property(nonatomic,strong)NSString * dateStr;

-(id)initWithData:(NSDictionary *)dic;

@end
