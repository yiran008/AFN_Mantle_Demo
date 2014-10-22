//
//  BBKnowledgeListVC.m
//  pregnancy
//
//  Created by liumiao on 4/24/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBKnowledgeFirstLevelVC.h"
#import "BBKnowledgeFirstLevelCell.h"
#import "BBKnowledgeSecondLevelVC.h"
#import "BBKonwlegdeDB.h"
@interface BBKnowledgeFirstLevelVC ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic,strong)UITableView *s_ListView;
@property (nonatomic,strong)NSDictionary *s_SourceDict;
@property (nonatomic,strong)NSArray *s_AllKeys;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation BBKnowledgeFirstLevelVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"knowledge_lib_v2" label:@"知识分类列表pv"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    
    self.navigationItem.title = @"知识库";
    [self.navigationItem setTitleView:[BBNavigationLabel customNavigationLabel:self.navigationItem.title]];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.exclusiveTouch = YES;
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    self.s_ListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.s_ListView.delegate = self;
    self.s_ListView.dataSource = self;
    [self.s_ListView setBackgroundColor:[UIColor clearColor]];
    self.s_ListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.s_ListView.rowHeight = 58;
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 8)];
    [footer setBackgroundColor:[UIColor clearColor]];
    self.s_ListView.tableFooterView = footer;
    [self.view addSubview:self.s_ListView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    self.s_AllKeys = [[NSArray alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.s_SourceDict = [[NSDictionary alloc]initWithDictionary:[BBKonwlegdeDB allKonwledgeLibData]];
        self.s_AllKeys = [self.s_SourceDict arrayForKey:KNOWLEDGE_ALLKEYS];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.s_ListView reloadData];
            [self.hud hide:YES];
        });
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBKnowledgeFirstLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBKnowledgeFirstLevelCell"];
    if (cell == nil)
    {
        cell = [[BBKnowledgeFirstLevelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBKnowledgeFirstLevelCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.m_KnowledgeSpeciesLabel.text = [self.s_AllKeys objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.s_AllKeys count];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.s_AllKeys objectAtIndex:indexPath.row];
    BBKonwlegdeModel *secondModel = [self.s_SourceDict objectForKey:key];
    
    BBKnowledgeSecondLevelVC *knowledgeSecondLevelVC = [[BBKnowledgeSecondLevelVC alloc]init];
    knowledgeSecondLevelVC.navigationItem.title = key;
    knowledgeSecondLevelVC.m_SourceArray = secondModel.customArr;
    [self.navigationController pushViewController:knowledgeSecondLevelVC animated:YES];
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
