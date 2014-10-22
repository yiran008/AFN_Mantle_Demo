//
//  BBSelectStyleCell.m
//  pregnancy
//
//  Created by babytree babytree on 12-4-11.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSelectStyleCell.h"

@implementation BBSelectStyleCell
@synthesize titleLabel;
@synthesize arrowImageView;

-(void)dealloc
{
    [titleLabel release];
    [arrowImageView release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 240, 20)]autorelease];
        [titleLabel setClearsContextBeforeDrawing:YES];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [titleLabel setAlpha:0.9];
        [titleLabel setNumberOfLines:1];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [self addSubview:titleLabel];
        
        self.arrowImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(304, 15,9,13.5)] autorelease];
        [arrowImageView setImage:[UIImage imageNamed:@"cell_arrow"]];
        [self addSubview:arrowImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
- (BBSelectStyleCell *)setCellTietle:(NSString *)title{
    if(title !=nil && title!=NULL){
        titleLabel.text = title;
    }else{
        titleLabel.text = @"";
    }
    return self;
}
@end
