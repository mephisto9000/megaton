//
//  SelectorSpinnerVC.h
//  qzalog
//
//  Created by Mus Bai on 23.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchObject.h"
#import "ObjectValue.h"

@interface SelectorSpinnerVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, retain) IBOutlet UIPickerView *picker;
@property(nonatomic, retain) SearchObject *searchObject;

//-(void) setObjectValues: (NSArray<ObjectValue *> *) objectValues;


-(IBAction) okClicked:(id)sender;

@end
