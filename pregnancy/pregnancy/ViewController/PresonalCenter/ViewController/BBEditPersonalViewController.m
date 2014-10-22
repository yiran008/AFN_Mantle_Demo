//
//  BBEditPersonalViewController.m
//  pregnancy
//
//  Created by zhangzhongfeng on 14-1-10.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBEditPersonalViewController.h"
#import "BBEditPersonalCell.h"
#import "BBUser.h"
#import "UIImageView+WebCache.h"
#import "BBPregnancyInfo.h"
#import "BBHospitalRequest.h"
#import "BBAreaDB.h"
#import "BBApp.h"
#import "BBNavigationLabel.h"
#import "ASIFormDataRequest.h"
#import "MobClick.h"
//#import "YBBDateCalculation.h"
#import "BBDueDateViewController.h"
#import "BBHospitalListViewCtr.h"
#import "BBSelectHospitalArea.h"
#import "BBSelectMoreArea.h"
#import "BBImageScale.h"
#import "BBTopicRequest.h"
#import "YBBDateSelect.h"

@interface BBEditPersonalViewController ()
@property (nonatomic, retain) UITableView       *userTable;
@property (nonatomic, retain) ASIFormDataRequest    *saveSexRequest;
@property (nonatomic, retain) MBProgressHUD *saveProgress;
@property (nonatomic, retain) NSString              *gender;
@property (nonatomic, retain) ASIFormDataRequest    *locationRequest;
@property (nonatomic, retain) NSString              *location;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) ASIFormDataRequest    *avatarUploadRequest;
@property (nonatomic, retain) ASIFormDataRequest        *userInfoRequest;
//modifyNickNameStatus 表示用户修改昵称的状态，当为nil时，表示网络有问题，没有取到数值; 当为“1”时表示可以修改昵称; 当为“0”时表示不可以修改昵称;
@property (nonatomic, copy) NSString *modifyNickNameStatus;

@end

@implementation BBEditPersonalViewController

//这里等待确定6.0以上的内存警告处理方式
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)dealloc
{
    [_saveSexRequest clearDelegatesAndCancel];
    [_locationRequest clearDelegatesAndCancel];
    [_avatarUploadRequest clearDelegatesAndCancel];
    [_userInfoRequest clearDelegatesAndCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);

    self.gender = [BBUser getGender];
    [self setNav];
    [self addBackButton];
    [self addUserTable];
    self.saveProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.saveProgress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfo];
    [self.userTable reloadData];
}

- (void)addUserTable
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.userTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 44) style:UITableViewStylePlain];

    }else {
        self.userTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 20 - 44) style:UITableViewStyleGrouped];
    }
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    [header setBackgroundColor:[UIColor clearColor]];
    self.userTable.delegate = self;
    self.userTable.dataSource = self;
    self.userTable.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:self.userTable];
    [self.view addSubview:self.userTable];
}

- (void)setNav
{
    self.navigationItem.title = @"个人资料编辑";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
}
- (void)addBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SetAvatarOnCell:(BBEditPersonalCell *)cell
{

    if ([BBUser getLocalAvatar] != nil)
    {
        UIImage *avatarImage = [[UIImage alloc] initWithContentsOfFile:[BBUser getLocalAvatar]];
        cell.avatarImageView.image = avatarImage;
    }
    else
    {
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:[BBUser getAvatarUrl]] placeholderImage:[UIImage imageNamed:@"personal_default_avatar"]];
    }
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)saveInfoSexReloadData
{
    [self showProgressWithTitle:@"保存性别..."];
    [self.saveSexRequest clearDelegatesAndCancel];
    self.saveSexRequest =[BBUserRequest modifyUserInfoGender:self.gender];
    [self.saveSexRequest setDelegate:self];
    [self.saveSexRequest setDidFinishSelector:@selector(saveInfoSexReloadDataFinished:)];
    [self.saveSexRequest setDidFailSelector:@selector(saveInfoSexReloadDataFail:)];
    [self.saveSexRequest startAsynchronous];
}

//判断是否需要上传头像
- (void)checkUploadAvatar
{
    if ([BBUser needUploadAvatar] && [BBUser isLogin]) {
        UIImage *imageAvatar = [[UIImage alloc] initWithContentsOfFile:[BBUser getLocalAvatar]];
        NSData *imageData = UIImageJPEGRepresentation(imageAvatar, 1.0);
        if (imageData) {
            [self.avatarUploadRequest clearDelegatesAndCancel];
            self.avatarUploadRequest = [BBTopicRequest uploadIcon:imageData withLoginString:[BBUser getLoginString]];
            [self.avatarUploadRequest setDidFinishSelector:@selector(avatarRequestFinish:)];
            [self.avatarUploadRequest setDidFailSelector:@selector(avatarRequestFail:)];
            [self.avatarUploadRequest setDelegate:self];
            [self.avatarUploadRequest startAsynchronous];
        }
    }
}

