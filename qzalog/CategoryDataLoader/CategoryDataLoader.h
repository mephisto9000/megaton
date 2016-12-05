//
//  CategoryDataLoader.h
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryListener.h"

@interface CategoryDataLoader : NSObject

@property(nonatomic, retain) NSMutableDictionary *catData;
@property(nonatomic, retain) NSObject<CategoryListener> *delegate;

-(void) loadCategoryData;

@end
