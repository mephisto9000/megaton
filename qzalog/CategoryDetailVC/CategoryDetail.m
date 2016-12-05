//
//  CategoryDetail.m
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategoryDetail.h"

@implementation CategoryDetail

@synthesize catDetId;
@synthesize title;
@synthesize image;
@synthesize region;
@synthesize price;
@synthesize discount;
@synthesize info;

@synthesize pos;


@synthesize intPrice;


-(NSString *) price
{
    return price;
}

-(void) setPrice:(NSString *)price1
{
    
    //self.price = [NSString new];
    price = price1;
    self.intPrice = 0;
    for (int i = 0; i < price1.length; i++)
    {
        char c = [price1 characterAtIndex:i];
                
        if (c >= '0' && c <= '9')
        {
            self.intPrice *= 10;
            self.intPrice += c - '0';//NSInteger charVa
        }
        
        
    }
}

@end
