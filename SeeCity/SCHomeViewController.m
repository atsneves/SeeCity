//
//  SCHomeViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCHomeViewController.h"
#import "SCReportarViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCCrimesViewController.h"
#import "SCConfiguracoesViewController.h"
#import "SCEnderecoViewController.h"
@interface SCHomeViewController ()

@end

@implementation SCHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"DIDLOAD");
    
    _minhaLocalizacao = [[CLLocationManager alloc] init];
    _minhaLocalizacao.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled])
    {
        
        [_minhaLocalizacao startUpdatingLocation];
        
    }
    else
    {
        UIAlertView *vwAlerta = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Seu serviço de localização não está autorizado." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [vwAlerta show];
    }
    
    _vwBoxHome.layer.cornerRadius = 15.0f;
    _vwBoxHome.alpha = 0.5f;
    
    _btnEndereco.alpha = 1.0f;
    _btnMapa.alpha = 1.0f;
    _btnReportar.alpha = 1.0f;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    _minhaLocalizacao = [locations lastObject];
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)actMapa:(id)sender {
    
    SCCrimesViewController *vcSCCrimesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCrimesViewController"];
    [self.navigationController pushViewController:vcSCCrimesViewController animated:YES];

}

- (IBAction)actEndereco:(id)sender {
    SCEnderecoViewController *vcSCEnderecoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCEnderecoViewController"];
    
    [self.navigationController pushViewController:vcSCEnderecoViewController animated:YES];
}
- (IBAction)actSair:(id)sender {
    SCConfiguracoesViewController *vcSCConfiguracoesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCConfiguracoesViewController"];
    
    [self.navigationController pushViewController:vcSCConfiguracoesViewController animated:YES];
    
}

- (IBAction)actReportar:(id)sender {
    
    SCReportarViewController *vcSCReportarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCReportarViewController"];
    [self.navigationController pushViewController:vcSCReportarViewController animated:YES];
    
    
}
@end
