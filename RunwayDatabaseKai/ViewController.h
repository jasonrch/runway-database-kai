//
//  ViewController.h
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/10/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerItem.h"

@class DesignerItem;
@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView *dressCollectionView;
@property(nonatomic, strong) NSArray *dresses;

@property(nonatomic, copy) NSString *designerName;

@end

