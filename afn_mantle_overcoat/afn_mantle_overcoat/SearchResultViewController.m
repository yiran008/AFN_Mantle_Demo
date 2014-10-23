//
//  SearchResultViewController.m
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/22/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "SearchResultViewController.h"
#import "OVCHTTPRequestOperationManager.h"
#import "SResultModel.h"
@interface SearchResultViewController ()<UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (copy, nonatomic) NSArray *userArray;
@property (strong, nonatomic) NSArray *searchList;
@property (strong, nonatomic) OVCHTTPRequestOperationManager *requst;

@end

@implementation SearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [self.requst cancelAllRequests];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchList = @[@"宝妈",@"孕期",@"辣妈",@"宝贝"];
    // Do any additional setup after loading the view.
    self.requst = [OVCHTTPRequestOperationManager manager];
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleBordered target:self action:@selector(searchUser)];
        searchItem;
    });
    [self searchUserNamed:[self.searchList firstObject]];
}

-(void)searchUser
{
    NSString *title = self.navigationItem.title;
    NSUInteger oldIndex = [self.searchList indexOfObject:title];
    NSString *keyword = self.searchList[(oldIndex+1)%[self.searchList count]];
    [self searchUserNamed:keyword];
}

-(void)searchUserNamed:(NSString *)userName
{
    [self showSearchingAnimation];
    [self.requst cancelAllRequests];
    [self changeTitle:userName];
    __weak __typeof (self) weakself = self;
    [self.requst GET:[NSString stringWithFormat:@"%@/api/mobile_search/search_user",BABY_TREE_SERVER] parameters:@{@"pg":@"1",@"q":userName} completion:^(id response, NSError *error) {
        __strong __typeof (weakself) strongself = weakself;
        if (!strongself)
        {
            return;
        }
        if (!error)
        {
            SResultModel *result = [MTLJSONAdapter modelOfClass:SResultModel.class fromJSONDictionary:response error:NULL];
            strongself.userArray = result.list;
            [strongself hideSearchingAnimation];
            [strongself.listView reloadData];
        }
    }];
}

-(void)showSearchingAnimation
{
    self.navigationItem.leftBarButtonItem = ({
        UIActivityIndicatorView *acIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [acIndicator startAnimating];
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:acIndicator];
        searchItem;
    });
}

-(void)hideSearchingAnimation
{
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)changeTitle:(NSString*)title
{
    self.navigationItem.title = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"UserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    UserModel *user = self.userArray[indexPath.row];
    cell.textLabel.text = user.userName;
    cell.detailTextLabel.text = user.userId;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
