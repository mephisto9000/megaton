//
//  CategoryCell.m
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize countLabel;

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(8, 6, 32, 32);
    // self.imageView.contentMode = UIViewContentModeCenter;
}

@end
