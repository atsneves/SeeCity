//
//  SCDetalheViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 06/05/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCDetalheViewController.h"
#import "MZFormSheetController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Globais.h"
#import "TipoListagem.h"
@interface SCDetalheViewController ()
{
    Globais *vg;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
}

@end

@implementation SCDetalheViewController

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

    NSDictionary *dicCategoria = [self buscaCategoria:_crime.categoria];
    
    CLLocationDegrees latCrime = [[_crime.localizacao objectAtIndex:1] floatValue];
    CLLocationDegrees lngCrime = [[_crime.localizacao objectAtIndex:0] floatValue];
    
    CLLocation *currentLoc;
    if (_localizacaoSelect) {
        currentLoc= _localizacaoSelect;
    }
    else
    {
        currentLoc= _minhaLocalizacao.location;
    }
    

    
    CLLocation *restaurnatLoc = [[CLLocation alloc] initWithLatitude:latCrime longitude:lngCrime];
    CLLocationDistance meters = [restaurnatLoc distanceFromLocation:currentLoc];
    
    _distancia.text = [NSString stringWithFormat:@"Aprox. %.0f m",meters];
    
    _tipo.text = [dicCategoria objectForKey:@"descricao"];
    
    _imagem.image = [UIImage imageNamed:[dicCategoria objectForKey:@"imagem"]];

    _detalhe.text = _crime.descricao;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm"];
    
    NSString *dateString = [dateFormatter stringFromDate:[self dateForRFC3339DateTimeString:_crime.data]];
    
    _data.text = dateString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSDate *)dateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    
	NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    
	[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
	[rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	// Convert the RFC 3339 date time string to an NSDate.
	NSDate *result = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
	return result;
}

- (IBAction)actCLose:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
       
    }];
}

- (IBAction)actAgradecer:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    [self verificaConexao:2 withCrime:_crime withOrder:@"DATA"];
    
    NSLog(@"Row is %d",btn.tag);
    
}

- (IBAction)actComentar:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    [self verificaConexao:3 withCrime:_crime withOrder:@"DATA"];
    
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

- (IBAction)actCompartilhar:(id)sender {
    
    
    if ([FBSession.activeSession isOpen]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.detailsLabelText = @"Compartilhando";
        
        
        NSDictionary *dicCategoria = [self buscaCategoria:_crime.categoria];
        
        
        NSString *picture = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=13&size=600x300&maptype=roadmap&markers=color:red%%7Clabel:C%%7C%@,%@&sensor=false",[_crime.localizacao objectAtIndex:1],[_crime.localizacao objectAtIndex:0],[_crime.localizacao objectAtIndex:1],[_crime.localizacao objectAtIndex:0]];

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"SeeCity", @"name",
                                       [dicCategoria objectForKey:@"descricao"], @"caption",
                                       _crime.descricao, @"description",
                                       @"http://www.seecity.com.br", @"link",
                                       picture, @"picture",
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
                                      
                                      UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Link compartilhado com sucesso" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                      [alerta show];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
                [self.view endEditing:YES];
        _boxComentario.hidden = YES;
}
- (IBAction)showComentar:(id)sender {
    _boxComentario.hidden = NO;
    
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
//                    [self listaCrimes:order];
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


-(void)addCommenta:(SCCrime*)crimeSelecionado
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"Enviando comentário";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@addComent", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    
    
    NSDictionary *params = @{@"crime":crimeSelecionado._id,@"comentario":@"",@"usuario":crimeSelecionado.usuario};
    
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
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Comentário efetuado com sucesso." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alerta show];
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
            [self verificaConexao:1 withCrime:nil withOrder:@"DATA"];
            _boxComentario.hidden = YES;
            [self.view endEditing:YES];
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
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Agradecimento registrado com sucesso" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alerta show];
                    
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

@end
