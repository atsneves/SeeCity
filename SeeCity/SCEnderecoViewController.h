//
//  SCEnderecoViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 24/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface SCEnderecoViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *vwBox;
@property (weak, nonatomic) IBOutlet UITextField *txtEndereco;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
- (IBAction)actEndereco:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwBoxMapa;
@property (weak, nonatomic) IBOutlet UIButton *btnListagem;
- (IBAction)actMenu:(id)sender;

- (IBAction)actListagem:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwEnderecosFind;
- (IBAction)actClose:(id)sender;
- (IBAction)toMyLocation:(id)sender;


@property (nonatomic, strong) CLLocationManager *minhaLocalizacao;
@end


