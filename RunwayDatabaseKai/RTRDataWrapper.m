//
//  RTRDataWrapper.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/9/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import "RTRDataWrapper.h"

static NSString * const RTRBaseURL = @"http://static.sqvr.co";
static NSString * const RTRDesignerEndpoint = @"designer-dresses.json";
static NSString * const RTRAccessoryEndpoint = @"designer-accesories.json";
static NSString * const RTRDressEndpoint = @"random-dresses.json";

NSString *const JR3ErrorDomain = @"JR3ErrorDomain";
NSInteger const JR3ErrorCode = -42;


@interface RTRDataWrapper ()
@property(nonatomic, copy, readwrite) NSURL *baseURL;
@property (nonatomic, copy) NSURLSession *rtrURLSession;
@end

@implementation RTRDataWrapper

+(RTRDataWrapper *)sharedDressManager{
    static RTRDataWrapper *sharedRTRAPIClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRTRAPIClient = [[self alloc] initWithRunwayURL:[NSURL URLWithString:RTRBaseURL]];
        sharedRTRAPIClient.rtrURLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:sharedRTRAPIClient delegateQueue:nil];
        [sharedRTRAPIClient.rtrURLSession.configuration setHTTPMaximumConnectionsPerHost:1];
        [sharedRTRAPIClient.rtrURLSession.configuration setRequestCachePolicy:NSURLRequestReloadIgnoringCacheData];

        sharedRTRAPIClient.rtrURLSession.sessionDescription = @"Let's get pretty dresses.";
    });
    return sharedRTRAPIClient;
}

- (id)init
{
    NSException *exception = [NSException exceptionWithName:@"Singleton" reason:@"Use +(RTRDataWrapper *)sharedDressManager instead" userInfo:nil];
    [exception raise];
    return nil;
}

-(instancetype)initWithRunwayURL:(NSURL *)url{
    if (self = [super init]) {
        self.baseURL = url;
    }
    return self;
}

/****
 
 * To be honest, I didn't how to go about it. My whole thought process on how the get the designers and accessories was how was I gonna able to get both of the endpoints' results and merge them efficiently. Using the NSMutableSet was the right call for me to grab a list of indices and add the objects of both results. Since adding Objects to the NSMutableSet is a O(1), I could add the objects all in one shot. In terms of calling the asynchronous request for both endpoints, I wasn't too sure to use dispatch_group to call request simultaneously and leave the group. But I figured to do a more, modern approach so I decided to create two Data Task using NSURLSession and call the first task then call the next task when the results from the first task get added to the NSMutableSet. It is done in a more, serial manner but it was simple and effiecient...with no strong references to each other.
****/

-(void)fetchmeDesignersAndAccessories:(RTRCompletionBlock)completionHandler{
    
    NSURL *fullURL =[self.baseURL URLByAppendingPathComponent:RTRDesignerEndpoint];
    NSMutableURLRequest *designerRequest = [NSMutableURLRequest requestWithURL:fullURL];
    designerRequest.HTTPMethod = @"GET";
    
    [designerRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [designerRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __block NSMutableSet* designerMutableSet = [NSMutableSet set];
    
    __block NSURLSessionDataTask *downloadDesignerTask = nil;
    __block NSURLSessionDataTask *secondTask = nil;
    
     downloadDesignerTask = [self.rtrURLSession dataTaskWithRequest:designerRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
        
        if(connectionError)
        {
            completionHandler(nil, connectionError);
        }
        else if(!data)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data was received from the server."};
            NSError *dataError = [NSError errorWithDomain:JR3ErrorDomain code:JR3ErrorCode userInfo:userInfo];
            completionHandler(nil, dataError);
        }
        else{
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            [designerMutableSet addObjectsFromArray:[results valueForKey:@"designer"]];
            [secondTask resume];
        }
    }];
    
     secondTask = [self.rtrURLSession dataTaskWithURL:[self.baseURL URLByAppendingPathComponent:RTRAccessoryEndpoint] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        [designerMutableSet addObjectsFromArray:[results valueForKey:@"designer"]];
        
        NSArray *sortedDesignerList =  [designerMutableSet.allObjects sortedArrayUsingComparator: ^(NSString* string1, NSString* string2)
                                        {
                                            return [string1 localizedCompare: string2];
                                        }];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             completionHandler(sortedDesignerList, error);
         });
        
    }];
    
    [downloadDesignerTask resume];
    
}
-(void)fetchmeDressesByDesigner:(NSString *)designerName completionBlock:(RTRCompletionBlock)completionHandler{
    
    NSMutableURLRequest *dressRequest = [NSMutableURLRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:RTRDressEndpoint]];
    dressRequest.HTTPMethod = @"GET";
    
    [dressRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [dressRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __block NSMutableArray *filtereddresses = [NSMutableArray new];
    
    NSURLSessionDataTask *downloadDressTask = [self.rtrURLSession dataTaskWithRequest:dressRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        if(connectionError)
        {
            completionHandler(nil, connectionError);
        }
        else if(!data)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data was received from the server."};
            NSError *dataError = [NSError errorWithDomain:JR3ErrorDomain code:JR3ErrorCode userInfo:userInfo];
            completionHandler(nil, dataError);
        }
        else{
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            
            NSArray* alldresses = [results valueForKey:@"products"];

            // Set a predicate for filtering.
            NSPredicate* designerFilterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"designer.name == '%@'", designerName]];
            
            // Filter the products based on the predicate
            NSArray* designerDresses = [alldresses filteredArrayUsingPredicate:designerFilterPredicate];
            
            for (NSDictionary *currentDress in designerDresses) {
                DesignerItem *currentDesigner = [[DesignerItem alloc]initWithDictionary:currentDress];
                [filtereddresses addObject:currentDesigner];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(filtereddresses, connectionError);
            });
        }
    }];
    
    [downloadDressTask resume];

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
