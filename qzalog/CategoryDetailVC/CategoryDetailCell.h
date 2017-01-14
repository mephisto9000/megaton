//
//  CategoryDetailCell.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface CategoryDetailCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UIImageView *adImage;
@property(nonatomic, retain) IBOutlet UILabel *adTextLabel;
@property(nonatomic, retain) IBOutlet UILabel *addrLabel;
@property(nonatomic, retain) IBOutlet UILabel *infoLabel;


@property(nonatomic, retain) IBOutlet UILabel *oldPriceLabel;
@property(nonatomic, retain) IBOutlet UILabel *priceLabel;
@property(nonatomic, retain) NSString *objectId;

@property (weak, nonatomic) IBOutlet UIView *oldPriceBlock;

@property(nonatomic, retain) DBManager *dbManager;


@property(nonatomic, retain) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIView *viewOut;

@property (nonatomic,assign) CGFloat starMode;


-(IBAction) starButtonClicked:(id) sender;


@end
