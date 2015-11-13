//
//  DetailsViewController.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/12/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import "DetailsViewController.h"
#import "WebViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailsViewController ()
@property(nonatomic, weak) IBOutlet UIScrollView *detailScrollView;
@property(nonatomic, weak) IBOutlet UILabel *detailDesignerName;
@property(nonatomic, weak) IBOutlet UILabel *detailDressName;
@property(nonatomic, weak) IBOutlet UITextView *detailProductDetail;
@property(nonatomic, weak) IBOutlet UILabel *detailFitNotes;


@end

@implementation DetailsViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.detailScrollView setContentSize:]
}

// Wanted to create a more detailed page whenever the user selected a dress. I wanted more interactivity in the collection view and wanted to try out UIViewControllerAnimationTransitioning. Success!
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailDesignerName.text = _selectedItem.designerName;
    self.detailDressName.text = _selectedItem.displayName;
    self.detailProductDetail.text = _selectedItem.productDetail;
    self.detailFitNotes.text = _selectedItem.fitNotes;
    
    // Here we use the new provided sd_setImageWithURL: method to load the web image
//    [self.dressImageView1080x sd_setImageWithURL:[NSURL URLWithString:_selectedItem.dressimage1080x]
//                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]
//                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//                             }];
    [self loadHiResDressImage];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadHiResDressImage{
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:_selectedItem.dressimage183x]
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
                                                                             strongSelf.dressImageView1080x.image = image;
                                                                         });
                                                                     } else {
                                                                         NSLog(@"Couldn't load image at URL: %@", _selectedItem.dressimage183x);
                                                                         NSLog(@"HTTP %ld", (long)httpResponse.statusCode);
                                                                     }
                                                                 }
                                                             }];
    
    [task resume];
}

// Haven't played around with SFSafariViewController. It is a new subclass of UIViewController that was introduced in iOS 9.
// I thought it was the perfect opportunity to check it out. The legacyProductURL attribute really sparked the idea for me.
-(IBAction)ViewDressOnSite:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
       
        // Using new iOS 9 SFSafariViewController
        SFSafariViewController *svc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:_selectedItem.legacyProductURL] entersReaderIfAvailable:YES];
        svc.delegate = self;
        [self presentViewController:svc animated:YES completion:^{
            
        }];
                
    } else {
        // Older versions use UIWebView
        [self performSegueWithIdentifier:@"WebViewSegue" sender:sender];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"WebViewSegue"]) {
        WebViewController *webView = (WebViewController *)segue.destinationViewController;
        webView.legacyURL = _selectedItem.legacyProductURL;
    }
}

#pragma mark - SFSafariViewController
/*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*! @abstract Invoked when the initial URL load is complete.
 @param success YES if loading completed successfully, NO if loading failed.
 @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
 to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
 */
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
