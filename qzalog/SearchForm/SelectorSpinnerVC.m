//
//  SelectorSpinnerVC.m
//  qzalog
//
//  Created by Mus Bai on 23.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SelectorSpinnerVC.h"
#import "SearchFormVC.h"

@interface SelectorSpinnerVC ()
{
    NSMutableArray *spinnerData;
}
@end

@implementation SelectorSpinnerVC

@synthesize picker;
@synthesize searchObject = _searchObject;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return spinnerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return spinnerData[row];
}


-(void) setup
{
   
}


-(IBAction) okClicked:(id)sender;
{
    
    SearchFormVC *sfvc = (SearchFormVC *) [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    int row = (int) [picker selectedRowInComponent:0];
    [self.searchObject setPlaceholder: spinnerData[row]] ; //]  self.searchObject.values[row].name];
//selectedValue1
    [self.searchObject setSelectedValue1:spinnerData[row]];


    [sfvc updateSearchForms];
}

-(void)setSearchObject:(SearchObject *)searchObject
{
    _searchObject = searchObject;
    
    spinnerData = [NSMutableArray new];
    
    [spinnerData addObject: searchObject.savedPlaceholder];
    
    for (ObjectValue *ov in _searchObject.values)
    {
        [spinnerData addObject: ov.name];
        //NSLog(@"selector id == %d", ov.ordId);
    }

    
    
}



@end
