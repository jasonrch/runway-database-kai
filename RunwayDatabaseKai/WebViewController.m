//
//  WebViewController.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/12/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//
#import <SVProgressHUD/SVProgressHUD.h>
#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_legacyURL]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ReturnToDress:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma - mark UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Loading URL :%@",request.URL.absoluteString);
    
    //return FALSE; //to stop loading
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{

}

@end
