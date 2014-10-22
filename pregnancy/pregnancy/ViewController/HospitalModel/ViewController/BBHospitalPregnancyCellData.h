//
//  BBHospitalPregnancyCellData.h
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBHospitalPregnancyCellData : NSObject<BBListViewCellDelegate>{
    BBListView *listView;
}
@property(assign)BBListView *listView;
@end
