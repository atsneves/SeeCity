//
//  SCLoginViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 22/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Globais.h"
#import "MBProgressHUD.h"
#import "SCHomeViewController.h"
#import "AFNetworking.h"
#import "SCCadastroViewController.h"
@interface SCLoginViewController ()
{
    Globais *vg;
    MBProgressHUD *hud;
    AFHTTPRequestOperation *operation;
    BOOL isFacebook;
}
@end

@implementation SCLoginViewController

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
    [_txtLogin resignFirstResponder];
    [_txtSenha resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _txtLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Login/E-mail" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: @"HelveticaNeue-Bold"}];
    _txtSenha.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Senha" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: @"HelveticaNeue-Bold"}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationController.navigationBar.topItem.title = @"";
    vg = [Globais shared];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    NSLog(@"chegou no willAppear");
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (ver >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39.0f/255.0f green:89.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.navigationBar.translucent = YES;
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                                NSLog(@"VAMOS TESTAR ISSO AQUI 2");
                
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
    [self.view setFrame:CGRectMake(0,-116,self.view.frame.size.width,self.view.frame.size.height)];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}
@end
