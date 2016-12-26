//
//  CategoryDetailVC.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetail.h"
#import "BaseController.h"


//класс с ДеталямиКатегорий - список объявлений
@interface CategoryDetailVC : BaseController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstSearch;

// переключатель (по дате / дороже / дешевле)
@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic, retain)  NSString *url;

//если избранное - надо включить флаг
@property(nonatomic, assign) BOOL isFavourite;

@property(nonatomic, retain) NSArray<NSString *>  *objIds;

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

- (void)segmentSwitch:(UISegmentedControl *)sender ;

-(void) setCategory : (NSString *) categoryId;

-(IBAction) jumpToSearchForm : (id) sender;
-(IBAction) jumpBack: (id) sender;
-(IBAction) jumpToMap:(id) sender;






@end
