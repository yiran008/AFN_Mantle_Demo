//
//  BBSelectArea.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSelectArea.h"
#import "BBSelectStyleCell.h"
#import "BBAreaDB.h"
#import "BBSelectMoreArea.h"
#import "BBSelectCity.h"
#import "BBNavigationLabel.h"
#import "BBApp.h"
#import "BBAppConfig.h"
#import "MobClick.h"

@implementation BBSelectArea

@synthesize areaTableView;
@synthesize selectedCityData;
@synthesize hotAreaData;
@synthesize selectAreaCallBackHander;
-(void)dealloc
{
    [areaTableView release];
    [selectedCityData release];
    [hotAreaData release];
    
    [super dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedCityData = [BBSelectArea getSelectedCityList];
        self.hotAreaData = [BBAreaDB provinceAndCityList];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"地区选择"];
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    [backButton setFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
    
    self.areaTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, IPHONE5_ADD_HEIGHT(416)) style:UITableViewStylePlain] autorelease];
    areaTableView.delegate = self;
    areaTableView.dataSource = self;
    [self.view addSubview:areaTableView];
    [areaTableView reloadData];
    
    IPHONE5_ADAPTATION
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    IOS6_RELEASE_VIEW
}

- (void)viewDidUnload
{
    [self viewDidUnloadBabytree];
    [super viewDidUnload];
}

- (void)viewDidUnloadBabytree
{
    self.areaTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//lijie 修改不支持旋转 6.0
- (BOOL)shouldAutorotate
{
    return NO;
}
//lijie 修改不支持旋转 6.0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - IBAction Event Handler Mehthod

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        if ([selectedCityData count]>3) {
            return 3;
        }
        return [selectedCityData count];
    }else if(section == 1){
        return [hotAreaData count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        static NSString *CellIdentifier2 = @"Cell";
        UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];    
        }
        cell.textLabel.text = [[selectedCityData objectAtIndex:indexPath.row] stringForKey:@"name"];
        return cell;
    }else if(indexPath.section==1){
        NSMutableDictionary *info = [hotAreaData objectAtIndex:indexPath.row];
        
        if([hotAreaData count] == indexPath.row +1){
            static NSString *CellIdentifier = @"BBSelectStyleCell";
            BBSelectStyleCell *cell = (BBSelectStyleCell *)[tableView dequeueReusableCellWithIdentifier:@"BBSelectStyleCell"];
            if (cell == nil) {
                cell = [[[BBSelectStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];    
            }
            [cell setCellTietle:[info stringForKey:@"name"]];
            return cell;
        }else{
            static NSString *CellIdentifier2 = @"Cell";
            UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];    
            }
            cell.textLabel.text = [info stringForKey:@"name"];
            return cell;
        
        } 
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *sectionView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 317, 30)] autorelease];
    [sectionView setImage:[UIImage imageNamed:@"section_bar"]];
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 200, 20)] autorelease];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [sectionView addSubview:titleLabel];
    if(section == 0){
        titleLabel.text = @"你常用的城市";
    }else if(section == 1){
        titleLabel.text = @"热点地区";
    }
    return sectionView;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        NSMutableDictionary *info = [selectedCityData objectAtIndex:indexPath.row];
        [BBSelectArea insertSelectedCity:info];
        [selectAreaCallBackHander selectAreaCallBack:info];
    }else if(indexPath.section==1){
        NSMutableDictionary *info = [hotAreaData objectAtIndex:indexPath.row];
        if(indexPath.row+1==[hotAreaData count]){
            BBSelectMoreArea *selectMoreArea = [[[BBSelectMoreArea alloc]initWithNibName:@"BBSelectMoreArea" bundle:nil]autorelease];
            selectMoreArea.selectAreaCallBackHander = self.selectAreaCallBackHander;
            [self.navigationController pushViewController:selectMoreArea animated:YES]; 
        }else{
            [BBSelectArea insertSelectedCity:info];
            [selectAreaCallBackHander selectAreaCallBack:info];
        }
    }
}

+ (void)insertSelectedCity:(id)object{
    NSDictionary *objectDict = (NSDictionary*)object;
    NSMutableArray *list = [self getSelectedCityList];
    int size = [list count];
    if(size>3){
        size=3;
    }
    BOOL flag = NO;
    for (int i=0; i<size; i++) {
        if([[objectDict stringForKey:@"name"]isEqualToString:[[list objectAtIndex:i] stringForKey:@"name"]]){
            [list removeObjectAtIndex:i];
            [list insertObject:objectDict atIndex:0];
            flag = YES;
            break;
        }
    }
    if(flag == NO){
        [list insertObject:objectDict atIndex:0];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults safeSetContainer:list forKey:@"selectedCityList"];
    [defaults synchronize];
}
+ (NSMutableArray *)getSelectedCityList{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"selectedCityList"] !=nil){
        return [NSMutableArray arrayWithArray:[defaults objectForKey:@"selectedCityList"]];
    }
    return [[[NSMutableArray alloc] init] autorelease];
}

@end
