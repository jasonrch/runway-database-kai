//
//  DesignerItem.h
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/9/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignerItem : NSObject <NSCoding, NSCopying>
@property (nonatomic, copy, readwrite) NSString *designerName;
@property (nonatomic, copy, readwrite) NSString *displayName;
@property (nonatomic, copy, readwrite) NSString *productDetail;
@property (nonatomic, copy, readwrite) NSString *fitNotes;
@property (nonatomic, copy, readwrite) NSString *displayPriceString;
@property (nonatomic, copy, readwrite) NSString *displayPrice8DayString;

@property (nonatomic, copy, readonly) NSString* dressimage183x;
@property (nonatomic, copy, readonly) NSString* dressimage1080x;

@property (nonatomic, copy, readwrite) NSString *legacyProductURL;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
