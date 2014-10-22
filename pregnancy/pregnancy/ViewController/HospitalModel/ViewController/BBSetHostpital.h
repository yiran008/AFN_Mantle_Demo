//
//  BBSetHostpital.h
//  pregnancy
//
//  Created by babytree babytree on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSelectArea.h"

@interface BBSetHostpital : BaseViewController<BBSelectAreaCallBack>
{
    UITextField *textField;
    UITextField *areatextField;
    MBProgressHUD *hud;
    ASIFormDataRequest *setHospitalRequest;
    NSString *ciytCode;
}
@property(nonatomic,strong)IBOutlet UITextField *textField;
@property(nonatomic,strong)IBOutlet UITextField *areatextField;
@property(nonatomic,strong) MBProgressHUD *hud;
@property(nonatomic,strong)ASIFormDataRequest *setHospitalRequest;
@property(nonatomic,strong)NSString *ciytCode;
@end
