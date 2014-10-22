//
//  BBTopicListViewCell.h
//  pregnancy
//
//  Created by babytree babytree on 12-5-10.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBListViewCellDelegate.h"
#import "BBTopicDetailDelegate.h"
#import "BBListView.h"

@interface BBTopicListViewCell : NSObject<BBListViewCellDelegate,BBTopicDetailDelegate>{
    BBListView *listView;
}
@property(assign)BBListView *listView;
@end
