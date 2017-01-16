//
//  SearchEdit2Cell.m
//  qzalog
//
//  Created by Mus Bai on 16.01.17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import "SearchEdit2Cell.h"

@implementation SearchEdit2Cell
{
    SearchObject *searchObject;
}

@synthesize titleLabel;
@synthesize textFields = _textFields;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    //[textFrom setDelegate:self];
    //[textTo setDelegate:self];
    [_textView setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [searchObject setSelectedValue1: _textView.text];
    
}


-(void) initWithSearchObject:(SearchObject *)searchObject2
{
    searchObject = searchObject2;
    
    self.titleLabel.text = searchObject.title.uppercaseString;
    
    if ( searchObject.selectedValue1 != nil)
        [self.textView setText:searchObject.selectedValue1];
    else
        [self.textView setText:nil];
    
    
    
    
    
    UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc] initWithTitle:@"Закрыть" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    
    UIToolbar *bar = [UIToolbar new];
    
    for(UITextField *field in _textFields) {
        
        //UIBarButtonItem *okButton =
        [bar setItems:[NSArray arrayWithObjects: doneButton, nil]];
        [bar sizeToFit];
        
        [field addTarget:self action:@selector(setActiveTextField:) forControlEvents:UIControlEventEditingDidBegin];
        [field setInputAccessoryView:bar];
    }
    
    
}


- (void)setActiveTextField:(UITextField *)activeTextField {
    //_activeTextField = activeTextField;
}



/*
- (void)setActiveTextField:(UITextField *)activeTextField {
    _activeTextField = activeTextField;
}*/

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    //[textField resignFirstResponder];
    
    [_textView resignFirstResponder];
    return YES;
}


- (void)dismissKeyboard {
    
    //NSLog(@"here!");
    [_textView resignFirstResponder];
    //[[_textFields objectAtIndex:_activeTextField.tag] resignFirstResponder];
    
    
}

-(NSString *) generateSearchString
{
    NSMutableString *ans = [NSMutableString stringWithFormat:@""];
    
    if (searchObject.name != nil && [searchObject.name length] > 0 && [_textView.text length] > 0)
        [ans appendString:[NSString stringWithFormat:@"&%@=%@", searchObject.name, _textView.text]];
    
    //if (searchObject.name2 != nil && [searchObject.name2 length] > 0 && [textTo.text length] > 0)
    //    [ans appendString:[NSString stringWithFormat:@"&%@=%@", searchObject.name2, textTo.text]];
    
    NSLog(@"ans == %@", ans);
    
    
    searchObject.selectedValue1 = _textView.text;
    searchObject.selectedValue2 = nil;
    //searchObject.selectedValue2 = textTo.text;
    
    
    return ans;
}



-(void) clearCell
{
    
    NSLog(@"clearing searchEditCell");
    
    [self.textView setText:@""];
    
    
    searchObject.placeholder = searchObject.savedPlaceholder;
}

@end
