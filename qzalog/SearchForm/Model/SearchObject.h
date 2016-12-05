//
//  SearchObject.h
//  qzalog
//
//  Created by Mus Bai on 21.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectValue.h"

@interface SearchObject : NSObject

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *units;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) NSString *savedPlaceholder;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *name2;
@property(nonatomic, assign) int main;
@property(nonatomic, assign) int type;
@property(nonatomic, retain) NSArray<ObjectValue *> *values;
@property(nonatomic, assign) int position;


@property(nonatomic, retain) NSString *selectedValue1;
@property(nonatomic, retain) NSString *selectedValue2;

@end
