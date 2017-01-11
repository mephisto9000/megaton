//
//  PhotoCollectionViewCell.h
//  qzalog
//
//  Created by Marat Mustakayev on 1/9/17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell{
    UIScrollView *scrollview;
    UIImageView *imageView;
}
@property (nonatomic, retain) UIScrollView *scrollview;

@property (nonatomic, retain) UIImageView *imageView;
  

@end
