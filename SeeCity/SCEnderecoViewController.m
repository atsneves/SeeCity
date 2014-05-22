//
//  SCEnderecoViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 24/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCEnderecoViewController.h"
#import "Globais.h"
#import "MBProgressHUD.h"
#import "SCAgradecimentoViewController.h"
#import "AFNetworking.h"
#import "SCHomeViewController.h"
#import "SCFindEnderecoViewController.h"
#import "SCCrimesViewController.h"
#import "SCCrime.h"
@interface SCEnderecoViewController ()
{
    Globais *vg;
    NSMutableArray *arCategoria;
    GMSMapView *mapaReport;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
    GMSGeocoder *geocoder;
    SCCrime *crimeCriado;
}
@end

@implementation SCEnderecoViewController

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
    _lblLogin.text = vg.userLogado.usuario;
    
    _minhaLocalizacao = [[CLLocationManager alloc] init];
    

    _txtEndereco.layer.cornerRadius = 5.0f;
    _btnListagem.layer.cornerRadius = 5.0f;
    
    if ([CLLocationManager locationServicesEnabled])
    {
        
        [_minhaLocalizacao startUpdatingLocation];
        
    }
    else
    {
        UIAlertView *vwAlerta = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Seu serviço de localização não está autorizado." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [vwAlerta show];
    }
    
    vg.minhaLocalizacao = _minhaLocalizacao.location;
    
    NSLog(@"_minhaLocalizacao %@",[_minhaLocalizacao description]);
    
    [self minhaLocalizacaoSetada];
    
    
    
    [self verificaConexao:1];
    
}

- (void)verificaConexao:(NSInteger)Type
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            hud.labelText = @"Sem conexão com a internet";
            [hud hide:YES afterDelay:2];
            
        }
        else
        {
            
            switch (Type) {
                case 1:
                    [self listaCrimes];
                    break;
                default:
                    break;
            }
            
        }
    }];
    [manager startMonitoring];
}

