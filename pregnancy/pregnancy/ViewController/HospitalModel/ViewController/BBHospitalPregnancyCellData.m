//
//  BBHospitalPregnancyCellData.m
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalPregnancyCellData.h"
#import "BBHospitalPregnancyCell.h"
#import "BBPersonalViewController.h"

@implementation BBHospitalPregnancyCellData

@synthesize listView;

-(CGFloat)listViewCell:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withData:(NSMutableDictionary *)data
{
    return 55;
}

//BBListViewCellDelegate的方法
- (UITableViewCell *)listViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withData: (NSMutableDictionary *)data
{
    
    static NSString *CellIdentifier = @"BBHospitalPregnancyCell";
    
    BBHospitalPregnancyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBHospitalPregnancyCell" owner:self options:nil] objectAtIndex:0];
        cell.viewCtrl = listView.viewCtrl;
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    }
    [cell setData:data];
    
    return cell;
}

- (void)listViewCell:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(NSMutableDictionary *)data
{  
    BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
    userInformation.userEncodeId = [data stringForKey:@"enc_user_id"];
    userInformation.userName = [data stringForKey:@"nickname"];
    [listView.viewCtrl.navigationController pushViewController:userInformation animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


@end
