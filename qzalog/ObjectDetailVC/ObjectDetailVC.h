//
//  ObjectDetailVC.h
//  qzalog
//
//  Created by Mus Bai on 27.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectDetailListener.h"
#import "BaseController.h"

@interface ObjectDetailVC : BaseController<UICollectionViewDataSource, UICollectionViewDelegate, ObjectDetailListener, UIActionSheetDelegate>

@property(nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property(nonatomic, retain) NSString *objectId;


@property(nonatomic, retain) IBOutlet UILabel *priceLabel;
@property(nonatomic, retain) IBOutlet UILabel *dateLabel;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *addrLabel;

@property(nonatomic, retain) IBOutlet UIView *infoView;
@property(nonatomic, retain) IBOutlet UIView *contentView;

@property(nonatomic, retain) IBOutlet UILabel *paramNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *paramValueLabel;

@property(nonatomic, retain) IBOutlet UIButton *starButton;
@property(nonatomic, retain) IBOutlet UIButton *mapButton;


@property(nonatomic, retain) IBOutlet UIView  *counterBgView;
@property(nonatomic, retain) IBOutlet UILabel *counterLabel;


//@property(nonatomic, retain) IBOutlet UIBarButtonItem *callButton;

-(IBAction) callButtonClicked :(id) sender;
-(IBAction) backClicked: (id) sender;
-(IBAction) starClicked: (id)sender;


-(IBAction)rightPressed:(id)sender;
-(IBAction)leftPressed:(id)sender;


-(IBAction) pinClicked:(id) sender;




@end
