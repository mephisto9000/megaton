//
//  SearchEditCell.m
//  qzalog
//
//  Created by Mus Bai on 23.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SearchEditCell.h"

@implementation SearchEditCell
{
    SearchObject *searchObject;
}

@synthesize titleLabel;
@synthesize textFrom;
@synthesize textTo;
@synthesize unitLabel;
@synthesize textFields = _textFields;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

 


-(void) initWithSearchObject:(SearchObject *)searchObject
{
    self->searchObject = searchObject;
    
    
    self.titleLabel.text = self->searchObject.title;
    self.unitLabel.text = self->searchObject.units;
    
    if ( self->searchObject.selectedValue1 != nil)
        [self.textFrom setText:self->searchObject.selectedValue1];
    
    if ( self->searchObject.selectedValue2 != nil)
        [self.textTo setText:self->searchObject.selectedValue2 ];
    
    
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
    _activeTextField = activeTextField;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)dismissKeyboard {
    
    //NSLog(@"here!");
    
    [[_textFields objectAtIndex:_activeTextField.tag] resignFirstResponder];
}

-(NSString *) generateSearchString
{
    NSMutableString *ans = [NSMutableString stringWithFormat:@""];
    
    if (searchObject.name != nil && [searchObject.name length] > 0 && [textFrom.text length] > 0)
        [ans appendString:[NSString stringWithFormat:@"&%@=%@", searchObject.name, textFrom.text]];
    
    if (searchObject.name2 != nil && [searchObject.name2 length] > 0 && [textTo.text length] > 0)
        [ans appendString:[NSString stringWithFormat:@"&%@=%@", searchObject.name2, textTo.text]];
    
    NSLog(@"ans == %@", ans);
    
    
    searchObject.selectedValue1 = textFrom.text;
    searchObject.selectedValue2 = textTo.text;
    
    
    return ans;
}



-(void) clearCell
{
    
        NSLog(@"clearing searchEditCell");
    
        [self.textTo setText:@""];
        [self.textFrom setText:@""];
    
        searchObject.placeholder = searchObject.savedPlaceholder;
}


@end
