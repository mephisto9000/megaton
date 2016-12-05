//
//  ViewController.h
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface InitVC : UIViewController<MFMailComposeViewControllerDelegate>

-(IBAction)jumpToMenu:(id)sender;

-(IBAction) callCC:(id)sender;
-(IBAction)sendEmail:(id)sender;

@end

