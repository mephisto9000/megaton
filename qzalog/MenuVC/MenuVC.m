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
    CAGradientLayer *gradient;
    //NSArray *menuIcons;
}


const NSString *CATEGORY_SEAGUE = @"goCategory";
//const NSString *MAP_SEGUE = @"toMaps";
//const NSString *TO_SEARCH_FORM1 = @"toSearchForm";
const NSString *TO_FAVORITE = @"toFavorite";
const NSString *TO_ABOUT = @"aboutPage";
const NSString *TO_SALE_DISCREPTION = @"salesPage";


@synthesize tableView;



// вид загрузился - инициализируем значения tableView и массив с иконками
-(void) viewDidLoad
{
    [super viewDidLoad];
    
    /*menuItems = [NSArray arrayWithObjects:@"Поиск", @"Поиск на карте", @"Избранное", @"Способы приоритения", @"О приложении"];
     menuIcons = [NSArray arrayWithObjects:@"ic_menu_way.png", @"ic_menu_search.png", @"ic_pin.png", @"star_white.png", @"ic_menu_about.png", nil];*/
    
    menuItems = [NSArray arrayWithObjects:@"Поиск", @"Избранное", @"Способы приобритения", @"О приложении", nil];
    menuIcons = [NSArray arrayWithObjects:@"ic_menu_search.png", @"star_white.png", @"ic_category_link.png", @"ic_menu_about.png", nil];
    
    
    
    // сколько будет позиций в таблице
    rowNum = [menuItems count];
    
    //градиентная заливка
    [self setGradient];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
}

- (void)setGradient {
    UIView *bgView = [[UIView alloc] initWithFrame: self.view.frame];  //  CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)
    gradient = [CAGradientLayer layer];
    gradient.frame = bgView.bounds;
    
    
    UIColor *c1 = [UIColor colorWithRed:56.0/255.0 green:133.0/250.0 blue:194.0/255.0 alpha:1];
    UIColor *c2 = [UIColor colorWithRed:36.0/255.0 green:184.0/250.0 blue:188.0/255.0 alpha:1];
    
    gradient.colors = [NSArray arrayWithObjects:(id)[c1 CGColor], (id)[c2 CGColor], (id)[c1 CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void) orientationChanged:(NSNotification *)note
{
    
    UIDevice * device = note.object;
    
   
    [gradient removeFromSuperlayer];
     [self setGradient];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ((indexPath.row) == 0)
        [self performSegueWithIdentifier:CATEGORY_SEAGUE sender:self];
    
    
    if (indexPath.row == 1)
        [self performSegueWithIdentifier:TO_FAVORITE sender:self];
    
    if (indexPath.row == 2)
        [self performSegueWithIdentifier:TO_SALE_DISCREPTION sender:self];
    if (indexPath.row == 3)
        [self performSegueWithIdentifier:TO_ABOUT sender:self];
    
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowNum;
}

//создаем ячейки таблицы
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    }
    
  
    cell.tImage.image = [UIImage imageNamed:menuIcons[indexPath.row]];
    
    cell.tLabel.text = [menuItems objectAtIndex:indexPath.row];
    cell.tLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.00 green:0.40 blue:0.56 alpha:0.3];
    cell.selectedBackgroundView = myBackView;
    
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
        
        //если идем на избранное, то берем контроллер CategoryDetail и передаем параметр  favorite
        [cdvc setIsFavourite:YES];
    }
}


@end
