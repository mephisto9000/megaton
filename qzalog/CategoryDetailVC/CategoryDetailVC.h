//
//  CategoryDetailVC.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetail.h"

@interface CategoryDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic, retain)  NSString *url;
@property(nonatomic, assign) BOOL isFavourite;


@property(nonatomic, retain) IBOutlet UILabel *titleLabel;;

- (void)segmentSwitch:(UISegmentedControl *)sender ;

-(void) setCategory : (NSString *) categoryId;

-(IBAction) jumpToSearchForm : (id) sender;
-(IBAction) jumpBack: (id) sender;



@end