- (void)cameraBackAction:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == 1)
    {
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    else
    {
        [self.imagePicker popViewControllerAnimated:YES];
        
    }
}

- (void)hideProgerssWithTile:(NSString *)title delay:(float)delay customImageName:(NSString *)iamgeName {
    self.saveProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iamgeName]];
    self.saveProgress.mode = MBProgressHUDModeCustomView;
    self.saveProgress.labelText = title;
    [self.saveProgress hide:YES afterDelay:delay];
}

- (void)showProgressWithTitle:(NSString *)title
{
    self.saveProgress.mode = MBProgressHUDModeIndeterminate;
    self.saveProgress.labelText = title;
    [self.saveProgress show:YES];
}

- (void)getUserInfo
{
    NSMutableString *getStr = [[NSMutableString alloc] initWithString:@"can_modify_nickname"];
    [self showProgressWithTitle:@"加载中..."];
    [self.userInfoRequest clearDelegatesAndCancel];
    self.userInfoRequest = [BBUserRequest getUserInfoWithID:[BBUser getEncId] param:getStr];
    [self.userInfoRequest setDidFinishSelector:@selector(getUserInfoFinish:)];
    [self.userInfoRequest setDidFailSelector:@selector(getUserInfoFail:)];
    [self.userInfoRequest setDelegate:self];
    [self.userInfoRequest startAsynchronous];
}


