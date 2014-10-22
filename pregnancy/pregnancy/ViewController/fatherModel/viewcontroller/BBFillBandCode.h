//
//  BBFillBandCode.h
//  pregnancy
//
//  Created by whl on 14-4-14.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBFillBandCodeDelegate  <NSObject>

-(void)closeFillBandCodeView;

@end

@interface BBFillBandCode : BaseViewController
<
    UITextFieldDelegate
>

@property (nonatomic, strong) IBOutlet UITextField *m_CodeTextField;
@property (nonatomic, strong) IBOutlet UIButton *m_CommitButton;
@property (nonatomic, strong) ASIHTTPRequest *m_Request;
@property (nonatomic, strong) MBProgressHUD  *m_LoadProgress;

@property (nonatomic, assign) id <BBFillBandCodeDelegate> delegate;
@end
