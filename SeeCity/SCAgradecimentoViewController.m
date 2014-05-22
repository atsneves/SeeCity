//
//  SCAgradecimentoViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 24/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "MBProgressHUD.h"
#import "SCAgradecimentoViewController.h"
#import "AFNetworking.h"
#import "SCHomeViewController.h"
#import "Globais.h"
#import <FacebookSDK/FacebookSDK.h>
@interface SCAgradecimentoViewController ()
{
    Globais *vg;
    GMSMapView *mapaReport;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
    GMSGeocoder *geocoder;
}
@end

@implementation SCAgradecimentoViewController

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
    
    vg = [Globais shared];
    
    
    _vwMapa.layer.cornerRadius = 15.0f;
    
    _lblLogin.text = vg.userLogado.usuario;
    
    [self minhaLocalizacaoSetada];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actMenu:(id)sender {
    
    for (int i = 0; i < self.navigationController.childViewControllers.count; i++) {
        
        if ([[self.navigationController.childViewControllers objectAtIndex:i] isKindOfClass:[SCHomeViewController class]]) {
            SCHomeViewController *vc = (SCHomeViewController*)[self.navigationController.childViewControllers objectAtIndex:i];
            
            [self.navigationController popToViewController:vc animated:YES];
            
            
        }
        
    }
    
}

-(void)minhaLocalizacaoSetada
{
    [mapaReport removeFromSuperview];
    [mapaReport clear];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[_crimePublicado.localizacao objectAtIndex:1] floatValue]
                                                            longitude:[[_crimePublicado.localizacao objectAtIndex:0] floatValue]
                                                                 zoom:16];
    [mapaReport setMapType:kGMSTypeSatellite];
    mapaReport = [GMSMapView mapWithFrame:CGRectMake(0, 0, _vwMapa.frame.size.width, _vwMapa.frame.size.height) camera:camera];
    
    mapaReport.myLocationEnabled = YES;
    
    mapaReport.layer.cornerRadius = 5.0f;
    [_vwMapa addSubview:mapaReport];
    
    
    mapaReport.delegate = self;
    
    geocoder = [GMSGeocoder geocoder];
    
    id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
            GMSMarker *marker = [GMSMarker markerWithPosition:mapaReport.camera.target];
            marker.title = [result.lines objectAtIndex:0];
            marker.map = mapaReport;
        }
    };
    [geocoder reverseGeocodeCoordinate:mapaReport.camera.target completionHandler:handler];
}

- (IBAction)actCompartilhar:(id)sender {
    
    
    if ([FBSession.activeSession isOpen]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.detailsLabelText = @"Compartilhando";
        
        
        NSDictionary *dicCategoria = [Globais buscaCategoria:_crimePublicado.categoria];
        
        
        NSString *picture = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=13&size=600x300&maptype=roadmap&markers=color:red%%7Clabel:C%%7C%@,%@&sensor=false",[_crimePublicado.localizacao objectAtIndex:1],[_crimePublicado.localizacao objectAtIndex:0],[_crimePublicado.localizacao objectAtIndex:1],[_crimePublicado.localizacao objectAtIndex:0]];
        NSLog(@"picture");
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"SeeCity", @"name",
                                       [dicCategoria objectForKey:@"descricao"], @"caption",
                                       _crimePublicado.descricao, @"description",
                                       @"http://www.seecity.com.br", @"link",
                                       @"https://fbcdn-photos-d-a.akamaihd.net/hphotos-ak-ash3/t39.2081/p128x128/851589_717401594945015_1608530499_n.png", @"picture",
                                       nil];
        
        // Make the request
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Link posted successfully to Facebook
                                      NSLog([NSString stringWithFormat:@"result: %@", result]);
                                      hud.hidden = YES;
                                      [hud removeFromSuperViewOnHide];
                                  } else {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                      NSLog([NSString stringWithFormat:@"%@", error.description]);
                                      hud.hidden = YES;
                                      [hud removeFromSuperViewOnHide];
                                  }
                              }];
        
    }
    else
    {
        
    }
    
}

- (IBAction)call190:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:190"]];
    
}
@end
