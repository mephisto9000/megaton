//
//  Region.m
//  qzalog
//
//  Created by Mus Bai on 30.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "UserData.h"

static NSString *regionId;
static NSString *regionName;

static NSString *categoryId;
static NSString *categoryName;

static NSString *dbName;

@implementation UserData


+(NSString *) dbName;
{
    return dbName;
}
+(void) setDbName : (NSString *) outDbName
{
    dbName = outDbName;
}


+(NSString *) regionId
{
    return regionId;
}

+(void) setRegionId:(NSString *)outRegionId
{
    regionId = outRegionId;
}


+(NSString *) regionName
{
    return regionName;
}

+(void) setRegionName:(NSString *) outRegionName
{
    regionName = outRegionName;
}



+(NSString *) categoryName
{
    return categoryName;
}

+(void) setCategoryName:(NSString *) outCategoryName
{
    categoryName = outCategoryName;
}


+(NSString *) categoryId
{
    return categoryId;
}

+(void ) setCategoryId:(NSString *) outCategoryId
{
    categoryId = outCategoryId;
}


@end
