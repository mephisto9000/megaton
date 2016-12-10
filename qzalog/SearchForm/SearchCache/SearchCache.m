//
//  SearchCache.m
//  qzalog
//
//  Created by Mus Bai on 10.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SearchCache.h"

@implementation SearchCache

@synthesize categoryId;
@synthesize searchObjects;

+ (id)searchCache
{
    static SearchCache *searchCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        searchCache = [[self alloc] init];
    });
    return searchCache;
}


- (id)init {
    if (self = [super init]) {
        categoryId = @"-1";
    }
    return self;
}



@end
