//
//  BBSelectHospitalAreaCell.m
//  pregnancy
//
//  Created by babytree babytree on 12-10-23.
//  Copyright (c) 2012年 babytree. All rights reserved.
//

#import "BBSelectHospitalAreaCell.h"

@implementation BBSelectHospitalAreaCell

@synthesize text;
@synthesize rightImage;
- (void)dealloc
{
    [text release];
    [rightImage release];
    
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
