//
//  RTRCollectionViewCell.h
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/9/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerItem.h"

@class DesignerItem;
@interface RTRCollectionViewCell : UICollectionViewCell 
@property (nonatomic, weak) IBOutlet UIImageView *dressImageView;
@property (nonatomic, weak) IBOutlet UILabel *dressRentPrice;
@property (nonatomic, weak) IBOutlet UILabel *dressRent8DayPrice;

-(void)setUpWithDesignerItem:(DesignerItem *)item;

@end
