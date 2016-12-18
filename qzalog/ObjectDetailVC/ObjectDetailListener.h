//
//  OblectDetailListener.h
//  qzalog
//
//  Created by Mus Bai on 27.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectDetail.h"

@protocol ObjectDetailListener <NSObject>

-(void) loadObjectDetailComplete : (ObjectDetail *) objectDetail;
-(void) loadObjectDetailFailed;

@end
