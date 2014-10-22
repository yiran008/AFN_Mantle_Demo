//
//  BBCustemSegment.m
//  PPiFlatSegmentedControl-Demo
//
//  Created by whl on 14-4-11.
//  Copyright (c) 2014年 PPinera. All rights reserved.
//

#import "BBCustemSegment.h"

#define segment_corner 3.0

@interface BBCustemSegment()
@property (nonatomic,strong) NSMutableArray *segments;
@property (nonatomic) NSUInteger currentSelected;
@property (nonatomic,strong) NSMutableArray *separators;
@property (nonatomic,copy) selectionBlock selBlock;

@property (nonatomic, strong) NSMutableArray *eachListNoDataStatusInfoArray;

@end


@implementation BBCustemSegment
/**
 *	Method for initialize PPiFlatSegmentedControl
 *
 *	@param	frame	CGRect for segmented frame
 *	@param	items	List of NSString items for each segment
 *	@param	block	Block called when the user has selected another segment
 *
 *	@return	Instantiation of PPiFlatSegmentedControl
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray*)items andSelectionBlock:(selectionBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.eachListNoDataStatusInfoArray = [[NSMutableArray alloc]initWithCapacity:0];
        //Selection block
        _selBlock=block;
        
        //Background Color
        self.backgroundColor=[UIColor clearColor];
        
        //Generating segments
        float buttonWith=frame.size.width/items.count;
        int i=0;
        for(NSDictionary *item in items){
            NSString *text=item[@"text"];
            
            UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(buttonWith*i, 0, buttonWith, frame.size.height)];
            [button setTitle:text forState:UIControlStateNormal];
            [button setTitle:text forState:UIControlStateHighlighted];
            button.exclusiveTouch = YES;
            
            [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            //Adding to self view
            [self.segments addObject:button];
            [self addSubview:button];
            
            //Adding separator
            if(i!=0){
                UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(i*buttonWith, 0, self.borderWidth, frame.size.height)];
                [self addSubview:separatorView];
                [self.separators addObject:separatorView];
            }
            
            NSMutableDictionary *statusItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: HMNODATAVIEW_CUSTOM ],@"noDataViewType",[NSNumber numberWithBool:YES],@"noDataViewHidden", @"",@"noDataViewText", nil];
            [self.eachListNoDataStatusInfoArray addObject:statusItem];
            
            i++;
        }
        
        //Applying corners
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=segment_corner;
        
        //Default selected 0
        _currentSelected=0;
        
    }
    return self;
}
#pragma mark - Lazy instantiations
-(NSMutableArray*)segments{
    if(!_segments)_segments=[[NSMutableArray alloc] init];
    return _segments;
}
-(NSMutableArray*)separators{
    if(!_separators)_separators=[[NSMutableArray alloc] init];
    return _separators;
}
#pragma mark - Actions
-(void)segmentSelected:(id)sender{
    if(sender){
        NSUInteger selectedIndex=[self.segments indexOfObject:sender];
        [self setEnabled:YES forSegmentAtIndex:selectedIndex];
        
        //Calling block
        if(self.selBlock){
            self.selBlock(selectedIndex);
        }
    }
}
#pragma mark - Getters
/**
 *	Returns if a specified segment is selected
 *
 *	@param	index	Index of segment to check
 *
 *	@return	BOOL selected
 */
