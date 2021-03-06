//
//  CategoryDetailVC.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetail.h"


//класс с ДеталямиКатегорий - список объявлений
@interface CategoryDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

// переключатель (по дате / дороже / дешевле)
@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic, retain)  NSString *url;

//если избранное - надо включить флаг
@property(nonatomic, assign) BOOL isFavourite;


@property(nonatomic, retain) IBOutlet UILabel *titleLabel;;

- (void)segmentSwitch:(UISegmentedControl *)sender ;

-(void) setCategory : (NSString *) categoryId;

-(IBAction) jumpToSearchForm : (id) sender;
-(IBAction) jumpBack: (id) sender;



@end
