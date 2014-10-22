//
//  DDPageControl.h
//  DDPageControl
//
//  Created by Damien DeVille on 1/14/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIControl.h>
#import <UIKit/UIKitDefines.h>

typedef enum
{
	DDPageControlTypeOnFullOffFull		= 0,
	DDPageControlTypeOnFullOffEmpty		= 1,
	DDPageControlTypeOnEmptyOffFull		= 2,
	DDPageControlTypeOnEmptyOffEmpty	= 3,
}
DDPageControlType ;


@interface DDPageControl : UIControl 
{
	NSInteger numberOfPages ;
	NSInteger currentPage ;
}

@property(nonatomic) NSInteger numberOfPages ;
@property(nonatomic) NSInteger currentPage ;

@property(nonatomic) BOOL hidesForSinglePage ;

@property(nonatomic) BOOL defersCurrentPageDisplay ;
- (void)updateCurrentPageDisplay ;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount ;

- (id)initWithType:(DDPageControlType)theType ;

@property (nonatomic) DDPageControlType type ;

@property (nonatomic,retain) UIColor *onColor ;
@property (nonatomic,retain) UIColor *offColor ;

@property (nonatomic) CGFloat indicatorDiameter ;
@property (nonatomic) CGFloat indicatorSpace ;

@end

