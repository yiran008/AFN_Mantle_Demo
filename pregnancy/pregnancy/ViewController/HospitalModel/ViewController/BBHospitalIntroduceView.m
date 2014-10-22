//
//  BBHospitalIntroduceView.m
//  pregnancy
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBHospitalIntroduceView.h"
#import "BBMapRoute.h"


@implementation BBHospitalIntroduceView

@synthesize introBg, descriptionBg,nameLabel, telLabel, locationLabel, longLocationLabel, longTelLabel, introductionLabel, introductionTextView, myRequest, hospitalId, hud, latitude, longitude,viewCtrl;

- (void)dealloc
{
    [introBg release];
    [descriptionBg release];
    [nameLabel release];
    [telLabel release];
    [locationLabel release];
    [longTelLabel release];
    [longLocationLabel release];
    [introductionLabel release];
    [introductionTextView release];
    [myRequest clearDelegatesAndCancel];
    [myRequest release];
    [hospitalId release];
    [hud release];
    [latitude release];
    [longitude release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initSubViewsWithHospitalId:(NSString *)hosId
{
    self.hospitalId = hosId;
    self.latitude = nil;
    self.longitude = nil;
    
    self.hud = [[[MBProgressHUD alloc] initWithView:self] autorelease];
    [self addSubview:hud];
    
    self.myRequest = nil;
    
    //iphone5适
    if (IS_IPHONE5) {
        [self.introductionTextView setFrame:CGRectMake(introductionTextView.frame.origin.x, introductionTextView.frame.origin.y, introductionTextView.frame.size.width, introductionTextView.frame.size.height + 88)];
        [self.descriptionBg setFrame:CGRectMake(descriptionBg.frame.origin.x, descriptionBg.frame.origin.y, descriptionBg.frame.size.width, descriptionBg.frame.size.height + 88)];
    }
}

- (void)refreshData
{
    if (self.latitude == nil) {
        [hud setLabelText:@"加载中..."];
        [hud show:YES];
        
        if (self.myRequest != nil) {
            [self.myRequest clearDelegatesAndCancel];
        }
        self.myRequest = [BBHospitalRequest hospitalInformationWithHospitalId:self.hospitalId];
        [self.myRequest setDelegate:self];
        [self.myRequest setDidFinishSelector:@selector(connectFinished:)];
        [self.myRequest setDidFailSelector:@selector(connectFail:)];
        [self.myRequest startAsynchronous];
    }
}

- (void)adjustHeightWithData:(NSDictionary *)data
{
    self.nameLabel.text = [data stringForKey:@"name"];
    self.latitude = [data stringForKey:@"y"];
    self.longitude = [data stringForKey:@"x"];
    
    NSString *telStr = [data stringForKey:@"tel"];
    CGSize telSize = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(140.0, 1000) withFont:[UIFont boldSystemFontOfSize:14.0] withString:telStr];
    CGFloat telAddHeight = telSize.height - self.longTelLabel.frame.size.height;
    CGFloat totalAddHeight = 0;
    CGRect frame = self.longTelLabel.frame;
    if (telAddHeight > 0) 
    {
        totalAddHeight += telAddHeight;
        
        frame.size.height += telAddHeight;
        [self.longTelLabel setFrame:frame];
        
        frame = self.longLocationLabel.frame;
        frame.origin.y += telAddHeight;
        [self.longLocationLabel setFrame:frame];
        
        frame = self.locationLabel.frame;
        frame.origin.y += telAddHeight;
        [self.locationLabel setFrame:frame];
        
        frame = self.introductionLabel.frame;
        frame.origin.y += telAddHeight;
        [self.introductionLabel setFrame:frame];
        
        frame = self.introductionTextView.frame;
        frame.origin.y += telAddHeight;
        frame.size.height -= telAddHeight;
        [self.introductionTextView setFrame:frame];
        
        frame = self.descriptionBg.frame;
        frame.origin.y += telAddHeight;
        frame.size.height -= telAddHeight;
        [self.descriptionBg setFrame:frame];
    }
    
    NSString *locStr =[data stringForKey:@"address"];
    CGSize locSize =
    [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(228, 1000) withFont:[UIFont boldSystemFontOfSize:14.0] withString:locStr];
    CGFloat locAddHeight = locSize.height - self.longLocationLabel.frame.size.height;
    frame = self.longLocationLabel.frame;
    if (locAddHeight > 0) 
    {
        totalAddHeight += locAddHeight;
        
        frame.size.height += locAddHeight;
        [self.longLocationLabel setFrame:frame];

        frame = self.introductionLabel.frame;
        frame.origin.y += locAddHeight;
        [self.introductionLabel setFrame:frame];
        
        frame = self.introductionTextView.frame;
        frame.origin.y += locAddHeight;
        frame.size.height -= locAddHeight;
        [self.introductionTextView setFrame:frame];
        
        frame = self.descriptionBg.frame;
        frame.origin.y += locAddHeight;
        frame.size.height -= locAddHeight;
        [self.descriptionBg setFrame:frame];
    }
    
    if (totalAddHeight > 0) 
    {
        UIImage *backgroundImage = nil;
        if ([[UIImage imageNamed:@"hospital_introduction_bg.png"] respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            backgroundImage = [[UIImage imageNamed:@"hospital_introduction_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 8, 18, 8)];
        } else {
            backgroundImage = [[UIImage imageNamed:@"hospital_introduction_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        }
        
        frame = self.introBg.frame;
        frame.size.height += totalAddHeight;
        self.introBg.frame = frame;
        [self.introBg setImage:backgroundImage];
    }
    self.longTelLabel.text =[data stringForKey:@"tel"];
    self.longLocationLabel.text =[data stringForKey:@"address"];
    NSString *intro = [data stringForKey:@"description"];
    self.introductionTextView.text = [intro isNotEmpty] ? intro : @"暂无内容";
}

- (IBAction)locationButtonClicked:(id)sender
{
    BBMapRoute *mapRoute = [[[BBMapRoute alloc]initWithNibName:@"BBMapRoute" bundle:nil]autorelease];
    mapRoute.hospitalName = nameLabel.text;
    mapRoute.hospitalLatitude = [self.latitude doubleValue];
    mapRoute.hospitalLongitude = [self.longitude doubleValue];
    [self.viewCtrl.navigationController pushViewController:mapRoute animated:YES];
}

#pragma mark-- ASIFormDataRequest
- (void)connectFinished:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *parserData = [parser objectWithString:responseString error:&error];
    NSLog(@"%@", parserData);
    if (error != nil) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    if ([[parserData stringForKey:@"status"] isEqualToString:@"success"]) 
    {
        NSDictionary *resultData = [parserData dictionaryForKey:@"data"];
        [self adjustHeightWithData:resultData];
    } else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"失败" message:[parserData stringForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)connectFail:(ASIFormDataRequest *)request
{
    [hud hide:YES];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}


- (NSString *)checkNSnull:(NSString *)str
{
    if ((NSNull *)str ==[NSNull null] || str==nil)
    {
        return @"";
    }
    return str;
}
@end
