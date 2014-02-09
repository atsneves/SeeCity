//
//  SCReportarViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface SCReportarViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *vwBox;
- (IBAction)btnMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwBoxMapa;
- (IBAction)actDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoria;

@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (weak, nonatomic) IBOutlet UITextView *txtDescricao;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnPublicar;
- (IBAction)actPublicar:(id)sender;
- (IBAction)actSelecionar:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategoria;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) CLLocationManager *minhaLocalizacao;
- (IBAction)actEndereco:(id)sender;

@end
