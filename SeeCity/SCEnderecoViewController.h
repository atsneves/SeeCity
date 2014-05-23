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
#import "SCReportarViewController.h"

@interface SCEnderecoViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
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

@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (nonatomic, strong) CLLocationManager *minhaLocalizacao;

@property (nonatomic,strong) SCReportarViewController *reportar;
@end


