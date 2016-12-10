//
//  MapVC.h
//  qzalog
//
//  Created by Mus Bai on 29.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import "MapCoordListener.h"


@interface POIItem : NSObject<GMUClusterItem>

@property(nonatomic, assign) CLLocationCoordinate2D position;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) NSInteger  objId;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name;

@end


@interface MapVC : UIViewController<MapCoordListener, GMSMapViewDelegate, GMUClusterManagerDelegate>

@property (nonatomic, retain) IBOutlet GMSMapView *mapView;

-(IBAction) goBack:(id)sender;

@end
