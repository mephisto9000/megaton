//
//  RegionTableVC.h
//  qzalog
//
//  Created by Mus Bai on 06.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionTableVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) IBOutlet UITableView *tableView;

//@property(nonatomic, retain) IBOutlet

-(IBAction ) backButtonPressed : (id) sender;

@end
