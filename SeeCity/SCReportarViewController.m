//
//  SCReportarViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCReportarViewController.h"
#import "Globais.h"
#import "MBProgressHUD.h"
#import "SCCrimesViewController.h"
#import "AFNetworking.h"
@interface SCReportarViewController ()
{
    Globais *vg;
    NSMutableArray *arCategoria;
    
    NSTimer *time;
    NSMutableDictionary *dicSelectedCategoria;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
}
@end

@implementation SCReportarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtDescricao resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _vwBox.layer.cornerRadius = 5.0f;
    _vwBoxMapa.layer.cornerRadius = 5.0f;
    _txtDescricao.layer.cornerRadius = 5.0f;
    _lblCategoria.layer.cornerRadius = 5.0f;
    _btnPublicar.layer.cornerRadius = 5.0f;
    _mapa.layer.cornerRadius = 5.0f;
    
    
    dicSelectedCategoria = [[NSMutableDictionary alloc] init];
    
    vg = [Globais shared];

//    _lblUserName.text = [vg.userLogado objectForKey:@"name"];
    
    arCategoria = [[NSMutableArray alloc] initWithArray:@[@{@"descricao":@"Furto",@"imagem":@"furto.png",@"categoria":@"FURTO"},@{@"descricao":@"Assalto",@"imagem":@"assalto.png",@"categoria":@"ASSALTO"},@{@"descricao":@"Assalto em Curso",@"imagem":@"assaltoemcurso.png",@"categoria":@"ASSALTOCURSO"},@{@"descricao":@"Disparo de Alarme",@"imagem":@"disparodealarme.png",@"categoria":@"ALARME"},@{@"descricao":@"Atividade Suspeita",@"imagem":@"suspeita.png",@"categoria":@"ATIVIDADE"},@{@"descricao":@"Acidente",@"imagem":@"acidente.png",@"categoria":@"ACIDENTE"},@{@"descricao":@"Atentado ao pudor",@"imagem":@"atentado.png",@"categoria":@"ATENTADOPUDOR"},@{@"descricao":@"Comércio e uso de drogas",@"imagem":@"comercio.png",@"categoria":@"DROGAS"},@{@"descricao":@"Arrombamento",@"imagem":@"arrombamento.png",@"categoria":@"ARROMBAMENTO"},@{@"descricao":@"Sequesto Relâmpago",@"imagem":@"sequestro.png",@"categoria":@"SEQUESTRORELAMPAGO"},@{@"descricao":@"Arrastão",@"imagem":@"arrastao.png",@"categoria":@"ARRASTAO"}]];

    _pickerCategoria.dataSource = self;
    _pickerCategoria.delegate = self;
 
    _mapa.delegate = self;
    
    _minhaLocalizacao = [[CLLocationManager alloc] init];
    
    
    if ([CLLocationManager locationServicesEnabled])
    {

        [_minhaLocalizacao startUpdatingLocation];
        
    }
    else
    {
        UIAlertView *vwAlerta = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Seu serviço de localização não está autorizado." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [vwAlerta show];
    }
    
    
    MKCoordinateSpan zoom = MKCoordinateSpanMake(0.010, 0.010);
    
    MKCoordinateRegion regiao = MKCoordinateRegionMake(_minhaLocalizacao.location.coordinate, zoom);
    
    [_mapa setRegion:regiao animated:YES];
    
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arCategoria.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[arCategoria objectAtIndex:row] objectForKey:@"descricao"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _lblCategoria.text = [[arCategoria objectAtIndex:row] objectForKey:@"descricao"];
    
    dicSelectedCategoria = [arCategoria objectAtIndex:row];
    
    NSLog(@"dicSelectedCategoria %@",[dicSelectedCategoria description]);
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    
    _lblCategoria.text = @"";
    _txtDescricao.text = @"";
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actDropDown:(id)sender {
    _lblCategoria.text = [[arCategoria objectAtIndex:[_pickerCategoria selectedRowInComponent:0]] objectForKey:@"descricao"];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _pickerCategoria.frame = CGRectMake(0, screenSize.height-162, _pickerCategoria.frame.size.width, _pickerCategoria.frame.size.height);
            _toolbar.frame= CGRectMake(0, screenSize.height-206, _toolbar.frame.size.width, _toolbar.frame.size.height);
            
        }
        
    }];
    
}
- (IBAction)actPublicar:(id)sender {
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Salvando informações";
    hud.dimBackground = YES;
    
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
                    [self createCrime];
                    break;
                default:
                    break;
            }
            
        }
    }];
    [manager startMonitoring];
}

-(void)createCrime
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@addCrime", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    NSLog(@"categoria selecte %@",[dicSelectedCategoria description]);
    
    
    NSDictionary *params =     @{@"categoria":[dicSelectedCategoria objectForKey:@"categoria"],@"descricao":_txtDescricao.text,@"longitude":[NSString stringWithFormat:@"%f",_minhaLocalizacao.location.coordinate.longitude],@"latitude":[NSString stringWithFormat:@"%f",_minhaLocalizacao.location.coordinate.latitude],@"usuario":vg.userLogado.usuario};
    
    NSError *e;
    
    NSLog(@"params PEOPLE %@",[params description]);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&e];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: jsonData];
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Criando Crime"];
        
    }];
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        NSNull *nulo = [[NSNull alloc] init];
        

        if (!er && res != nulo) {
            
            if (![res objectForKey:@"errors"]) {
                
                
                [self openHome];
                
                
            }
            else
            {
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro ao criar crime" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
                
            }
            
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro ao criar crime" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alerta show];
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
        }
        
    } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
        NSLog(@"ERROR AQUI%@",[error description]);
        [operation cancel];
        hud.hidden = YES;
        [hud removeFromSuperViewOnHide];
    }];
}

- (void)openHome
{
    hud.hidden = YES;
    [hud removeFromSuperViewOnHide];
    [time invalidate];
    SCCrimesViewController *vcSCCrimesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCrimesViewController"];
    [self.navigationController pushViewController:vcSCCrimesViewController animated:YES];
}
- (IBAction)actSelecionar:(id)sender {
    _lblCategoria.text = [[arCategoria objectAtIndex:[_pickerCategoria selectedRowInComponent:0]] objectForKey:@"descricao"];
    
    dicSelectedCategoria =[arCategoria objectAtIndex:[_pickerCategoria selectedRowInComponent:0]];
    
    [UIView animateWithDuration:0.3 animations:^{

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _pickerCategoria.frame = CGRectMake(0, 700, _pickerCategoria.frame.size.width, _pickerCategoria.frame.size.height);
            _toolbar.frame= CGRectMake(0, 700, _toolbar.frame.size.width, _toolbar.frame.size.height);
            
        }
        
    }];
}
- (IBAction)actEndereco:(id)sender {
    SCCrimesViewController *vcSCCrimesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCrimesViewController"];
    [self.navigationController pushViewController:vcSCCrimesViewController animated:YES];
}
@end
