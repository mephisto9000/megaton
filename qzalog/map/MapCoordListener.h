//
//  MapCoordListener.h
//  qzalog
//
//  Created by Mus Bai on 29.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectCoord.h"

@protocol MapCoordListener <NSObject>

-(void) mapLoadComplete: (NSArray<ObjectCoord *> *) coord map_zoom:(int) map_zoom map_coord_x: (float) map_coord_x map_coord_y: (float) map_coord_y;

@end
