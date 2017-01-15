//
//  SearchEdit2Cell.h
//  qzalog
//
//  Created by Marat Mustakayev on 1/15/17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"

@interface SearchEdit2Cell : UITableViewCell<SearchCell, UITextFieldDelegate>

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property(nonatomic,retain) IBOutlet UITextField *textField;

@property (strong, nonatomic) UITextField *activeTextField;



@end
