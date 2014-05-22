//
//  SCReportarViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface SCReportarViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *vwBox;

@property (weak, nonatomic) IBOutlet UIView *vwBoxMapa;
- (IBAction)actDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoria;


@property (weak, nonatomic) IBOutlet UITextView *txtDescricao;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnPublicar;
- (IBAction)actPublicar:(id)sender;
- (IBAction)actSelecionar:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategoria;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) CLLocationManager *minhaLocalizacao;

- (IBAction)actMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEndereco;
@property (weak, nonatomic) IBOutlet UIView *vwEnderecosFind;
- (IBAction)actClose:(id)sender;
- (IBAction)toMyLocation:(id)sender;

- (IBAction)actBuscarEndereco:(id)sender;
@end
