//
//  ObjectPhotoVC.h
//  qzalog
//
//  Created by Mus Bai on 17.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectPhotoVC : UIViewController<UICollectionViewDelegate>

@property(nonatomic, retain) IBOutlet UICollectionView *photoCollection;
@property(nonatomic, retain) NSArray<NSString *> *imageArr;



@property(nonatomic, assign) NSInteger currentItemNum;

@property(nonatomic, retain) IBOutlet UILabel *counterLabel;
@property(nonatomic, retain) IBOutlet UIView  *counterBgView;


-(IBAction)backPressed:(id)sender;

@end
