//
//  SCCrimesViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCCrimesViewController.h"
#import "Globais.h"
#import "SCCrimesCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SCCrime.h"
#import <FacebookSDK/FacebookSDK.h>
@interface SCCrimesViewController ()
{
    Globais *vg;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
    NSMutableArray *arCrimes;
    NSInteger indexClicado;
}
@end

@implementation SCCrimesViewController

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
    
    _tabela.dataSource = self;
    _tabela.delegate = self;
    _vwBoxTitulo.layer.cornerRadius = 5.0f;
    _tabela.layer.cornerRadius = 5.0f;
    
    vg = [Globais shared];
    arCrimes = [[NSMutableArray alloc] init];
    
    
    
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
    
    [self verificaConexao:1 withCrime:nil withOrder:@"DATA"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    _minhaLocalizacao = [locations lastObject];
    NSString *strLoc = [NSString stringWithFormat:@"Lat: %f, Long: %f\r",_minhaLocalizacao.location.coordinate.latitude,_minhaLocalizacao.location.coordinate.longitude];
    
    NSLog(@"Minha Localização %@",strLoc);
    
}

- (void)verificaConexao:(NSInteger)Type withCrime:(SCCrime*)crime withOrder:(NSString*)order
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
                    [self listaCrimes:order];
                    break;
                case 2:
                    [self agradecer:crime];
                    break;
                case 3:
                    [self addCommenta:crime];
                    break;
                default:
                    break;
            }
            
        }
    }];
    [manager startMonitoring];
}
-(void)listaCrimes:(NSString*)order
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"Autenticando usuário";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@listaCrime", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    
    NSDictionary *params = @{@"longitude":[NSString stringWithFormat:@"%f",_minhaLocalizacao.location.coordinate.longitude],@"latitude":[NSString stringWithFormat:@"%f",_minhaLocalizacao.location.coordinate.latitude],@"order":order};
    
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
                        
                        [arCrimes addObject:crime];
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_tabela reloadData];
                        
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


-(void)addCommenta:(SCCrime*)crimeSelecionado
{
    
    hud = [MBProgressHUD showHUDAddedTo:_vwComentar animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"Enviando comentário";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@addComent", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    
    
    NSDictionary *params = @{@"crime":crimeSelecionado._id,@"comentario":_lblComentar.text,@"usuario":crimeSelecionado.usuario};
    
    NSError *e;
    
    NSLog(@"params PEOPLE agradecer%@",[params description]);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&e];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: jsonData];
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Agradecendo"];
        
    }];
    
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        NSNull *nulo = [[NSNull alloc] init];
        
        
        if (!er && res != nulo) {
            
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
            [arCrimes removeAllObjects];
            [UIView animateWithDuration:0.5 animations:^{
                _vwComentar.frame = CGRectMake(0, -1000, _vwComentar.frame.size.width, _vwComentar.frame.size.height);
            }];
            
            
            [self verificaConexao:1 withCrime:nil withOrder:@"DATA"];
            
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


-(void)agradecer:(SCCrime*)crimeSelecionado
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"Agradecendo";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@addAgradecer", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    

    
    NSDictionary *params = @{@"crime":crimeSelecionado._id};
    
    NSError *e;
    
    NSLog(@"params PEOPLE agradecer%@",[params description]);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&e];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: jsonData];
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Agradecendo"];
        
    }];
    
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        NSNull *nulo = [[NSNull alloc] init];
        
        
        if (!er && res != nulo) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                SCCrime *crime = [SCCrime parseCrime:res];
                
                [arCrimes replaceObjectAtIndex:indexClicado withObject:crime];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_tabela reloadData];
                    
                    hud.hidden = YES;
                    [hud removeFromSuperViewOnHide];
                    
                });
                
                
                
            });
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arCrimes.count;
}

