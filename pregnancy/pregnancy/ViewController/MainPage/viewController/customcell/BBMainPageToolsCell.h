//
//  BBMainPageToolsCell.h
//  pregnancy
//
//  Created by liumiao on 5/12/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMainPageToolsCell : UITableViewCell
typedef void (^ToolBlock)(int);

@property (nonatomic,strong)UIView *m_BgView;
@property (nonatomic,copy) ToolBlock m_ToolBlock;

-(void)setCellUseData:(id)data;
-(void)downloadImageForData:(id)data;
@end
