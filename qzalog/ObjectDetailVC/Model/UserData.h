//
//  Region.h
//  qzalog
//
//  Created by Mus Bai on 30.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+(NSString *) regionId;
+(void) setRegionId:(NSString *) outRegionId;


+(NSString *) regionName;
+(void) setRegionName:(NSString *) outRegionName;


+(NSString *) categoryId;
+(void) setCategoryId:(NSString *) outCategoryId;


+(NSString *) categoryName;
+(void) setCategoryName : (NSString *) outCategoryName;


@end
