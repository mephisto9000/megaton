//
//  ObjectPhotoVC.h
//  qzalog
//
//  Created by Mus Bai on 17.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapGestureRecognizer.h"
#import "PhotoCollectionViewCell.h"

@interface ObjectPhotoVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain) IBOutlet UICollectionView *photoCollection;
@property(nonatomic, retain) NSArray<NSString *> *imageArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeight;


@property(nonatomic, assign) NSInteger currentItemNum;

@property(nonatomic, retain) IBOutlet UILabel *counterLabel;
@property(nonatomic, retain) IBOutlet UILabel *counterLabel2;
@property(nonatomic, retain) IBOutlet UIView  *counterBgView;



@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic,assign) CGFloat scale;
@property (nonatomic,assign) CGFloat recognizerRightEnabled;
@property (nonatomic,assign) CGFloat recognizerLeftEnabled;

-(IBAction)backPressed:(id)sender;



@end
