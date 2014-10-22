//
//  BBKnowledgeSecondLevelCell.m
//  pregnancy
//
//  Created by liumiao on 4/24/14.
//  Copyright (c) 2014 babytree. All rights reserved.
//

#import "BBKnowledgeSecondLevelCell.h"
#import "BBKonwlegdeModel.h"
#import "UIImageView+WebCache.h"
@implementation BBKnowledgeSecondLevelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.m_BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 320, 60)];
        [self.contentView addSubview:self.m_BgView];
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
        
        self.m_RelatedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 16, 62, 44)];
        [self.m_RelatedImageView setContentMode:UIViewContentModeScaleAspectFill];
        self.m_RelatedImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.m_RelatedImageView];
        
        self.m_KnowledgeSpeciesLabel = [[UILabel alloc]initWithFrame:CGRectMake(82, 28, 230, 20)];
        [self.contentView addSubview:self.m_KnowledgeSpeciesLabel];
        [self.m_KnowledgeSpeciesLabel setFont:[UIFont systemFontOfSize:16.f]];
        [self.m_KnowledgeSpeciesLabel setTextColor:[UIColor colorWithRed:68/255.f green:68/255.f blue:68/255.f alpha:1.0f]];
        [self.m_KnowledgeSpeciesLabel setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68, 320, 1)];
        [self.contentView addSubview:line];
        [line setImage:[UIImage imageNamed:@"community_grey_line"]];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    //自定义删除按钮UI，只对收藏列表有效
    if (!self.m_IsForCollection)
    {
        return;
    }
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
            [self recurseAndReplaceSubViewIfDeleteConfirmationControl:self.subviews];
            [self performSelector:@selector(recurseAndReplaceSubViewIfDeleteConfirmationControl:) withObject:self.subviews afterDelay:0];
    }
}
-(void)recurseAndReplaceSubViewIfDeleteConfirmationControl:(NSArray*)subviews{
    for (UIView *subview in subviews)
    {
        //handles ios6 and earlier
        //        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
        //        {
        //            //we'll add a view to cover the default control as the image used has a transparent BG
        //            UIView *deleteView = (UIView *)[subview.subviews objectAtIndex:0];
        //            UIView *backgroundCoverDefaultControl = [[UIView alloc] initWithFrame:CGRectMake(0,0, deleteView.size.width, 33)];
        //            [backgroundCoverDefaultControl setBackgroundColor:[UIColor whiteColor]];//assuming your view has a white BG
        //            [[subview.subviews objectAtIndex:0] addSubview:backgroundCoverDefaultControl];
        //            UIImage *deleteImage = [UIImage imageNamed:delete_button_name];
        //            UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,deleteImage.size.width, deleteImage.size.height)];
        //            [deleteBtn setImage:[UIImage imageNamed:delete_button_name]];
        //            [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
        //        }
        //the rest handles ios7
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationButton"])
        {
            UIButton *deleteButton = (UIButton *)subview;
            deleteButton.top = 8;
            deleteButton.height = 60;
            //[deleteButton setImage:[UIImage imageNamed:delete_button_name] forState:UIControlStateNormal];
            //[deleteButton setTitle:@"取消收藏" forState:UIControlStateNormal];
//            for(UIView* view in subview.subviews){
//                if([view isKindOfClass:[UILabel class]]){
//                    [view removeFromSuperview];
//                }
//            }
        }
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
        {
            for(UIView* innerSubView in subview.subviews){
                if(![innerSubView isKindOfClass:[UIButton class]]){
                    [innerSubView removeFromSuperview];
                }
            }
        }
        if([subview.subviews count]>0){
            [self recurseAndReplaceSubViewIfDeleteConfirmationControl:subview.subviews];
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        [self.m_BgView setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        [self.m_BgView setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void)setCellWithData:(id)data
{
    BBKonwlegdeModel *model = (BBKonwlegdeModel*)data;
    self.m_KnowledgeSpeciesLabel.text = model.title;
    NSString *image = model.image;
    if (![image isNotEmpty])
    {
        NSString *imagesStr = model.imgArrStr;
        NSArray *imageArray ;
        if (imagesStr)
        {
            imageArray = [NSJSONSerialization JSONObjectWithData:[imagesStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }
        
        if ([imageArray isNotEmpty])
        {
            NSDictionary *imageDict = [imageArray firstObject];
            image = [imageDict stringForKey:@"small_src"];
        }
    }
    
    [self.m_RelatedImageView setImageWithURL:image?[NSURL URLWithString:image]:nil placeholderImage:[UIImage imageNamed:@"knowledgePicHolder"]];
}

@end
