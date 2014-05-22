//
//  SCViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 22/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SCViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
- (IBAction)actCriar:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *vwBG;
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
- (IBAction)actEntrar:(id)sender;
- (IBAction)actFacebook:(id)sender;
@end
