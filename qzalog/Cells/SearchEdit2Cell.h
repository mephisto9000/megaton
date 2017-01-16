//
//  SearchEdit2Cell.h
//  qzalog
//
//  Created by Mus Bai on 16.01.17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"

@interface SearchEdit2Cell : UITableViewCell<SearchCell>

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *fieldView; // ?
@property(nonatomic,retain) IBOutlet UITextField *textView;



@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields; //?


@end
