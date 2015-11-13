//
//  DressDetailsVCAnimatedTransitioning.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/12/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import "DressDetailsVCAnimatedTransitioning.h"

#import "ViewController.h"
#import "DetailsViewController.h"
#import "RTRCollectionViewCell.h"

@implementation DressDetailsVCAnimatedTransitioning

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    // Gain access to both view controllers
    ViewController *fromViewController = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DetailsViewController *toViewController = (DetailsViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Gives the containing view of both view controllers
    UIView *containerView = [transitionContext containerView];
    
    // Grab snapshot of cell image
    RTRCollectionViewCell *cell = (RTRCollectionViewCell *) [fromViewController.dressCollectionView cellForItemAtIndexPath:[[fromViewController.dressCollectionView indexPathsForSelectedItems]firstObject]];
    UIView *imageSnapshot = [cell.dressImageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:cell.dressImageView.frame fromView:cell.dressImageView.superview];
    cell.dressImageView.hidden = YES;
    
    // Setup the initial view states, positioning it in it's final position but making it transparent.
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.dressImageView1080x.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:imageSnapshot];
    
    // Execute Transition animation, moving the image snapshot. In the completion block of the animation, it removes temporary snapshot view and restores the visibility of the views we hid.
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        toViewController.view.alpha = 1.0;
        
        // Move the cell snapshot so it's over the second view controller's image view
        CGRect frame = [containerView convertRect:toViewController.dressImageView1080x.frame fromView:toViewController.view];
        imageSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        // Clean up
        toViewController.dressImageView1080x.hidden = NO;
        cell.hidden = NO;
        [imageSnapshot removeFromSuperview];
        
        // This method declares that we are finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        // Reset the cell from the hidden status
        cell.dressImageView.hidden = NO;
    }];
    
}

// This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
- (void)animationEnded:(BOOL) transitionCompleted{
    
}

@end
