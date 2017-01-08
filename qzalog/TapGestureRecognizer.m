//
//  TapGestureRecognizer.m
//  qzalog
//
//  Created by Marat Mustakayev on 1/9/17.
//  Copyright © 2017 Mus Bai. All rights reserved.
//

#import "TapGestureRecognizer.h"



@implementation TapGestureRecognizer
-(id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   self.state = UIGestureRecognizerStateRecognized;
   //NSLog(@"TouchesEnded");
    //UITouch *touch = [touches anyObject];
    
    //CGPoint point = [touch locationInView:self.view];
    //CGAffineTransform transformTranslate = CGAffineTransformTranslate([self.view transform], point.x, 0);
    //self.view.transform = transformTranslate;
    
    CGFloat xScale = self.view.transform.a;
    if(xScale < 1){
        [UIView animateWithDuration:0.5
         animations:^{
             self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
             
         }
         completion:nil];
    }
    
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateCancelled;
}
-(void)reset{
    // so simple there's no reset
}

@end