#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (section == 0) {
        row = 1;
    }else if (section == 1) {
        row = 5;
    }else if (section == 2) {
        row = 2;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    BBEditPersonalCell *cell = (BBEditPersonalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BBEditPersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295, 19, 9, 14)];
        arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        arrowImageView.tag = 100;
        [cell addSubview:arrowImageView];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UIImageView *arrowImageView = (UIImageView *)[cell viewWithTag:100];
    if (arrowImageView) {
        arrowImageView.hidden = NO;
    }
    cell.avatarImageView.hidden = YES;
    cell.userAttributeLable.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userValueLabel.textColor = RGBColor(85, 85, 85, 1);
    
    if (indexPath.section == 0) {
        cell.avatarImageView.hidden = NO;
        [cell.avatarImageView.layer setMasksToBounds:YES];
        [cell.avatarImageView.layer setCornerRadius:20.0f];
        [self SetAvatarOnCell:cell];
        cell.userValueLabel.text = @"修改头像";
    }else if (indexPath.section == 1) {
        cell.userAttributeLable.hidden = NO;
        if (indexPath.row == 0) {
            cell.userAttributeLable.text = @"昵称";
            cell.userValueLabel.text = [BBUser getNickname];
        }else if (indexPath.row == 1) {
            cell.userAttributeLable.text = @"性别";
            if([self.gender isEqualToString:@"male"])
            {
                cell.userValueLabel.text = @"男";
            }
            else{
                cell.userValueLabel.text = @"女";
            }
            
        }else if (indexPath.row == 2) {
            if ([BBUser getNewUserRoleState]==BBUserRoleStateHasBaby)
            {
                cell.userAttributeLable.text = @"宝宝生日";
            }
            else
            {
                cell.userAttributeLable.text = @"预产期";
            }
            cell.userValueLabel.text = [BBPregnancyInfo pregancyDateByString];

        }else if (indexPath.row == 3) {
            cell.userAttributeLable.text = @"医院";
            
            NSDictionary *hospitalData = [BBHospitalRequest getHospitalCategory];
            if (hospitalData != nil) {
                cell.userValueLabel.text = [hospitalData stringForKey:kHospitalNameKey];
            } else if ([[BBHospitalRequest getAddedHospitalName] length] != 0) {
                cell.userValueLabel.text = [BBHospitalRequest getAddedHospitalName];

            } else {
                cell.userValueLabel.text = @"未设置医院";
            }

        }else if (indexPath.row == 4) {
            cell.userAttributeLable.text = @"地区";
            
            NSString *cityId = [BBUser getLocation];
            
            if ([cityId length]>0) {
                NSString *tmpLocation = [BBAreaDB areaByCiytCode:cityId];
                if ([tmpLocation length]>12) {
                    tmpLocation = [BBAreaDB getCityNameByCiytCode:cityId];
                }
                if ([tmpLocation isEqualToString:@""]||tmpLocation ==nil)
                {
                    tmpLocation = @"未设置地区";
                }
                cell.userValueLabel.text = tmpLocation;
            } else {
                cell.userValueLabel.text = @"未设置地区";
            }
        }
    }else if (indexPath.section == 2) {
        if (arrowImageView) {
            arrowImageView.hidden = YES;
        }
        cell.userAttributeLable.hidden = NO;
        if (indexPath.row == 0) {
            cell.userAttributeLable.text = @"邮箱";
            cell.userValueLabel.text = [BBUser getEmailAccount];
            cell.userValueLabel.textColor = RGBColor(170, 170, 170, 1);

        }else if (indexPath.row == 1) {
            cell.userAttributeLable.text = @"注册时间";
            cell.userValueLabel.text = [BBUser getRegisterTime];
            cell.userValueLabel.textColor = RGBColor(170, 170, 170, 1);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [MobClick event:@"edit_v2" label:@"修改头像"];
        if (indexPath.row == 0) {
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                self.imagePicker = [[UIImagePickerController alloc] init];
                [self.imagePicker setDelegate:self];
                [self.imagePicker setAllowsEditing:YES];
                [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [self presentViewController:self.imagePicker animated:YES completion:^{
                    
                }];
            } else {
                UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"头像选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil];
                photoActionSheet.tag = 10;
                [photoActionSheet showInView:self.view];
            }
        }
    }else if (indexPath.section == 1) {
        [MobClick event:@"edit_v2" label:@"昵称"];
        if (indexPath.row == 0) {
            if (self.modifyNickNameStatus == nil)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            if ([self.modifyNickNameStatus boolValue])
            {
                BBModifyNickName *modifyNickName = [[BBModifyNickName alloc]initWithNibName:@"BBModifyNickName" bundle:nil];
                modifyNickName.nickname = [BBUser getNickname];
                modifyNickName.delegate = self;
                [self.navigationController pushViewController:modifyNickName animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"本月你已修改过昵称" message:@"昵称一个月只能修改一次" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }
            
        }else if (indexPath.row == 1) {
            [MobClick event:@"edit_v2" label:@"性别"];
            UIActionSheet *selectSex = [[UIActionSheet alloc] initWithTitle:@"性别修改" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"女", @"男", nil];
            [selectSex setTag:5];
            
            [selectSex showInView:self.view];
        }else if (indexPath.row == 2) {
            if ([BBUser getNewUserRoleState] == BBUserRoleStateHasBaby)
            {
                [MobClick event:@"edit_v2" label:@"宝宝生日"];
                YBBDateSelect *modifyDueDate = [[YBBDateSelect alloc] initWithNibName:@"YBBDateSelect" bundle:nil];
                [self.navigationController pushViewController:modifyDueDate animated:YES];
            }
            else
            {
                [MobClick event:@"edit_v2" label:@"预产期"];
                BBDueDateViewController *dueDate = [[BBDueDateViewController alloc] initWithNibName:@"BBDueDateViewController" bundle:nil];
                [self.navigationController pushViewController:dueDate animated:YES];
            }

        }else if (indexPath.row == 3) {
            [MobClick event:@"edit_v2" label:@"医院"];
            NSDictionary *hospitalData = [BBHospitalRequest getHospitalCategory];
            if (hospitalData != nil) {
                BBHospitalListViewCtr *hospitalView = [[BBHospitalListViewCtr alloc] initWithNibName:@"BBHospitalListViewCtr" bundle:nil];
                hospitalView.hospitalId = [hospitalData stringForKey:kHospitalHospitalIdKey];
                hospitalView.isBackClickSwitchCityBtn = NO;
                [self.navigationController pushViewController:hospitalView animated:YES];
            }
            else {
                BBSelectHospitalArea *selectHospitalArea = [[BBSelectHospitalArea alloc] initWithNibName:@"BBSelectHospitalArea" bundle:nil];
                [self.navigationController pushViewController:selectHospitalArea animated:YES];
            }

        }else if (indexPath.row == 4) {
            [MobClick event:@"edit_v2" label:@"地区"];
            BBSelectMoreArea *selectMoreArea = [[BBSelectMoreArea alloc]initWithNibName:@"BBSelectMoreArea" bundle:nil];
            selectMoreArea.selectAreaCallBackHander = self;
            [self.navigationController pushViewController:selectMoreArea animated:YES];

        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1) {
            
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//选择地区 CallBack
- (void)selectAreaCallBack:(id)object
{
    NSDictionary *objectDict = (NSDictionary*)object;
    NSString *cityId = [objectDict stringForKey:@"id"];
    if (cityId != nil && ![cityId isEqual:[NSNull null]]) {
        [self.locationRequest clearDelegatesAndCancel];
        self.locationRequest = [BBUserRequest modifyUserInfo:cityId];
        [self.locationRequest setDelegate:self];
        [self.locationRequest setDidFinishSelector:@selector(saveLocationFinish:)];
        [self.locationRequest setDidFailSelector:@selector(saveLocationFail:)];
        [self.locationRequest startAsynchronous];
        self.location = cityId;
        [self showProgressWithTitle:@"保存城市..."];
    }
    [self.navigationController popToViewController:self animated:YES];
}

//保存城市成功
- (void)saveLocationFinish:(ASIFormDataRequest *)request
{
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    NSString *status = [data stringForKey:@"status"];
    if (error == nil) {
        if ([status isEqualToString:@"success"]) {
            [BBUser setLocation:self.location];
            [BBUser setUserOnlyCity:self.location];
            [self hideProgerssWithTile:@"保存成功" delay:1 customImageName:@"37x-Checkmark"];
            [[NSNotificationCenter defaultCenter] postNotificationName:DIDCHANGE_CIRCLE_LOGIN_STATE object:nil];
            [self.userTable reloadData];
            return;
        }
    }

    [self hideProgerssWithTile:@"保存失败" delay:2 customImageName:@"xxx"];
}
//保存城市失败
- (void)saveLocationFail:(ASIFormDataRequest *)request
{
    [self hideProgerssWithTile:@"保存失败" delay:2 customImageName:@"xxx"];
}

- (void)saveInfoSexReloadDataFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    NSString *status = [data stringForKey:@"status"];
    if (error == nil) {
        if ([status isEqualToString:@"success"]) {
            [BBUser setGender:self.gender];
            [self hideProgerssWithTile:@"保存成功" delay:1 customImageName:@"37x-Checkmark"];
        }
        else {
            [self hideProgerssWithTile:@"保存失败" delay:1 customImageName:@"xxx"];

        }
    }
}

- (void)saveInfoSexReloadDataFail:(ASIHTTPRequest *)request
{
    [self.saveSexRequest clearDelegatesAndCancel];
    self.saveSexRequest = nil;
    [self hideProgerssWithTile:@"保存失败" delay:1 customImageName:@"xxx"];
}

#pragma mark - ASIHttpRequest Delegate Request

- (void)getUserInfoFinish:(ASIFormDataRequest *)request
{
    [self.saveProgress hide:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *requestData = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    
    if ([[requestData stringForKey:@"status"] isEqualToString:@"success"] || [[requestData stringForKey:@"status"] isEqualToString:@"1"]) {
        NSDictionary *data = [requestData dictionaryForKey:@"data"];
        if ([data isNotEmpty])
        {
            
            self.modifyNickNameStatus = [data stringForKey:@"can_modify_nickname"];
        }
    }
}

- (void)getUserInfoFail:(ASIFormDataRequest *)request
{
    [self.saveProgress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)avatarRequestFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data stringForKey:@"status"] isEqualToString:@"success"]) {
        [BBUser setAvatarUrl:[[data dictionaryForKey:@"data"] stringForKey:@"url"]];
        [BBUser setNeedRefreshNotificationList:YES];
        [BBUser setNeedUploadAvatar:NO];
    }
}

- (void)avatarRequestFail:(ASIFormDataRequest *)request
{
    
}


- (void)successModifyNickname
{
    self.modifyNickNameStatus = @"0";
    [self.userTable reloadData];
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 20){
//        if (buttonIndex == 1) {
//            BBModifyNickName *modifyNickName = [[[BBModifyNickName alloc]initWithNibName:@"BBModifyNickName" bundle:nil]autorelease];
//            modifyNickName.nickname = [BBUser getNickname];
//            modifyNickName.delegate = self;
//            [self.navigationController pushViewController:modifyNickName animated:YES];
//        }
//        
//    }
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 5)
    {
        if (buttonIndex == 0)
        {
            self.gender = @"female";
            [self saveInfoSexReloadData];
        }
        else if (buttonIndex == 1)
        {
            self.gender = @"male";
            [self saveInfoSexReloadData];
        }
        [self.userTable reloadData];
    } else if (actionSheet.tag == 10)
    {
        UIImagePickerControllerSourceType sourceType = 0;
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            return;
        }
        self.imagePicker = [[UIImagePickerController alloc] init];
        [self.imagePicker setDelegate:self];
        [self.imagePicker setAllowsEditing:YES];
        [self.imagePicker setSourceType:sourceType];
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [BBImageScale imageScalingForSize:CGSizeMake(100, 100) withImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self.userTable reloadData];
    
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserAvatar.png"];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:NO];
    [BBUser setLocalAvatar:imagePath];
    [BBUser setNeedUploadAvatar:YES];
    
    [self performSelector:@selector(checkUploadAvatar) withObject:nil afterDelay:0.5];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton setTag:[navigationController.viewControllers count]];
    [backButton addTarget:self action:@selector(cameraBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [viewController.navigationItem setLeftBarButtonItem:backBarButton];
    
    UIView *nilView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)];
    UIBarButtonItem *nilBarButton = [[UIBarButtonItem alloc] initWithCustomView:nilView];
    [viewController.navigationItem setRightBarButtonItem:nilBarButton];
    [viewController.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:viewController.navigationItem.title]];
    [viewController.navigationController setPregnancyColor];//设置导航栏颜色
    
}

@end
