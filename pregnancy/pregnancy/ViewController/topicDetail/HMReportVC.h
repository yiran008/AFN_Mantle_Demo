//
//  HMReportVC.h
//  lama
//
//  Created by songxf on 14-4-21.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "ASIFormDataRequest+BBDebug.h"
#import "MBProgressHUD.h"

@interface HMReportVC : BaseViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) IBOutlet UITableView *m_ReportTableView;
@property (nonatomic, strong) NSString *m_ReportedName;
@property (nonatomic, strong) NSString *m_TopicID;
@property (nonatomic, strong) NSString *m_ReplyID;
@property (nonatomic, assign) BOOL m_IsReply;
@property (nonatomic, strong) ASIHTTPRequest *m_ReportRequest;
@property (nonatomic, strong) MBProgressHUD *m_ProgressHUD;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withReportedName:(NSString *)reportedName topicID:(NSString *)topicID replyID:(NSString *)replyID floor:(NSString *)floor;

@end
