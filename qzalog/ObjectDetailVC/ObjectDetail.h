//
//  ObjectDetail.h
//  qzalog
//
//  Created by Mus Bai on 27.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailImage.h"
#import "DetailInfo.h"

@interface ObjectDetail : NSObject

@property(nonatomic, assign )  NSInteger objectId;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *complex;
@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *dateCreated;
@property(nonatomic, retain) NSString *price;
@property(nonatomic, retain) NSString *discount;
@property(nonatomic, retain) NSArray<NSString *> *phones;

@property(nonatomic, retain) NSArray<DetailImage *> *images;
@property(nonatomic, retain) NSArray<DetailInfo *> *infoArray;

@property(nonatomic, retain) NSString *description;
@property(nonatomic, assign) float coordX;
@property(nonatomic, assign) float coordY;
@property(nonatomic, assign) NSInteger zoom;



@end
