//
//  CategoryDetail.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryDetail : NSObject

@property(nonatomic, assign) int pos;
@property(nonatomic, retain) NSString *catDetId;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *image;
@property(nonatomic, retain) NSString *region;
@property(nonatomic, setter = setPrice:) NSString *price;

@property(nonatomic, assign) int intPrice;


@property(nonatomic, retain) NSString  *discount;
@property(nonatomic, retain) NSString *info;


@end
