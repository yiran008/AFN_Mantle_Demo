//
//  BBMainPageToolsCell.m
//  pregnancy
//
//  Created by liumiao on 5/12/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBMainPageToolsCell.h"
#import "BBBadgeButton.h"
#import "BBToolOpreation.h"
#define TOOL_VER_MARGIN 12
#define TOOL_SIDE_LENGTH 56
#define TOOL_NAME_LABEL_HEIGHT 10
#define TOOL_IMG_LABEL_MARGIN 6

@implementation BBMainPageToolsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 11, 320, 1)];
        [line1 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line1];
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 109, 320, 1)];
        [line2 setImage:[UIImage imageNamed:@"mainPageSepLine"]];
        [self.contentView addSubview:line2];
        self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, 320, 97)];
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.m_BgView];
        [self.contentView setBackgroundColor:RGBColor(239, 239, 244, 1)];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellUseData:(id)data
{
    NSArray *toolArray = (NSArray*)data;
    [self clearActionButton];
    [self resetActionButton:toolArray];
}
-(void)clearActionButton
{
    for (UIView *view in self.m_BgView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(void)resetActionButton:(NSArray *)toolArray
{
    int size = [toolArray count]>4 ? 4:[toolArray count];
    int TOOL_PAGE_SIDE_MARGIN = (DEVICE_WIDTH-size*TOOL_SIDE_LENGTH)/(size*2);
    int TOOL_HOR_MARGIN = TOOL_PAGE_SIDE_MARGIN*2;
    for (int i=0; i<size; i++) {
        BBToolModel *model = [toolArray objectAtIndex:i];
        int rowTemp = i%size;
        BBBadgeButton *addActionButton = [[BBBadgeButton alloc]initWithFrame:CGRectMake(TOOL_PAGE_SIDE_MARGIN+rowTemp*(TOOL_SIDE_LENGTH+TOOL_HOR_MARGIN), TOOL_VER_MARGIN, TOOL_SIDE_LENGTH, TOOL_SIDE_LENGTH)];
        addActionButton.tag = 1310+i;
        addActionButton.exclusiveTouch = YES;
        //[NSURL URLWithString:[[self.s_ToolsArray objectAtIndex:i]stringForKey:@"img"]]
        [addActionButton setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:model.holderImg?[UIImage imageNamed:model.holderImg]:nil];
        [addActionButton setImage:nil forState:UIControlStateHighlighted];
        [addActionButton addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
        //[addActionButton setFrame:CGRectMake(11+rowTemp*103, 130*lineTemp+TOP_BANNER_VIEW_HEIGHT+10, 92, 92)];
        [addActionButton setTipNumber:model.badgeCount];
        UILabel *toolNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(TOOL_PAGE_SIDE_MARGIN+rowTemp*(TOOL_SIDE_LENGTH+TOOL_HOR_MARGIN), TOOL_VER_MARGIN+TOOL_SIDE_LENGTH+TOOL_IMG_LABEL_MARGIN, TOOL_SIDE_LENGTH, TOOL_NAME_LABEL_HEIGHT)];
        [toolNameLabel setFont:[UIFont systemFontOfSize:10]];
        [toolNameLabel setTextColor:[UIColor colorWithHex:0x5a5a5a]];
        [toolNameLabel setBackgroundColor:[UIColor clearColor]];
        [toolNameLabel setText:model.name];
        [toolNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.m_BgView addSubview:addActionButton];
        [self.m_BgView addSubview:toolNameLabel];
    }
}

-(void)downloadImageForData:(id)data
{
    NSArray *toolArray = (NSArray*)data;
    int size = [toolArray count]>4 ? 4:[toolArray count];
    for (int i=0; i<size; i++)
    {
        BBToolModel *model = [toolArray objectAtIndex:i];

        BBBadgeButton *addActionButton = (BBBadgeButton*)[self.m_BgView viewWithTag:1310+i];
        [addActionButton setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:model.holderImg?[UIImage imageNamed:model.holderImg]:nil];
    }
}

-(void)toolAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int index = button.tag - 1310;
    if (self.m_ToolBlock)
    {
        self.m_ToolBlock(index);
    }
}
@end
