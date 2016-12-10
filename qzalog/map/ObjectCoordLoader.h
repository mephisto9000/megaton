//
//  ObjectCoordLoader.h
//  qzalog
//
//  Created by Mus Bai on 29.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapCoordListener.h"
@interface ObjectCoordLoader : NSObject


/*
@property(nonatomic, assign) int zoom;
@property(nonatomic, assign) float map_coord_x;
@property(nonatomic, assign) float map_coord_y;
*/
-(void) loadData ; //: (NSString *) categoryId;
//-(void) loadDataForArray : (NSArray<NSString *> *) objIds;
-(void) loadDataFromUrl : (NSString *) mapUrl;
@property(nonatomic, retain) id<MapCoordListener> delegate;

@end
