//
//  SearchFormVC.h
//  qzalog
//
//  Created by Mus Bai on 21.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadListener.h"
#import "SearchObjectReader.h"
#import "Category.h"


@interface SearchFormVC : UIViewController<LoadListener, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSString *categoryId;
//@property(nonatomic, retain) NSString *regionId;


@property(nonatomic, retain) NSString *categoryName;


@property(nonatomic, retain) NSString *regionId;
@property(nonatomic, retain) NSString *regionName;


@property(nonatomic, retain) IBOutlet UITableView *tableView;

@property(nonatomic, retain) IBOutlet UIButton *categoryButton;
@property(nonatomic, retain) IBOutlet UIButton *regionButton;

//@property(nonatomic, retain) Category *category;


-(IBAction) searchObjectSelectClick:(id)sender;

//[self.searchFormVC jumpToSpinner:self];
-(void) jumpToSpinner:(SearchObject *) searchObject;


-(void) updateSearchForms;

-(IBAction) searchClicked: (id) sender;
-(IBAction) backClicked: (id) sender;
-(IBAction) clearClicked: (id) sender;


-(IBAction) categorySelectClicked: (id) sender;
-(IBAction) regionSelectClick: (id) sender;

@end
