//
//  BBKnowledgeSecondLevelVC.m
//  pregnancy
//
//  Created by liumiao on 4/24/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBKnowledgeSecondLevelVC.h"
#import "BBKnowledgeSecondLevelCell.h"
#import "BBKnowledgeSecondLevelCell.h"
#import "BBKonwlegdeModel.h"
#import "BBKnowledgeLibDetailVC.h"
@interface BBKnowledgeSecondLevelVC ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic,strong)UITableView *s_ListView;
@end

@implementation BBKnowledgeSecondLevelVC

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
    [MobClick event:@"knowledge_lib_v2" label:@"知识标题列表pv"];
    
    self.view.backgroundColor = RGBColor(239, 239, 244, 1);
    
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
    self.s_ListView.rowHeight = 69;
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 8)];
    [footer setBackgroundColor:[UIColor clearColor]];
    self.s_ListView.tableFooterView = footer;
    [self.view addSubview:self.s_ListView];

    // Do any additional setup after loading the view.
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
    BBKnowledgeSecondLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBKnowledgeSecondLevelCell"];
    if (cell == nil)
    {
        cell = [[BBKnowledgeSecondLevelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBKnowledgeSecondLevelCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BBKonwlegdeModel *model = [self.m_SourceArray objectAtIndex:indexPath.row];
    [cell setCellWithData:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_SourceArray count];
}


#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBKonwlegdeModel *model = [self.m_SourceArray objectAtIndex:indexPath.row];
    NSString *knowledgeID = model.ID;
    BBKnowledgeLibDetailVC * kld = [[BBKnowledgeLibDetailVC alloc]initWithID:knowledgeID];
    [self.navigationController pushViewController:kld animated:YES];
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
