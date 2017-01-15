//
//  ViewController.m
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "InitVC.h"


@interface InitVC ()
@property (weak, nonatomic) IBOutlet UIButton *navButton;

@end

@implementation InitVC

const NSString *MENU_SEAGUE = @"goMenu";




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)jumpToMenu:(id)sender
{
    NSLog(@"jump to menu");
    
    //[self prepareForSegue:MENU_SEAGUE sender:sender];
    [self performSegueWithIdentifier:MENU_SEAGUE sender:sender];
}







@end
