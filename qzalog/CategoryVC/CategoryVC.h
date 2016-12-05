//
//  CategoryVC.h
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryListener.h"
#import "CategoryCell.h"


//контроллер категорий
@interface CategoryVC : UIViewController<UITableViewDataSource, UITableViewDelegate, CategoryListener>

@property(nonatomic, retain) IBOutlet UITableView *tableView;

-(IBAction) backPressed : (id) sender;
-(IBAction) searchPressed:(id)sender;
@end
