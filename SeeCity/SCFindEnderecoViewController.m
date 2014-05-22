//
//  SCFindEnderecoViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 22/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCFindEnderecoViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking/AFNetworking.h"
#import "Globais.h"
#import "SCReportarViewController.h"
@interface SCFindEnderecoViewController ()
{
    NSMutableArray *arEndereco;
    MBProgressHUD *hud;
    Globais *vg;
}
@end

@implementation SCFindEnderecoViewController

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
    
    _search.delegate = self;
    
    vg = [Globais shared];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicEndereco = [arEndereco objectAtIndex:indexPath.row];
    vg.enderecoSelecionado = dicEndereco;
    
    if (_reportar) {
        SCReportarViewController *vc = (SCReportarViewController*)[self parentViewController];
        [vc actClose:nil];
    }
    else
    {
        SCEnderecoViewController *vc = (SCEnderecoViewController*)[self parentViewController];
        [vc actClose:nil];
    }
    

    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arEndereco.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *celula = [tableView dequeueReusableCellWithIdentifier:@"celula"];
    
    NSDictionary *dicEndereco = [arEndereco objectAtIndex:indexPath.row];
    
    celula.textLabel.text = [dicEndereco objectForKey:@"endereco"];
    
    
    return celula;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Buscando endereço(s)";
    hud.dimBackground = YES;
    
    
//    NSDictionary *paramss = @{@"address":searchBar.text,@"sensor":@"true"};
    
    
    NSString *unescaped = searchBar.text;
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [unescaped stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?sensor=true&address=%@&components=country:BR",encodedString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    

    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *arRetorno = [responseObject objectForKey:@"results"];
            [arEndereco removeAllObjects];
            
            for (int i = 0 ; i < arRetorno.count; i++) {
                
                NSDictionary *dicEndereco = @{@"endereco":[[arRetorno objectAtIndex:i] objectForKey:@"formatted_address"],@"location":[[[arRetorno objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"]};
                
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
    
    
//    AFHTTPRequestOperationManager *managerer = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
//    [managerer GET:@"https://maps.googleapis.com/maps/api/geocode/json" parameters:paramss success:^(AFHTTPRequestOperation *operation2, id responseObject2) {
////        NSLog(@"JSON: %@", responseObject);
//        
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSArray *arRetorno = [responseObject2 objectForKey:@"results"];
//            
//            
//            for (int i = 0 ; i < arRetorno.count; i++) {
//                
//                NSDictionary *dicEndereco = @{@"endereco":[[arRetorno objectAtIndex:i] objectForKey:@"formatted_address"],@"location":[[[arRetorno objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"]};
//                
//                NSLog(@"dicEndereco %@",[dicEndereco description]);
//                
//                [arEndereco addObject:dicEndereco];
//            }
//            
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"Entra aqui?");
//                hud.hidden = YES;
//                [hud removeFromSuperViewOnHide];
//                
//                [_tabela reloadData];
//
//                [self.view endEditing:YES];
//            });
//            
//            
//            
//            
//        });
//
//        
//    } failure:^(AFHTTPRequestOperation *operation3, NSError *error) {
//        NSLog(@"Error: %@", error);
//        
//        hud.hidden = YES;
//        [hud removeFromSuperViewOnHide];
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
      
    }];
}
@end
