//
//  LoadListener.h
//  qzalog
//
//  Created by Mus Bai on 22.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadListener <NSObject>

-(void) loadComplete :(NSArray *) data;

@end
