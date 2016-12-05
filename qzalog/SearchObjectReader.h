//
//  SearchObjectReader.h
//  qzalog
//
//  Created by Mus Bai on 21.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchObject.h"
#import "LoadListener.h"

@interface SearchObjectReader : NSObject

@property(nonatomic, retain) NSMutableArray<SearchObject *>  *searchObjects;
@property(nonatomic, weak) id<LoadListener> delegate;


-(void) loadData: (int) category_id;

@end
