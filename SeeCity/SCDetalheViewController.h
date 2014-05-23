//
//  SCDetalheViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 06/05/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "SCCrime.h"
@interface SCDetalheViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *minhaLocalizacao;

@property (nonatomic,strong) CLLocation *localizacaoSelect;

@property (nonatomic,strong) SCCrime *crime;
- (IBAction)actCLose:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tipo;
@property (weak, nonatomic) IBOutlet UIImageView *imagem;
@property (weak, nonatomic) IBOutlet UILabel *distancia;
@property (weak, nonatomic) IBOutlet UITextView *detalhe;
@property (weak, nonatomic) IBOutlet UILabel *data;
- (IBAction)actAgradecer:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtComentario;

- (IBAction)actComentar:(id)sender;

- (IBAction)actCompartilhar:(id)sender;

- (IBAction)showComentar:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *boxComentario;

@end
