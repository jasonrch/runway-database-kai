//
//  WebViewController.h
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/12/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property(nonatomic, copy) NSString *legacyURL;

@end
