//
//  SearchEditCell.h
//  qzalog
//
//  Created by Mus Bai on 23.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"
#import "SearchFormVC.h"

@interface SearchSelectCell : UITableViewCell<SearchCell>

@property(nonatomic, retain) IBOutlet UIButton *button;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

@property(nonatomic, retain) IBOutlet SearchFormVC *searchFormVC;



-(IBAction) searchObjectSelectClick:(id)sender;

@end
