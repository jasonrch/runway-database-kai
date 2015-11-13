//
//  ViewController.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/10/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//
#import "RTRDataWrapper.h"

#import "RTRCollectionViewCell.h"

#import "ViewController.h"
#import "DetailsViewController.h"

#import "DressDetailsVCAnimatedTransitioning.h"
@interface ViewController ()
@end

@implementation ViewController

static NSString * const reuseIdentifier = @"DressCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//
    
    __weak typeof(self) weakSelf = self;
    
    [[RTRDataWrapper sharedDressManager]fetchmeDressesByDesigner:weakSelf.designerName completionBlock:^(NSArray *designerArray, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(!error){
            strongSelf.dresses = designerArray;
            [strongSelf.dressCollectionView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set navigation controller's delegate so we can use the transitioning function below
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop Nav Controller delegation
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark - UICollectionView Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dresses.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RTRCollectionViewCell *dresscell = [collectionView
                                      dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                      forIndexPath:indexPath];
    [dresscell prepareForReuse];

    DesignerItem *currentDesignerItem = self.dresses[indexPath.row];

    if (!dresscell) {
        dresscell = [[RTRCollectionViewCell alloc]init];
    }
    
    // Having the set up for the cell within the custom cell task create much cleaner code.
    [dresscell setUpWithDesignerItem:currentDesignerItem];

    return dresscell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"DetailSegue"]){
        NSIndexPath *indexPath = [[self.dressCollectionView indexPathsForSelectedItems]firstObject];
        DetailsViewController *detailsVC = (DetailsViewController *)segue.destinationViewController;
        detailsVC.selectedItem = [self.dresses objectAtIndex:indexPath.row];
    }
}

#pragma mark - UIViewTransitionAnimation Delegate
// A new frontier for me. I believe that one of the best ways to create a stellar app is to create a kind of show. So
// I made this Transition animation to really spice up the app.
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    // Check if we're transitioning from this view controller to the details View controller.
    if (fromVC == self && [toVC isKindOfClass:[DetailsViewController  class]]) {
        return [[DressDetailsVCAnimatedTransitioning alloc] init];
    }
    else {
        return nil;
    }
}

@end
