//
//  ViewController.h
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"

//класс где мы храним меню
@interface MenuVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
}


@property(nonatomic, retain) IBOutlet UITableView *tableView;


@end
