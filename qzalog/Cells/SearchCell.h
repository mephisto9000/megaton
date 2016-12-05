//
//  SearchCell.h
//  qzalog
//
//  Created by Mus Bai on 23.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchObject.h"

@protocol SearchCell <NSObject>

-(NSString *) generateSearchString;
-(void) initWithSearchObject: (SearchObject *) searchObject;
-(void) clearCell;

@end
