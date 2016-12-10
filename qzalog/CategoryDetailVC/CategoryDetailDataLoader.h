//
//  CategoryDetailDataLoader.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryDetail.h"
#import "CategoryDetailListener.h"

@interface CategoryDetailDataLoader : NSObject

@property(nonatomic, retain) NSArray<CategoryDetail *> *catDetailData;
@property(nonatomic, retain) NSObject<CategoryDetailListener> *delegate;


@property(nonatomic, retain) NSString *categoryId;
@property(nonatomic, retain) NSString *searchUrl;

-(NSString *) loadCategoryDetailData;
-(void) loadFavorite;
-(void) loadFromMap: (NSArray<NSString *>  *) objIds;

-(void) setPriceDesc;
-(void) setPriceAsc;

-(void) setDateDesc;

@end
