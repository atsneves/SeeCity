//
//  SCDelegaciaViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 23/05/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCDelegaciaViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking/AFNetworking.h"
#import "Globais.h"
#import "SCDelegaciaTableViewCell.h"
#import "SCHomeViewController.h"
@interface SCDelegaciaViewController ()
{
    NSMutableArray *arEndereco;
    MBProgressHUD *hud;
    Globais *vg;
}
@end

@implementation SCDelegaciaViewController

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
    
    arEndereco = [[NSMutableArray alloc] init];
    
    _tabela.dataSource = self;
    _tabela.delegate = self;
    
    vg = [Globais shared];
    [self carregaDelegacia];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arEndereco.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCDelegaciaTableViewCell *celula = [tableView dequeueReusableCellWithIdentifier:@"celula"];
    
    NSDictionary *dicEndereco = [arEndereco objectAtIndex:indexPath.row];
    

    CLLocationDegrees latCrime = [[[dicEndereco objectForKey:@"location"] objectForKey:@"lat"] floatValue];
    CLLocationDegrees lngCrime = [[[dicEndereco objectForKey:@"location"] objectForKey:@"lng"] floatValue];
    
    
    
    CLLocation *restaurnatLoc = [[CLLocation alloc] initWithLatitude:latCrime longitude:lngCrime];
    CLLocationDistance meters = [restaurnatLoc distanceFromLocation:vg.minhaLocalizacao];
    
    celula.nome.text = [dicEndereco objectForKey:@"nome"];
    
    celula.endereco.text = [dicEndereco objectForKey:@"endereco"];
    
    celula.distancia.text = [NSString stringWithFormat:@"%.2f km",meters/1000];
    
    return celula;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (IBAction)actMenu:(id)sender {
    for (int i = 0; i < self.navigationController.childViewControllers.count; i++) {
        
        if ([[self.navigationController.childViewControllers objectAtIndex:i] isKindOfClass:[SCHomeViewController class]]) {
            SCHomeViewController *vc = (SCHomeViewController*)[self.navigationController.childViewControllers objectAtIndex:i];
            
            [self.navigationController popToViewController:vc animated:YES];
            
            
        }
        
    }
}
-(void)carregaDelegacia
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Buscando endereço(s)";
    hud.dimBackground = YES;
    
    
    //    NSDictionary *paramss = @{@"address":searchBar.text,@"sensor":@"true"};
    
    CLLocationCoordinate2D minha;
    
    if (!vg.minhaLocalizacao.coordinate.latitude) {
        minha = CLLocationCoordinate2DMake(-23.4474005,-46.4999952);
    }
    else
    {
        minha = vg.minhaLocalizacao.coordinate;
    }
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&rankby=distance&types=police&sensor=true&key=AIzaSyCXukIKZniit1S3x3YQr770MowZ8od1DUw",minha.latitude,minha.longitude]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    
    
    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *arRetorno = [responseObject objectForKey:@"results"];
            [arEndereco removeAllObjects];
            
            for (int i = 0 ; i < arRetorno.count; i++) {
                
                NSDictionary *dicEndereco = @{@"endereco":[[arRetorno objectAtIndex:i] objectForKey:@"vicinity"],@"location":[[[arRetorno objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"],@"nome":[[arRetorno objectAtIndex:i] objectForKey:@"name"]};
                
                NSLog(@"dicEndereco %@",[dicEndereco description]);
                
                [arEndereco addObject:dicEndereco];
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Entra aqui?");
                hud.hidden = YES;
                [hud removeFromSuperViewOnHide];
                
                [_tabela reloadData];
                
                [self.view endEditing:YES];
            });
            
            
            
            
        });    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
            
            [_tabela reloadData];
            
            [self.view endEditing:YES];
        }];
    [[NSOperationQueue mainQueue] addOperation:op];
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

@end
