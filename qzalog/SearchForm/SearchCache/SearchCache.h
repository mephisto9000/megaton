//
//  SearchCache.h
//  qzalog
//
//  Created by Mus Bai on 10.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchObject.h"

@interface SearchCache : NSObject

@property(nonatomic, retain) NSString *categoryId;
@property(nonatomic, retain) NSArray<SearchObject *> *searchObjects;

+ (id)searchCache;

@end
