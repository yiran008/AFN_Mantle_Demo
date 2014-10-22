//
//  BBPreparationEditViewController.h
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-13.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSelectArea.h"
#import "BBModifyNickName.h"
@interface BBPreparationEditViewController : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIAlertViewDelegate,
    UIActionSheetDelegate,
    BBSelectAreaCallBack,
    ModifyNicknameDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>
@end
