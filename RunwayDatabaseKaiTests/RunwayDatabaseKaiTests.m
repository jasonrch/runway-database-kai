//
//  RunwayDatabaseKaiTests.m
//  RunwayDatabaseKaiTests
//
//  Created by Julio Reyes on 11/9/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RTRDataWrapper.h"
#import "DesignerItem.h"

@interface RunwayDatabaseKaiTests : XCTestCase

@end
static const NSString* jsonStr;

@implementation RunwayDatabaseKaiTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDesignerItemClass {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    // Check to see if the DesignerItem class took in junk
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"Audigier" forKey:@"designerName"];
    [dict setValue:@"Julio Reyes il sviluppatore iOS" forKey:@"displayName"];
    [dict setValue:@"Just me wearing a pretty-witty dress." forKey:@"productDetail"];
    [dict setValue:@"$350" forKey:@"displayPriceString"];
    [dict setValue:@"$350" forKey:@"displayPrice8DayString"];
    [dict setValue:@"NOtaURL" forKey:@"dressimage183x"];
    [dict setValue:@"StillNOtAURL" forKey:@"dressimage1080x"];
    
    DesignerItem *item = [[DesignerItem alloc]initWithDictionary:dict];
    XCTAssertFalse(item == [DesignerItem class]);
    
}
- (void)testfetchmeDesignersAndAccessories{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertNoThrow([[RTRDataWrapper sharedDressManager]fetchmeDesignersAndAccessories:^(NSArray *designerArray, NSError *error) {
        printf("Runs.");
        
        
        // Check for dupes. Note: given how NSSet works, This is redundant.
        NSCountedSet *cs = [[NSCountedSet alloc] initWithArray:designerArray];
        NSLog(@"object count greater than 1 are");
        for(id designer in cs){
            XCTAssertFalse([cs countForObject:designer] > 1);
        }
        
        // Check to see if the list of designers was properly populated and no error resulted from this.
        XCTAssertTrue(designerArray.count > 0 && error == nil);
        
    }]);
}

- (void)testfetchmeDressesbyDesigner{
    [[RTRDataWrapper sharedDressManager]fetchmeDressesByDesigner:@"Marina Rinaldi" completionBlock:^(NSArray *designerArray, NSError *error) {
        // Check to see if the results have been populated and documented onto the proper class
        XCTAssertTrue(designerArray[0] == [DesignerItem class]);
        XCTAssertTrue(designerArray.count > 0 && error == nil);
    }];
    
    // This test should fail. Clearly, i'm not a designer.
    [[RTRDataWrapper sharedDressManager]fetchmeDressesByDesigner:@"Julio Reyes III" completionBlock:^(NSArray *designerArray, NSError *error) {
        XCTAssertFalse(designerArray.count > 0);
    }];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
