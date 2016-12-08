//
//  DetailInfo.h
//  qzalog
//
//  Created by Mus Bai on 27.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailInfo : NSObject

@property(nonatomic, assign) NSInteger infoId;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *value;

@end
