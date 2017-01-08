//
//  ObjectPhotoVC.h
//  qzalog
//
//  Created by Mus Bai on 17.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapGestureRecognizer.h"

@interface ObjectPhotoVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain) IBOutlet UICollectionView *photoCollection;
@property(nonatomic, retain) NSArray<NSString *> *imageArr;
@property (weak, nonatomic) IBOutlet UIButton *leftArrow;

@property (weak, nonatomic) IBOutlet UIButton *rightArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeight;


@property(nonatomic, assign) NSInteger currentItemNum;

@property(nonatomic, retain) IBOutlet UILabel *counterLabel;
@property(nonatomic, retain) IBOutlet UILabel *counterLabel2;
@property(nonatomic, retain) IBOutlet UIView  *counterBgView;



@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic,assign) CGFloat scale;


-(IBAction)backPressed:(id)sender;

-(IBAction)leftPressed:(id)sender;
-(IBAction)rightPressed:(id)sender;

@end