-(void)listaCrimes
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"Listando Crimes";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@listaCrime", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    
    NSDictionary *params = @{@"longitude":[NSString stringWithFormat:@"%f",_minhaLocalizacao.location.coordinate.longitude],@"latitude":[NSString stringWithFormat:@"%f",_minhaLocalizacao.location.coordinate.latitude],@"order":@"DATA"};
    
    NSError *e;
    
    NSLog(@"params PEOPLE %@",[params description]);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&e];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: jsonData];
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Autenticando no servidor"];
        
    }];
    
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSArray *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        NSNull *nulo = [[NSNull alloc] init];
        
        
        if (!er && res != nulo) {
            
            if (res.count > 0) {
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    for (int i = 0; i < res.count; i++) {
                        SCCrime *crime = [SCCrime parseCrime:[res objectAtIndex:i]];
                        
                        NSString *strUrl = [NSString stringWithFormat:kBaseURL@"countCommentByCrime/%@",crime._id];
                        
                        
                        NSLog(@"strUrl JSON %@",strUrl);
                        
                        NSError *err;
                        NSString *totalJson = [NSString stringWithContentsOfURL:[NSURL URLWithString:strUrl] encoding:NSUTF8StringEncoding error:&err];
                        
                        NSLog(@"Erro %@",[err description]);
                        NSLog(@"totalJSN %@",totalJson);
                        
                        crime.comentarios = totalJson;
                        
                        
                            GMSMarker *marker = [[GMSMarker alloc] init];
                            
                            CLLocationDegrees lati = [[crime.localizacao objectAtIndex:1] doubleValue];
                            
                            CLLocationDegrees lng = [[crime.localizacao objectAtIndex:0] doubleValue];
                            
                            marker.position = CLLocationCoordinate2DMake(lati, lng);
                            marker.title = crime.descricao;
                            marker.snippet = crime.categoria;
                            
                            marker.map = mapaReport;
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        hud.hidden = YES;
                        [hud removeFromSuperViewOnHide];
                        
                    });
                    
                    
                    
                });
                
                
                
            }
            else
            {
                hud.hidden = YES;
                [hud removeFromSuperViewOnHide];
                
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Nenhum crime a ser listado" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
                
            }
            
        }
        else
        {
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
            
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro ao localizar crimes" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alerta show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
        NSLog(@"ERROR AQUI%@",[error description]);
        [operation cancel];
        hud.hidden = YES;
        [hud removeFromSuperViewOnHide];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actClose:(id)sender {
    [self.view endEditing:YES];
    _vwEnderecosFind.hidden = YES;
    
    if (vg.enderecoSelecionado) {
        
        [self verificaConexao:1];
        
        _txtEndereco.text = [vg.enderecoSelecionado objectForKey:@"endereco"];
        
        [mapaReport clear];
        
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        CLLocationDegrees lati = [[[vg.enderecoSelecionado objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
        
        CLLocationDegrees lng = [[[vg.enderecoSelecionado objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
        
        marker.position = CLLocationCoordinate2DMake(lati, lng);
        marker.title = _txtEndereco.text;
        
        marker.map = mapaReport;
        
        
        
        GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:lati
                                                                longitude:lng
                                                                     zoom:18];
        [mapaReport setCamera:sydney];
        
        
        
    }
    
}
-(void)minhaLocalizacaoSetada
{
    [mapaReport removeFromSuperview];
    [mapaReport clear];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_minhaLocalizacao.location.coordinate.latitude
                                                            longitude:_minhaLocalizacao.location.coordinate.longitude
                                                                 zoom:16];
    [mapaReport setMapType:kGMSTypeSatellite];
    mapaReport = [GMSMapView mapWithFrame:CGRectMake(0, 0, _vwBoxMapa.frame.size.width, _vwBoxMapa.frame.size.height) camera:camera];
    
    mapaReport.myLocationEnabled = YES;
    
    mapaReport.layer.cornerRadius = 5.0f;
    [_vwBoxMapa addSubview:mapaReport];
    
    [_vwEnderecosFind bringSubviewToFront:mapaReport];
    
    mapaReport.delegate = self;
    
    geocoder = [GMSGeocoder geocoder];
    
    id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
            GMSMarker *marker = [GMSMarker markerWithPosition:mapaReport.camera.target];
            marker.title = [result.lines objectAtIndex:0];
            marker.map = mapaReport;
            
            if (result.lines.count > 0) {
                _txtEndereco.text = [result.lines objectAtIndex:0];
            }
            
        }
    };
    [geocoder reverseGeocodeCoordinate:mapaReport.camera.target completionHandler:handler];
}


- (IBAction)toMyLocation:(id)sender {
    [self minhaLocalizacaoSetada];
    
    [self verificaConexao:1];
}

- (IBAction)actEndereco:(id)sender {
    _vwEnderecosFind.hidden = NO;
    vg.enderecoSelecionado = nil;
}
- (IBAction)actMenu:(id)sender {
    for (int i = 0; i < self.navigationController.childViewControllers.count; i++) {
        
        if ([[self.navigationController.childViewControllers objectAtIndex:i] isKindOfClass:[SCHomeViewController class]]) {
            SCHomeViewController *vc = (SCHomeViewController*)[self.navigationController.childViewControllers objectAtIndex:i];
            
            [self.navigationController popToViewController:vc animated:YES];
            
            
        }
        
    }
}

- (IBAction)actListagem:(id)sender {
    
    SCCrimesViewController *vcSCCrimesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCrimesViewController"];
    CLLocationDegrees lati = [[[vg.enderecoSelecionado objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
    
    CLLocationDegrees lng = [[[vg.enderecoSelecionado objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
    
    vcSCCrimesViewController.localizacaoSelect = [[CLLocation alloc] initWithLatitude:lati longitude:lng];
    
    [self.navigationController pushViewController:vcSCCrimesViewController animated:YES];
   }

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Alterou o status");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    _minhaLocalizacao = [locations lastObject];
    NSString *strLoc = [NSString stringWithFormat:@"Lat: %f, Long: %f\r",_minhaLocalizacao.location.coordinate.latitude,_minhaLocalizacao.location.coordinate.longitude];
    
    NSLog(@"Minha Localização %@",strLoc);
    
}

//método acionado quando ocorre uma atualizacao de posicionamento pelo GPS - esse método é acionado apenas no iOS5
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //para evitar reescrever o codigo nos dois metodos, aqui nesse método apenas iremos chamar o método que é sempre acionado no ios6
    [self locationManager:manager didUpdateLocations:[NSArray arrayWithObjects:newLocation, oldLocation, nil]];
}

@end
