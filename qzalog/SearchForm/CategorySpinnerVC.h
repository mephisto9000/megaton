//
//  CategorySpinnerVC.h
//  qzalog
//
//  Created by Mus Bai on 25.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategorySpinnerVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, retain) IBOutlet UIPickerView *picker;

@property(nonatomic, retain) NSString* categoryId;


-(IBAction) okClicked: (id) sender;


@end
