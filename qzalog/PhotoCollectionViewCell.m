//
//  PhotoCollectionViewCell.m
//  qzalog
//
//  Created by Marat Mustakayev on 1/9/17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    self.clipsToBounds = YES;
    if (self) {

        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
       // _scrollview.backgroundColor = [UIColor redColor];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_scrollview.frame.size.height - _scrollview.frame.size.width / 358 * 224)/2 + 6, _scrollview.frame.size.width, _scrollview.frame.size.width / 358 * 224)];
        

        [_scrollview addSubview:_imageView];
        
        [self addSubview:_scrollview];
           
        
    }
    return self;
    
}


@end
