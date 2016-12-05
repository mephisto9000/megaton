//
//  ViewController.m
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "MenuVC.h"
#import "CategoryDetailVC.h"

@interface MenuVC ()

@end

@implementation MenuVC
{
    int rowNum;
    
    NSArray<NSString *> *menuItems;
    NSArray<NSString *> *menuIcons;
    //NSArray *menuIcons;
}


const NSString *CATEGORY_SEAGUE = @"goCategory";
const NSString *MAP_SEGUE = @"toMaps";
const NSString *TO_SEARCH_FORM1 = @"toSearchForm";
const NSString *TO_FAVORITE = @"toFavorite";


@synthesize tableView;
//@synthesize view;

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    menuItems = [NSArray arrayWithObjects:@"Категории", @"Поиск", @"Поиск на карте", @"Избранное", @"О приложении", nil];
    menuIcons = [NSArray arrayWithObjects:@"ic_menu_way.png", @"ic_menu_search.png", @"ic_pin.png", @"star_white.png", @"ic_menu_about.png", nil];
    
    rowNum = [menuItems count];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame: self.view.frame];  //  CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = bgView.bounds;
    
    UIColor *c1 = [UIColor colorWithRed:56.0/255.0 green:133.0/250.0 blue:194.0/255.0 alpha:1];
    UIColor *c2 = [UIColor colorWithRed:36.0/255.0 green:184.0/250.0 blue:188.0/255.0 alpha:1];
    
    gradient.colors = [NSArray arrayWithObjects:(id)[c1 CGColor], (id)[c2 CGColor], (id)[c1 CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row) == 0)
        [self performSegueWithIdentifier:CATEGORY_SEAGUE sender:self];
    
    if (indexPath.row == 1)
        [self performSegueWithIdentifier:TO_SEARCH_FORM1 sender:self];
    
    if ((indexPath.row == 2))
        [self performSegueWithIdentifier:MAP_SEGUE sender:self];
    
    if (indexPath.row == 3)
        [self performSegueWithIdentifier:TO_FAVORITE sender:self];
    
    if (indexPath.row == 4)
        [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"menuCell"];
    }
    
    
    
    //if (indexPath.row == 2 || indexPath.row ==  4)
           cell.imageView.image = [UIImage imageNamed:menuIcons[indexPath.row]];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    //cell.detailTextLabel.text = textLabelDetail;
    
    return cell;
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:TO_FAVORITE])
    {
        CategoryDetailVC *cdvc = (CategoryDetailVC *) segue.destinationViewController;
        
        [cdvc setIsFavourite:YES];
    }
}


@end
