//
//  BBTaxiPartnerView.m
//  pregnancy
//
//  Created by whl on 13-12-11.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBTaxiPartnerView.h"

@implementation BBTaxiPartnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withDiction:(NSArray*)partnerArray withPartnerTitle:(NSString*)partnerTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(MAXFLOAT, 20.0) withFont:[UIFont systemFontOfSize:14.0] withString:partnerTitle];
        UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(12, 18, size.width, frame.size.height)]autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [titleLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [titleLabel setText:partnerTitle];
        [self addSubview:titleLabel];
        UIScrollView *scroll = [[[UIScrollView alloc]initWithFrame:CGRectMake(12+size.width, 9, 200, frame.size.height)]autorelease];
        scroll.backgroundColor = [UIColor clearColor];
        self.patrnerCount = 0;
        if ([partnerArray count] > 0) {
            for (int i = 0; i<[partnerArray count]; i++) {
                if (![[[partnerArray objectAtIndex:i] stringForKey:@"on_off"] isEqualToString:@"off"]) {
                    UIImageView *partnerImage = [[[UIImageView alloc]initWithFrame:CGRectMake( 5*(self.patrnerCount+1)+20*self.patrnerCount, 18, 20, 20)]autorelease];
                    [partnerImage.layer setMasksToBounds:YES];
                    partnerImage.layer.cornerRadius = 3.0;
                    NSURL *url = [NSURL URLWithString:[[partnerArray objectAtIndex:i]stringForKey:@"partner_url"]];
                    [partnerImage setImageWithURL:url placeholderImage:nil];
                    [scroll addSubview:partnerImage];
                    self.patrnerCount++;
                }
            }
        }
        if (25 * [partnerArray count] > 200) {
            [scroll setContentSize:CGSizeMake(25 * [partnerArray count], frame.size.height)];
        }else{
            [scroll setContentSize:CGSizeMake(200, frame.size.height)];
        }
        scroll.showsHorizontalScrollIndicator=YES;
        scroll.showsVerticalScrollIndicator=NO;
        [scroll setUserInteractionEnabled:YES];
        [self addSubview:scroll];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