-(BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index{
    return (index==self.currentSelected);
}

#pragma mark - Setters
-(void)updateSegmentsFormat{
    //Setting border color
    if(self.borderColor){
        self.layer.borderWidth=self.borderWidth;
        self.layer.borderColor=self.borderColor.CGColor;
    }else{
        self.layer.borderWidth=0;
    }
    
    //Updating segments color
    for(UIView *separator in self.separators){
        separator.backgroundColor=self.borderColor;
        separator.frame=CGRectMake(separator.frame.origin.x, separator.frame.origin.y,self.borderWidth , separator.frame.size.height);
    }
    
    //Modifying buttons with current State
    for (UIButton *segment in self.segments){
        
        //Setting format depending on if it's selected or not
        if([self.segments indexOfObject:segment]==self.currentSelected){
            //Selected-one
            if(self.selectedColor) [segment setBackgroundColor:self.selectedColor];
            if (self.selectedTextAttributes)
            {
                [segment.titleLabel setFont:[self.selectedTextAttributes objectForKey:NSFontAttributeName]];
                [segment setTitleColor:[self.selectedTextAttributes objectForKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
            }
            
        }else{
            //Non selected
            if(self.color)[segment setBackgroundColor:self.color];
            if (self.textAttributes)
            {
                [segment.titleLabel setFont:[self.textAttributes objectForKey:NSFontAttributeName]];
                [segment setTitleColor:[self.textAttributes objectForKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
            }
            segment.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
}
-(void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor=selectedColor;
    [self updateSegmentsFormat];
}
-(void)setColor:(UIColor *)color{
    _color=color;
    [self updateSegmentsFormat];
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth=borderWidth;
    [self updateSegmentsFormat];
}
/**
 *	Using this method name of a specified segmend can be changed
 *
 *	@param	title	Title to be applied to the segment
 *	@param	index	Index of the segment that has to be modified
 */

-(void)setTitle:(id)title forSegmentAtIndex:(NSUInteger)index{
    //Getting the Segment
    if(index<self.segments.count){
        UIButton *segment=self.segments[index];
        if([title isKindOfClass:[NSString class]]){
            [segment setTitle:title forState:UIControlStateNormal];
        }else if ([title isKindOfClass:[NSAttributedString class]]){
            [segment setTitle:title forState:UIControlStateNormal];
        }
    }
}
-(void)setBorderColor:(UIColor *)borderColor{
    //Setting boerder color to all view
    _borderColor=borderColor;
    [self updateSegmentsFormat];
}
/**
 *	Method for select/unselect a segment
 *
 *	@param	enabled	BOOL if the given segment has to be enabled/disabled ( currently disable option is not enabled )
 *	@param	segment	Segment to be selected/unselected
 */
-(void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment{
    if(enabled){
        self.currentSelected=segment;
        [self updateSegmentsFormat];
    }
}
-(void)setTextAttributes:(NSDictionary *)textAttributes{
    _textAttributes=textAttributes;
    [self updateSegmentsFormat];
}
-(void)setSelectedTextAttributes:(NSDictionary *)selectedTextAttributes{
    _selectedTextAttributes=selectedTextAttributes;
    [self updateSegmentsFormat];
}

#pragma mark -
#pragma mark noDataStatusInfo functions

-(void)setNoDataViewStatusInfoWithArrayIndex:(NSUInteger)theIndex withHidden:(BOOL)theHidden
{
    [self setNoDataViewStatusInfoWithArrayIndex:theIndex withNoDataType:HMNODATAVIEW_CUSTOM withHidden:theHidden];
}

-(void)setNoDataViewStatusInfoWithArrayIndex:(NSUInteger)theIndex withNoDataType:(HMNODATAVIEW_TYPE)theNoDataType withHidden:(BOOL)theHidden
{
    [self setNoDataViewStatusInfoWithArrayIndex:theIndex withNoDataType:theNoDataType withHidden:theHidden withText:@""];
}

-(void)setNoDataViewStatusInfoWithArrayIndex:(NSUInteger)theIndex withNoDataType:(HMNODATAVIEW_TYPE)theNoDataType withHidden:(BOOL)theHidden withText:(NSString *)theText
{
    if ([self.eachListNoDataStatusInfoArray isNotEmpty]  && theIndex < self.eachListNoDataStatusInfoArray.count)
    {
        if ([self.eachListNoDataStatusInfoArray[theIndex] isDictionaryAndNotEmpty])
        {
            [self.eachListNoDataStatusInfoArray[theIndex] setObject:[NSNumber numberWithInt:theNoDataType] forKey:@"noDataViewType"];
            
            [self.eachListNoDataStatusInfoArray[theIndex] setObject:[NSNumber numberWithInt:theHidden] forKey:@"noDataViewHidden"];
            
            [self.eachListNoDataStatusInfoArray[theIndex] setObject:theText forKey:@"noDataViewText"];
        }
    }
}

-(NSDictionary *)getNoDataStatusWithIndex:(NSUInteger)theIndex
{
    if ([self.eachListNoDataStatusInfoArray isNotEmpty]  && theIndex < self.eachListNoDataStatusInfoArray.count)
    {
        return self.eachListNoDataStatusInfoArray[theIndex];
    }
    else
    {
        return nil;
    }
}

@end
