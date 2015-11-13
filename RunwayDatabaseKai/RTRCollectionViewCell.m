//
//  RTRCollectionViewCell.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/9/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import "RTRCollectionViewCell.h"

@interface RTRCollectionViewCell  (){
    NSURLSession * session;
}

@end

@implementation RTRCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.dressImageView.image = nil;
    self.dressRentPrice.text = nil;
    self.dressRent8DayPrice.text = nil;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    // Apply image masking in the cell
    self.layer.cornerRadius = 75;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor colorWithRed:32.0/255.0 green:175.0/255.0 blue:190.0/255.0 alpha:0.9].CGColor;
    self.layer.masksToBounds = YES;
    
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 5.0f;
    self.layer.shadowOffset = CGSizeMake(5, 5);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:75].CGPath;
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.sublayerTransform = CATransform3DIdentity;
    
    self.layer.shouldRasterize = YES;
}

-(void)setUpWithDesignerItem:(DesignerItem *)item{
    
    __weak RTRCollectionViewCell *weakSelf = self;
    
    weakSelf.dressRentPrice.text = item.displayPriceString;
    weakSelf.dressRent8DayPrice.text = [NSString stringWithFormat:@"8Day: %@", item.displayPrice8DayString];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    session = [NSURLSession sessionWithConfiguration:config];
    
    __block NSURLSessionDataTask *task = nil;
    
    if (task) {
        [task cancel];
    }
    
    if (item.dressimage183x) {
        __weak typeof(self) weakSelf = self;
        task = [session dataTaskWithURL:[NSURL URLWithString:item.dressimage183x]
                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                   __strong __typeof(weakSelf) strongSelf = weakSelf;
                                   if (error) {
                                       NSLog(@"ERROR: %@", error);
                                   }
                                   else {
                                       NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
                                       if (200 == httpResponse.statusCode) {
                                           UIImage * image = [UIImage imageWithData:data];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               strongSelf.dressImageView.image = image;
                                               strongSelf.dressImageView.hidden = NO;
                                           });
                                       } else {
                                           NSLog(@"Couldn't load image at URL: %@", item.dressimage183x);
                                           NSLog(@"HTTP %ld", (long)httpResponse.statusCode);
                                       }
                                   }
                               }];
        [task resume];
    }
    return;

}

@end
