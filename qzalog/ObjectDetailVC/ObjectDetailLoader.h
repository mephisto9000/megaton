//
//  ObjectDetailReader.h
//  qzalog
//
//  Created by Mus Bai on 27.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectDetailListener.h"

@interface ObjectDetailLoader : NSObject

@property(nonatomic, retain) id<ObjectDetailListener> delegate;

-(void) loadData: (NSString *) objectId;


@end
