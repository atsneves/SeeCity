//
//  SCViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 22/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Globais.h"
#import "MBProgressHUD.h"
#import "SCHomeViewController.h"
#import "AFNetworking.h"
#import "SCCadastroViewController.h"
@interface SCViewController ()
{
    Globais *vg;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
    BOOL isFacebook;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [CLLocationManager locationServicesEnabled];
    
    _txtLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Login/E-mail" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: @"HelveticaNeue-Bold"}];
    _txtSenha.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Senha" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: @"HelveticaNeue-Bold"}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    
    vg = [Globais shared];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtLogin resignFirstResponder];
    [_txtSenha resignFirstResponder];
}

- (IBAction)actCriar:(id)sender {
    [_txtLogin resignFirstResponder];
    [_txtSenha resignFirstResponder];

}
- (IBAction)actEntrar:(id)sender {
    [_txtLogin resignFirstResponder];
    [_txtSenha resignFirstResponder];

    
    
    BOOL isValid = YES;
    NSString *strErro = @"O(s) campo(s) abaixo é(sao) obrigatório(s) \n";
    
    if (_txtLogin.text.length <=1 ) {
        isValid = NO;
        strErro = [strErro stringByAppendingString:@" Usuário / Email \n"];
    }
    
    if (_txtSenha.text.length <=1 ) {
        isValid = NO;
        strErro = [strErro stringByAppendingString:@" Senha \n"];
    }
    
    if (!isValid) {
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:strErro delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alerta show];
    }
    else
    {
        isFacebook = NO;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabelText = @"Autenticaçao de Usuário";
        hud.dimBackground = YES;
        
        [self verificaConexao:1 login:_txtLogin.text withSenha:_txtSenha.text isFacebook:NO];
        

    }
    
}

- (IBAction)actFacebook:(id)sender {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Abrindo autorização do FACEBOOK";
    hud.dimBackground = YES;
    
//    hud.mode = MBProgressHUDMode;
    
    
    SCHomeViewController *vcSCHomeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCHomeViewController"];
    
    if ([FBSession.activeSession isOpen]) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
            NSLog(@"renovar");
        }];

    }
    

    
    [FBSession openActiveSessionWithPublishPermissions:[[NSArray alloc] initWithObjects:@"publish_actions",@"basic_info",@"email", nil] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSLog(@"SESSAO %@",[session appID]);
        
        [FBSession setActiveSession:session];
        
        NSLog(@"status %d",status);
        
        NSLog(@"Erro %@",[error description]);
        
        
        if (!error) {
            
            [[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me"] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *errorGraph) {
                if (!errorGraph) {
                    
                    NSLog(@"user facebook %@",[user description]);
                    vg.dadosFacebook = user;
                    isFacebook = YES;
                    [self verificaConexao:1 login:[user objectForKey:@"email"] withSenha:@"" isFacebook:YES];
                    
                    
                    
                    
                }
            }];
            
        }
        
    }];
     
    
}
#pragma mark Conexao
- (void)verificaConexao:(NSInteger)Type login:(NSString*)email withSenha:(NSString*)senha isFacebook:(BOOL)face
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
                    [self login:email withSenha:senha isFacebook:face];
                    break;
                default:
                    break;
            }
            
        }
    }];
    [manager startMonitoring];
}



-(void)login:(NSString*)email withSenha:(NSString*)senha isFacebook:(BOOL)face
{
    NSLog(@"email %@",email);
    
    hud.detailsLabelText = @"Autenticando usuário";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@login", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    
    NSDictionary *params = @{@"email":email,@"senha":senha,@"isFacebook":(face)?@"true":@"false",@"login":_txtLogin.text};
    
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
    
    SCHomeViewController *vcSCHomeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCHomeViewController"];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        NSNull *nulo = [[NSNull alloc] init];
        
        
        if (!er && res != nulo) {
            
            if (![res objectForKey:@"err"]) {
                hud.hidden = YES;
                [hud removeFromSuperViewOnHide];
                
                
                SCUsuario *usuario = [SCUsuario parseUsuario:res];
                
                vg.userLogado = usuario;
                
                [self.navigationController pushViewController:vcSCHomeViewController animated:YES];
                
                
                
            }
            else
            {
                hud.hidden = YES;
                [hud removeFromSuperViewOnHide];
                
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro ao se cadastrar" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
                
            }
            
        }
        else if(isFacebook)
        {
            
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
            
            SCCadastroViewController *cadastro = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCadastroViewController"];
            
            [self.navigationController pushViewController:cadastro animated:YES];
        }
        else
        {
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];
            
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro \n Usuário ou Senha incorretos" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alerta show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
        NSLog(@"ERROR AQUI%@",[error description]);
        [operation cancel];
        hud.hidden = YES;
        [hud removeFromSuperViewOnHide];
    }];
}

#pragma mark NOtification center teclado

- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-216,self.view.frame.size.width,self.view.frame.size.height)];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}


@end
