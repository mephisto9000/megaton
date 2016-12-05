//
//  SearchEditCell.h
//  qzalog
//
//  Created by Mus Bai on 23.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"

@interface SearchEditCell : UITableViewCell<SearchCell>

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

@property(nonatomic,retain) IBOutlet UITextField *textFrom;
@property(nonatomic, retain) IBOutlet UITextField *textTo;

@property (strong, nonatomic) UITextField *activeTextField;


@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;


@property(nonatomic, retain) IBOutlet UILabel *unitLabel;

@end
