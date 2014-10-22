//
//  BBCustomPickerView1.m
//  pregnancy
//
//  Created by yxy on 14-4-9.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import "BBCustomPickerView.h"

@implementation BBCustomPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickerView];
    }
    return self;
}


#pragma mark UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.numberOfComponent;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [self.firstColumnArray count];
    }
    else
    {
        return [self.secondColumnArray count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        if([self.firstColumnArray isNotEmpty])
        {
            return [self.firstColumnArray objectAtIndex:row];
        }
        else
        {
            return @"";
        }
    }
    else
    {
        if([self.secondColumnArray isNotEmpty])
        {
            return [self.secondColumnArray objectAtIndex:row];
        }
        else
        {
            return @"";
        }
    }
}

// 选择发生改变
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *result;
    if(component == 0)
    {
        result = [self.firstColumnArray objectAtIndex:row];
    }
    else
    {
        result = [self.secondColumnArray objectAtIndex:row];
    }
    
    [self.delegate BBCustomPickerView:self withChecked:result inComponent:component];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.pickerView selectRow:row inComponent:component animated:NO];
}

@end
