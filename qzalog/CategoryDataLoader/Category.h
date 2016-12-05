//
//  Category.h
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property(nonatomic, assign) NSInteger catId;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, assign) NSInteger amount;

@end
