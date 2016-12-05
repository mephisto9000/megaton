//
//  MapVC.h
//  qzalog
//
//  Created by Mus Bai on 29.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MapCoordListener.h"

@interface MapVC : UIViewController<MapCoordListener, GMSMapViewDelegate>

@property (nonatomic, retain) IBOutlet GMSMapView *mapView;

-(IBAction) goBack:(id)sender;

@end
