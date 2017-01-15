//
//  SearchEdit2Cell.m
//  qzalog
//
//  Created by Marat Mustakayev on 1/15/17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import "SearchEdit2Cell.h"

@implementation SearchEdit2Cell
{
    SearchObject *searchObject;
}

@synthesize titleLabel;
@synthesize textField;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [textField setDelegate:self];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [searchObject setSelectedValue1: textField.text];
    
}


-(void) initWithSearchObject:(SearchObject *)searchObject2
{
    searchObject = searchObject2;
    
    
    self.titleLabel.text = searchObject.title.uppercaseString;
    
    
    
    if ( searchObject.selectedValue1 != nil)
        [self.textField setText:searchObject.selectedValue1];
    else
        [self.textField setText:nil];
    
    
    
    
    UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc] initWithTitle:@"Закрыть" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    
    UIToolbar *bar = [UIToolbar new];
    
    [bar setItems:[NSArray arrayWithObjects: doneButton, nil]];
    [bar sizeToFit];
    
    [self.textField addTarget:self action:@selector(setActiveTextField:) forControlEvents:UIControlEventEditingDidBegin];
    [self.textField setInputAccessoryView:bar];
    
    
}

- (void)setActiveTextField:(UITextField *)activeTextField {
    _activeTextField = activeTextField;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)dismissKeyboard {
    
    //NSLog(@"here!");
    
    
}

-(NSString *) generateSearchString
{
    NSMutableString *ans = [NSMutableString stringWithFormat:@""];
    
    if (searchObject.name != nil && [searchObject.name length] > 0 && [textField.text length] > 0)
        [ans appendString:[NSString stringWithFormat:@"&%@=%@", searchObject.name, textField.text]];
    
    
    NSLog(@"ans == %@", ans);
    
    
    searchObject.selectedValue1 = textField.text;
   
    
    
    return ans;
}



-(void) clearCell
{
    
    NSLog(@"clearing searchEditCell");
    
    [self.textField setText:@""];
        
    searchObject.placeholder = searchObject.savedPlaceholder;
}


@end
