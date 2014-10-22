//
//  BBHospitalPregnancyCell.m
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalPregnancyCell.h"
#import "BBPersonalViewController.h"
#import "BBSendMessage.h"

@implementation BBHospitalPregnancyCell

@synthesize nameLabel, dateLabel, headImage, pregnancyData,viewCtrl;

- (void)dealloc
{
    [nameLabel release];
    [dateLabel release];
    [headImage release];
    [pregnancyData release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data
{
    UIButton *button1 = (UIButton *)[self viewWithTag:101];
    [button1 setExclusiveTouch:YES];
    UIButton *button2 = (UIButton *)[self viewWithTag:102];
    [button2 setExclusiveTouch:YES];
    self.pregnancyData = data;
    
    self.nameLabel.text = [self.pregnancyData stringForKey:@"nickname"];
    self.dateLabel.text = [self.pregnancyData stringForKey:@"baby_age"];
    
    [self.headImage setImageWithURL:[NSURL URLWithString:[self.pregnancyData stringForKey:@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.exclusiveTouch = YES;
}

- (IBAction)personDetailAction:(UIButton *)sender
{
#if USE_HOSPITAL_MODEL
    BBPersonalViewController *userInformation = [[[BBPersonalViewController alloc]initWithNibName:@"BBPersonalViewController" bundle:nil]autorelease];
    userInformation.userName = [self.pregnancyData stringForKey:@"nickname"];
    userInformation.userEncodeId = [self.pregnancyData stringForKey:@"enc_user_id"];
    [viewCtrl.navigationController pushViewController:userInformation animated:YES];
#endif
}

- (IBAction)sendMessageButtonClicked:(id)sender
{
#if USE_HOSPITAL_MODEL
    if ([BBUser isLogin]) {
        BBSendMessage *sendMessage = [[[BBSendMessage alloc]initWithNibName:@"BBSendMessage" bundle:nil withUID:[self.pregnancyData stringForKey:@"enc_user_id"]]autorelease];
        sendMessage.isHospitalMessage = YES;
        [viewCtrl.navigationController pushViewController:sendMessage animated:YES];
        
    } else {
        BBLogin *login = [[[BBLogin alloc]initWithNibName:@"BBLogin" bundle:nil]autorelease];
        login.m_LoginType = BBPresentLogin;
        BBCustomNavigationController *navCtrl = [[[BBCustomNavigationController alloc]initWithRootViewController:login]autorelease];
        [navCtrl setColorWithImageName:@"navigationBg"];
        login.delegate = self;
        [viewCtrl.navigationController  presentViewController:navCtrl animated:YES completion:^{
            
        }];
    }
#endif
    
}

#pragma mark - CallBack
- (void)callback
{
    
#if USE_HOSPITAL_MODEL
    BBSendMessage *sendMessage = [[[BBSendMessage alloc]initWithNibName:@"BBSendMessage" bundle:nil withUID:[self.pregnancyData stringForKey:@"enc_user_id"]]autorelease];
    [viewCtrl.navigationController pushViewController:sendMessage animated:YES];
#endif

}

- (void)loginFinish
{
#if USE_HOSPITAL_MODEL
    BBSendMessage *sendMessage = [[[BBSendMessage alloc]initWithNibName:@"BBSendMessage" bundle:nil withUID:[self.pregnancyData stringForKey:@"enc_user_id"]]autorelease];
    [viewCtrl.navigationController pushViewController:sendMessage animated:YES];
#endif
}

@end
