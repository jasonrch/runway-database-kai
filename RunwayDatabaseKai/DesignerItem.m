//
//  DesignerItem.m
//  RunwayDatabaseKai
//
//  Created by Julio Reyes on 11/9/15.
//  Copyright © 2015 Julio Reyes. All rights reserved.
//

#import "DesignerItem.h"

@implementation DesignerItem

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self == nil) return nil;
    
    _designerName = [[dict valueForKeyPath:@"designer.name"]copy];
    _displayName = [[dict valueForKey:@"displayName"]copy];
    _productDetail = [[dict valueForKey:@"productDetail"]copy];
    _displayPriceString = [[dict valueForKey:@"displayPriceString"]copy];
    _displayPrice8DayString = [[dict valueForKey:@"displayPrice8DayString"]copy];
    _fitNotes = [[dict valueForKey:@"fitNotes"]copy];
    _legacyProductURL = [[dict valueForKey:@"legacyProductURL"]copy];

    _dressimage183x = [(NSArray *)[dict valueForKeyPath:@"imagesBySize.183x"]objectAtIndex:0];
    _dressimage1080x = [(NSArray *)[dict valueForKeyPath:@"imagesBySize.1080x"]objectAtIndex:0];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self == nil) return nil;
    
    _designerName = [coder decodeObjectForKey:@"designername"];
    _displayName = [coder decodeObjectForKey:@"displayName"];
    _productDetail = [coder decodeObjectForKey:@"productDetail"];
    _displayPriceString = [coder decodeObjectForKey:@"displayPriceString"];
    _displayPrice8DayString = [coder decodeObjectForKey:@"displayPrice8DayString"];
    _fitNotes = [coder decodeObjectForKey:@"fitNotes"];
    _legacyProductURL   = [coder decodeObjectForKey:@"legacyProductURL"];
    _dressimage183x = [coder decodeObjectForKey:@"dressimage183x"];
    _dressimage1080x = [coder decodeObjectForKey:@"dressimage1080x"];
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.designerName != nil) [coder decodeObjectForKey:@"designername"];
    if (self.displayName != nil) [coder decodeObjectForKey:@"displayName"];
    if (self.productDetail != nil) [coder decodeObjectForKey:@"productDetail"];
    if (self.displayPriceString != nil) [coder decodeObjectForKey:@"displayPriceString"];
    if (self.displayPrice8DayString != nil) [coder decodeObjectForKey:@"displayPrice8DayString"];
    if (self.fitNotes != nil) [coder decodeObjectForKey:@"fitNotes"];
    if (self.legacyProductURL != nil) [coder decodeObjectForKey:@"legacyProductURL"];

    if (self.dressimage183x != nil) [coder decodeObjectForKey:@"dressimage183x"];
    if (self.dressimage1080x != nil) [coder decodeObjectForKey:@"dressimage1080x"];
}

-(id)copyWithZone:(NSZone *)zone{
    DesignerItem *item = [[[self class] allocWithZone:zone]init];
    
    item -> _designerName = self.displayName;
    item -> _displayName = self.displayName;
    item -> _productDetail = self.productDetail;
    item -> _displayPriceString = self.displayPriceString;
    item -> _displayPrice8DayString = self.displayPrice8DayString;
    item -> _fitNotes = self.fitNotes;
    item -> _legacyProductURL = self.legacyProductURL;
    
    item -> _dressimage183x = self.dressimage183x;
    item -> _dressimage1080x = self.dressimage1080x;

    
    return item;
}
@end
