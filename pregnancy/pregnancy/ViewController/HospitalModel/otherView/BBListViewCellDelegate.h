//
//  BBListViewCellDelegate.h
//  pregnancy
//
//  Created by babytree babytree on 12-5-9.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBListViewCellDelegate <NSObject>

-(CGFloat)listViewCell:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withData:(NSMutableDictionary *)data;
- (UITableViewCell *)listViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withData: (NSMutableDictionary *)data;
- (void)listViewCell:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(NSMutableDictionary *)data;
@end
