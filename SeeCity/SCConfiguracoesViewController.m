//
//  SCConfiguracoesViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 24/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCConfiguracoesViewController.h"
#import "MBProgressHUD.h"
#import "SCAgradecimentoViewController.h"
#import "AFNetworking.h"
#import "SCHomeViewController.h"
#import "Globais.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SCConfiguracoesViewController ()
{
    Globais *vg;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
    UIAlertView *alertValida;
    UIAlertView *alertRemove;
}

@end

@implementation SCConfiguracoesViewController

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
    _txtLogin.text = vg.userLogado.usuario;
    _vwBox.layer.cornerRadius = 15.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actSair:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
        NSLog(@"renovar");
    }];
    
    vg.userLogado = nil;
    vg.dadosFacebook = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)actSalvar:(id)sender {
    
    NSString *strValida = @"";
    
    if (![_txtSenhaAtual.text isEqualToString:vg.userLogado.senha]) {
        strValida = [strValida stringByAppendingString:@"Senha Atual não confere com a digitada \n"];
    }
    
    if ([_txtNovaSenha.text isEqualToString:@""]) {
        strValida = [strValida stringByAppendingString:@"Senha Nova não pode ser vazia \n"];
    }

    if ([_txtConfirmacao.text isEqualToString:@""]) {
        strValida = [strValida stringByAppendingString:@"Confirmação não pode ser vazio \n"];
    }

    if (![_txtNovaSenha.text isEqualToString:_txtConfirmacao.text]) {
        strValida = [strValida stringByAppendingString:@"Senha Nova não pode ser diferente da confirmação \n"];
    }

    if (![strValida isEqualToString:@""]) {
        alertValida = [[UIAlertView alloc] initWithTitle:@"Atenção" message:strValida delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertValida show];
    }
    else
    {
        [self verificaConexao:1];
    }
    
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
                    [self changePass];
                    break;
                case 2:
                    [self RemoveAccount];
                    break;
                default:
                    break;
            }
            
        }
    }];
    [manager startMonitoring];
}

-(void)changePass
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@changePass", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Gerando Login";
    hud.dimBackground = YES;
    
    NSDictionary *params =     @{@"senha":_txtNovaSenha.text,@"ident":vg.userLogado._id};
    
    NSError *e;
    
    NSLog(@"params SENHA %@",[params description]);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&e];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: jsonData];
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Alterando senha"];
        
    }];
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        if (!er) {
            
            if (![res objectForKey:@"err"]) {
                
                vg.userLogado.senha = _txtNovaSenha.text;
                
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Senha alterada com sucesso!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
                
                _txtConfirmacao.text = @"";
                _txtNovaSenha.text = @"";
                _txtSenhaAtual.text = @"";
                
                
            }
            else
            {
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro ao se cadastrar" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
                
            }
            
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)RemoveAccount
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@cancelAccount", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Gerando Login";
    hud.dimBackground = YES;
    
    NSDictionary *params =     @{@"ident":vg.userLogado._id};
    
    NSError *e;
    
    NSLog(@"params SENHA %@",[params description]);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&e];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: jsonData];
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Removendo cadastro"];
        
    }];
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        if (!er) {
            
            if (![res objectForKey:@"err"]) {
                [self actSair:nil];
            }
            else
            {
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro ao se cadastrar" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
                
            }
            
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

- (IBAction)actRemoverConta:(id)sender {
    alertRemove = [[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Tem certeza que deseja remover a conta?" delegate:self cancelButtonTitle:@"Sim" otherButtonTitles: @"Não",nil];
    [alertRemove show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertRemove && buttonIndex == 0) {
        [self verificaConexao:2];
    }
    
}


- (IBAction)actMenu:(id)sender {
    for (int i = 0; i < self.navigationController.childViewControllers.count; i++) {
        
        if ([[self.navigationController.childViewControllers objectAtIndex:i] isKindOfClass:[SCHomeViewController class]]) {
            SCHomeViewController *vc = (SCHomeViewController*)[self.navigationController.childViewControllers objectAtIndex:i];
            
            [self.navigationController popToViewController:vc animated:YES];
            
            
        }
        
    }

}
@end
