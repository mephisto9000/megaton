//
//  BaseController.m
//  qzalog
//
//  Created by Mus Bai on 18.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) noData : (UIView *) baseView
{
    
   
   // [baseView setBackgroundColor:[UIColor greenColor]];
    _topConst.constant = 69;
    
   
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
        UIView *emptyView = [UIView new];
        //[emptyView setFrame: baseView.bounds];
        //[emptyView setBackgroundColor:[UIColor redColor]];
        [emptyView setFrame:CGRectMake(screenWidth/2 - 100, screenHeight/2 - 120, 200, 100)];
    
        [baseView addSubview:emptyView];
    
    
        baseView.userInteractionEnabled = NO;
        
        UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_not_found.png"]];
        
        [emptyImageView setFrame:CGRectMake(75, 0, 50, 50)];
        
        [emptyView addSubview:emptyImageView];
        
        //emptyImageView.center = emptyImageView.superview.center;
        
        
        UILabel *emptyLabel =  [UILabel new];
        [emptyLabel setText:@"Объекты не найдены"];
        //[emptyLabel setTextColor:[UIColor blackColor]];
        emptyLabel.font=[UIFont boldSystemFontOfSize:15.0];
        [emptyLabel setTextColor:[UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:1.0]];
        //[emptyLabel setBackgroundColor:[UIColor redColor]];
        
        //[emptyLabel setContentMode:UIViewContentMode  UIViewContentModeScaleToFit];
        [emptyLabel sizeToFit];
        [emptyView addSubview : emptyLabel];
       // emptyLabel.center = emptyLabel.superview.center ;
        emptyLabel.frame = CGRectMake(0, 60, 200, emptyLabel.frame.size.height); //.origin.y += 60;
        emptyLabel.textAlignment = UITextAlignmentCenter;
        
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
