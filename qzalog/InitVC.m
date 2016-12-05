//
//  ViewController.m
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "InitVC.h"


@interface InitVC ()

@end

@implementation InitVC

const NSString *MENU_SEAGUE = @"goMenu";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


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

-(IBAction)callCC:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://+77272585300"]];
}



-(IBAction)sendEmail:(id)sender
{
    MFMailComposeViewController *mViewController = [[MFMailComposeViewController alloc] init];
    mViewController.mailComposeDelegate = self;
    [mViewController setToRecipients:[[NSArray alloc] initWithObjects:@"sales@kkb.kz", nil]];
    [mViewController setSubject:@"qzalog"];
    //[mViewController setMessageBody:@"MESSAGE_HERE" isHTML:NO];
    
   
    
    [self presentModalViewController:mViewController animated:YES];
    //[mViewController release];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
