//
//  HMSearchHistoryCell.m
//  lama
//
//  Created by songxf on 14-1-3.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "HMSearchHistoryCell.h"

@implementation HMSearchHistoryCell
@synthesize contentLabel,deleteButton;

-(void)dealloc
{
    [contentLabel release];
    [deleteButton release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(16, 0, 264, SEARCH_HISTORY_CELL_HEIGHT)] autorelease];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:contentLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(280, 5, 40, 30);
        [self.deleteButton setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteHistory:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteButton];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(NSString *)str isRubbish:(BOOL)rubbish
{
    if (rubbish)
    {
        self.contentLabel.text = @"  清除搜索记录";
        contentLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
        contentLabel.textAlignment = NSTextAlignmentCenter;
//        [self.deleteButton removeFromSuperview];
        [self.deleteButton setImage:nil forState:UIControlStateNormal];
        self.deleteButton.userInteractionEnabled = NO;
    }
    else
    {
        self.contentLabel.text = str;
        contentLabel.textColor = [UIColor colorWithHex:0x666666];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.left = 16;
        [self.deleteButton setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
    }
}

- (IBAction)deleteHistory:(id)sender
{
    NSInteger index = ((UIButton*)sender).tag;
    [self.delegate deleteHistory:index];
}
@end
