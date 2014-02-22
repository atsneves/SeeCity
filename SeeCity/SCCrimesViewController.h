//
//  SCCrimesViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SCCrimesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
- (IBAction)actReport:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (weak, nonatomic) IBOutlet UIView *vwBoxTitulo;
@property (nonatomic, strong) CLLocationManager *minhaLocalizacao;

- (IBAction)actAgradecer:(id)sender;

- (IBAction)actComentar:(id)sender;

- (IBAction)actCompartilhar:(id)sender;
- (IBAction)actProximidade:(id)sender;

- (IBAction)actData:(id)sender;
- (IBAction)actCategoria:(id)sender;

- (IBAction)actComment:(id)sender;
- (IBAction)actCanecel:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *vwComentar;

@property (weak, nonatomic) IBOutlet UITextView *lblComentar;
- (IBAction)actMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnComentar;
@end
