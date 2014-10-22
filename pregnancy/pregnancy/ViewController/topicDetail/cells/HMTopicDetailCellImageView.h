//
//  HMTopicDetailCellImageView.h
//  lama
//
//  Created by mac on 13-8-6.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMTopicDetailCellView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"


#define OPENPIC_MODE 0

@interface HMTopicDetailCellImageView : HMTopicDetailCellView
<
    MJPhotoBrowserDelegate
>

@property (retain, nonatomic) IBOutlet UIImageView *m_ImageView;

@property (retain, nonatomic) IBOutlet UIControl *m_LinkCtrl;
// 用于相册显示
@property (nonatomic, retain) NSMutableArray *m_BigImageArray;
@property (nonatomic, retain) NSMutableArray *m_BigImageUrlArray;

- (IBAction)link_Click:(id)sender;

@end
