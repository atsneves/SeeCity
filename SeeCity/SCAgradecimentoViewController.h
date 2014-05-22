//
//  SCAgradecimentoViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 24/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SCCrime.h"
@interface SCAgradecimentoViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIView *vwMapa;

@property (nonatomic,strong) SCCrime *crimePublicado;

- (IBAction)actMenu:(id)sender;
- (IBAction)actCompartilhar:(id)sender;
- (IBAction)call190:(id)sender;
@end
