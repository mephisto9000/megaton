//
//  RegionSpinnerVC.h
//  qzalog
//
//  Created by Mus Bai on 26.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionSpinnerVC : UIViewController

@property(nonatomic, retain) IBOutlet UIPickerView *picker;


-(IBAction) okClicked:(id) sender;

@end


