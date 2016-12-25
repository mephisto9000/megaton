//
//  SelectorTableVC.h
//  qzalog
//
//  Created by Mus Bai on 26.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchObject.h"

@interface SelectorTableVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) SearchObject *searchObject;
@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

//@property(nonatomic, retain) IBOutlet

-(IBAction ) backButtonPressed : (id) sender;


@end