- (NSDictionary*)buscaCategoria:(NSString*)ide
{
    NSArray *arCategoria = [[NSMutableArray alloc] initWithArray:@[@{@"descricao":@"Furto",@"imagem":@"furto.png",@"categoria":@"FURTO"},@{@"descricao":@"Assalto",@"imagem":@"assalto.png",@"categoria":@"ASSALTO"},@{@"descricao":@"Assalto em Curso",@"imagem":@"assaltoemcurso.png",@"categoria":@"ASSALTOCURSO"},@{@"descricao":@"Disparo de Alarme",@"imagem":@"disparodealarme.png",@"categoria":@"ALARME"},@{@"descricao":@"Atividade Suspeita",@"imagem":@"suspeita.png",@"categoria":@"ATIVIDADE"},@{@"descricao":@"Acidente",@"imagem":@"acidente.png",@"categoria":@"ACIDENTE"},@{@"descricao":@"Atentado ao pudor",@"imagem":@"atentado.png",@"categoria":@"ATENTADOPUDOR"},@{@"descricao":@"Comércio e uso de drogas",@"imagem":@"comercio.png",@"categoria":@"DROGAS"},@{@"descricao":@"Arrombamento",@"imagem":@"arrombamento.png",@"categoria":@"ARROMBAMENTO"},@{@"descricao":@"Sequesto Relâmpago",@"imagem":@"sequestro.png",@"categoria":@"SEQUESTRORELAMPAGO"},@{@"descricao":@"Arrastão",@"imagem":@"arrastao.png",@"categoria":@"ARRASTAO"}]];
    
    
    NSArray *filteredarray = [arCategoria filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"categoria = %@", ide]];
    
    NSLog(@"filteredarray %@",[filteredarray description]);
    
    if (filteredarray.count > 0) {
        return [filteredarray objectAtIndex:0];
    }
    else
    {
        return nil;
    }

}
- (NSDate *)dateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    
	NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    
	[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
	[rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	// Convert the RFC 3339 date time string to an NSDate.
	NSDate *result = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
	return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCrimesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celula"];
    
    SCCrime *crime = [arCrimes objectAtIndex:indexPath.row];
    
    NSDictionary *dicCategoria = [self buscaCategoria:crime.categoria];
    
    cell.txtDescricao.text = crime.descricao;
    
    cell.lblPor.text = crime.usuario;
    
    cell.btnAgradecer.tag = indexPath.row;
    
    cell.btnComentar.tag = indexPath.row;
    
    cell.btnCompartilhar.tag = indexPath.row;
    
    cell.lblComentar.text = [NSString stringWithFormat:@"(%@)",crime.comentarios];
    
    cell.lblAgradecer.text = [NSString stringWithFormat:@"(%@)",crime.agradecimento];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CLLocation *currentLoc = _minhaLocalizacao.location;
    
    CLLocationDegrees latCrime = [[crime.localizacao objectAtIndex:1] floatValue];
    CLLocationDegrees lngCrime = [[crime.localizacao objectAtIndex:0] floatValue];
    
    
    
    CLLocation *restaurnatLoc = [[CLLocation alloc] initWithLatitude:latCrime longitude:lngCrime];
    CLLocationDistance meters = [restaurnatLoc distanceFromLocation:currentLoc];
    
    cell.lblDistancia.text = [NSString stringWithFormat:@"Aprox. %.0f mts",meters];
    
    cell.lblTipo.text = [dicCategoria objectForKey:@"descricao"];
    
    cell.imgCategoria.image = [UIImage imageNamed:[dicCategoria objectForKey:@"imagem"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm"];
    
    NSString *dateString = [dateFormatter stringFromDate:[self dateForRFC3339DateTimeString:crime.data]];
    
    cell.lblData.text = dateString;
    
    return cell;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actReport:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)actAgradecer:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    SCCrime *crime = [arCrimes objectAtIndex:btn.tag];
    
    indexClicado = btn.tag;
    
    [self verificaConexao:2 withCrime:crime withOrder:@"DATA"];
    
    NSLog(@"Row is %d",btn.tag);
    
}

- (IBAction)actComentar:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    indexClicado = btn.tag;
    
    
    [UIView animateWithDuration:1.0 animations:^{
        _vwComentar.frame = CGRectMake(0, 0, _vwComentar.frame.size.width, _vwComentar.frame.size.height);
    }];
    
    
}

- (IBAction)actCompartilhar:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    SCCrime *crime = [arCrimes objectAtIndex:btn.tag];
    
    indexClicado = btn.tag;
    
    if ([FBSession.activeSession isOpen]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.detailsLabelText = @"Compartilhando";

        
        NSDictionary *dicCategoria = [self buscaCategoria:crime.categoria];
        
        
        NSString *picture = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=13&size=600x300&maptype=roadmap&markers=color:red%%7Clabel:C%%7C%@,%@&sensor=false",[crime.localizacao objectAtIndex:1],[crime.localizacao objectAtIndex:0],[crime.localizacao objectAtIndex:1],[crime.localizacao objectAtIndex:0]];
        NSLog(@"picture");
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"SeeCity", @"name",
                                       [dicCategoria objectForKey:@"descricao"], @"caption",
                                      crime.descricao, @"description",
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

- (IBAction)actProximidade:(id)sender {
    [arCrimes removeAllObjects];
    [self verificaConexao:1 withCrime:nil withOrder:@"PROX"];
}

- (IBAction)actData:(id)sender {
    [arCrimes removeAllObjects];
    [self verificaConexao:1 withCrime:nil withOrder:@"DATA"];
}

- (IBAction)actCategoria:(id)sender {
    [arCrimes removeAllObjects];
    [self verificaConexao:1 withCrime:nil withOrder:@"CATEGORIA"];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)actComment:(id)sender {
    
    SCCrime *crime = [arCrimes objectAtIndex:indexClicado];
    

    
    
    if (_lblComentar.text.length <= 10) {
        
        [self.view endEditing:YES];
        
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"O campo comentário é obrigatório" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alerta show];
        
        return;
        
    }
    
    
    [self verificaConexao:3 withCrime:crime withOrder:@"DATA"];
    
    
    
}

- (IBAction)actCanecel:(id)sender {
    [self.view endEditing:YES];
    
    _lblComentar.text = @"";
    
    [UIView animateWithDuration:1.0 animations:^{
        _vwComentar.frame = CGRectMake(0, -1000, _vwComentar.frame.size.width, _vwComentar.frame.size.height);
    }];
}
@end
