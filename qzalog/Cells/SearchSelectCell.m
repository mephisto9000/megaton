//
//  SearchEditCell.m
//  qzalog
//
//  Created by Mus Bai on 23.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SearchSelectCell.h"
#import <QuartzCore/QuartzCore.h>



@interface SearchSelectCell ()
{
    SearchObject *searchObject;
}

@end

 
@implementation SearchSelectCell


@synthesize button;
@synthesize titleLabel;
@synthesize searchFormVC;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    //Detail Disclosure button
    
    
    
    //UIButton *detailButton = [UIButton buttonWithType: UIButtonTypeInfoLight]; //  UIButtonTypeDetailDisclosure
    UIImageView *detailArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right.png"]];
    
    //CGRectM
    
    [detailArrow setFrame:CGRectMake(button.frame.size.width - 20, 3, 15, 30)]; //- 35   //detailButton.frame.size.width/2
    [button addSubview:detailArrow];
    
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    
    [[button layer] setBorderWidth:2.0f];
    [[button layer] setBorderColor:[UIColor grayColor].CGColor];
    
    [button setTitleColor:[UIColor blueColor] forState:  UIControlStateHighlighted];
    [button setBackgroundImage:[self setBackgroundImageByColor:[UIColor blueColor] withFrame:button.frame cornerRadius:0] forState: UIControlStateHighlighted];
    //[button setBackgroundColor: [UIColor blueColor]];  // for setBackgroundImage:[self setBackgroundImageByColor:[UIColor blueColor] withFrame:cancelButton.frame cornerRadius:0] forState:UIControlStateHighlighted];
}

-(UIImage *)setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect cornerRadius:(float)radius{
    
    UIView *tcv = [[UIView alloc] initWithFrame:rect];
    [tcv setBackgroundColor:backgroundColor];
    
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);;
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:radius] addClip];
    [image drawInRect:RECT];
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageNew;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

 
-(void) initWithSearchObject: (SearchObject *) searchObject
{
    self->searchObject = searchObject;
    
    
    self.titleLabel.text = self->searchObject.title;
    [self.button setTitle:self->searchObject.placeholder forState:UIControlStateNormal];
    
    
}


-(IBAction) searchObjectSelectClick:(id)sender
{
    //NSLog(@"here ?");
    
    [self.searchFormVC jumpToSpinner: searchObject];
}

-(void) clearCell
{
    searchObject.placeholder = searchObject.savedPlaceholder;
    
   // button.titleLabel.text =
    [self.button setTitle:searchObject.placeholder forState:UIControlStateNormal|UIControlStateHighlighted|UIControlStateHighlighted]; //self->searchObject.placeholder
    //[self.button setTitle:@"не важно" forState:UIControlStateHighlighted]; //self->searchObject.placeholder
}


-(NSString *) generateSearchString
{
    NSMutableString *ans =   [NSMutableString stringWithFormat:@""];

    NSLog(@"in searchSelectCell");
    
    if (searchObject.name != nil && [searchObject.name length] > 0 && searchObject.placeholder != nil && [searchObject.placeholder length] > 0)
    {
        
        for (int i = 0; i < [searchObject.values count]; i++)
        {
            if ([searchObject.values[i].name isEqualToString: searchObject.placeholder])
                [ans appendString:[NSString stringWithFormat:@"&%@=%@", searchObject.name, searchObject.values[i].valId]]; //.placeholder
        }
    }
    
    NSLog(@"ans == %@", ans);
    return ans;
}

@end
