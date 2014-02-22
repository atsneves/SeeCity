//
//  SCCadastroViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 22/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCCadastroViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SCUsuario.h"
#import "Globais.h"
#import "SCHomeViewController.h"


@interface SCCadastroViewController ()
{
    BOOL animate;
    float ver;
    MBProgressHUD *hud;
    BOOL withConnection;
    AFHTTPRequestOperation *operation;
    Globais *vg;
}
@end

@implementation SCCadastroViewController

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
    [self resignAllFields];
}
- (void)resignAllFields
{
    [_txtCidade resignFirstResponder];
    [_txtLogin resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtNome resignFirstResponder];
    [_txtSenha resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    vg = [Globais shared];
    
    
    UIColor *cor = [UIColor colorWithRed:29.0f/255.0f green:53.0f/255.0f blue:157.0f/255.0f alpha:1.0f];
    animate = YES;
    _txtCidade.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Cidade" attributes:@{NSForegroundColorAttributeName: cor, NSFontAttributeName: @"HelveticaNeue-Bold"}];
    _txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName: cor, NSFontAttributeName: @"HelveticaNeue-Bold"}];
    _txtLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Login" attributes:@{NSForegroundColorAttributeName: cor, NSFontAttributeName: @"HelveticaNeue-Bold"}];
    _txtNome.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nome" attributes:@{NSForegroundColorAttributeName: cor, NSFontAttributeName: @"HelveticaNeue-Bold"}];
    _txtSenha.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Senha" attributes:@{NSForegroundColorAttributeName: cor, NSFontAttributeName: @"HelveticaNeue-Bold"}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    _txtNome.delegate = self;
    _txtEmail.delegate = self;
    _txtCidade.delegate = self;
    _txtLogin.delegate = self;
    _txtSenha.delegate = self;
    
    _vwBoxCadastro.layer.cornerRadius = 5.0f;
    _txtNome.layer.cornerRadius = 5.0f;
    _txtEmail.layer.cornerRadius = 5.0f;
    _txtCidade.layer.cornerRadius = 5.0f;
    _txtLogin.layer.cornerRadius = 5.0f;
    _txtSenha.layer.cornerRadius = 5.0f;
    _lblTitulo.layer.cornerRadius = 5.0f;
    _btnCadastrar.layer.cornerRadius = 5.0f;
    self.navigationController.navigationBar.topItem.title = @"";

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
            withConnection = NO;
        }
        else
        {
            withConnection = YES;
            
            switch (Type) {
                case 1:
                    [self createLogin];
                    break;
                case 2:
                    [self createUser];
                    break;
                default:
                    break;
            }
            
        }
    }];
    [manager startMonitoring];
}



- (void)createLogin
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@generateLogin", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Gerando Login";
    hud.dimBackground = YES;
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    

    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Gerando Login"];
        
    }];
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        if (!er) {
            _txtLogin.text = [res objectForKey:@"name"];
            hud.hidden = YES;
            [hud removeFromSuperViewOnHide];

            
            if (vg.dadosFacebook) {
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Complete o seu cadastro para continuar" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
                
                _txtEmail.text = [vg.dadosFacebook objectForKey:@"email"];
                _txtNome.text = [vg.dadosFacebook objectForKey:@"name"];
                _txtCidade.text = [[vg.dadosFacebook objectForKey:@"location"] objectForKey:@"name"];
                
                NSLog(@"Dados Face %@",[vg.dadosFacebook description]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
        NSLog(@"ERROR AQUI%@",[error description]);
        [operation cancel];
        hud.hidden = YES;
        [hud removeFromSuperViewOnHide];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    NSLog(@"chegou no willAppear");
    ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (ver >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39.0f/255.0f green:89.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.navigationBar.translucent = YES;
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Entrou aqui para editar %.2f",[[UIScreen mainScreen] bounds].size.width);
    if (textField == _txtNome) {
        animate = NO;
    }
    else if ((textField == _txtEmail || textField == _txtCidade) && [[UIScreen mainScreen] bounds].size.height >= 568)
    {
        animate = NO;
    }
    else
    {
        animate = YES;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark NOtification center teclado

- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    if (animate) {
        [self.view setFrame:CGRectMake(0,-216,self.view.frame.size.width,self.view.frame.size.height)];
    }

    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    if (animate) {
        [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    }

}
- (IBAction)actCadastrar:(id)sender {
    
    BOOL isValid = YES;
    NSString *strErro = @"O(s) campo(s) abaixo é(sao) obrigatório(s) \n";
    
    if (_txtNome.text.length <=1 ) {
        isValid = NO;
        strErro = [strErro stringByAppendingString:@" Nome \n"];
    }
    
    if (_txtEmail.text.length <=1 ) {
        isValid = NO;
        strErro = [strErro stringByAppendingString:@" Email \n"];
    }
    
    if (_txtCidade.text.length <=1 ) {
        isValid = NO;
        strErro = [strErro stringByAppendingString:@" Cidade \n"];
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
        [self verificaConexao:2];
    }
    

}

- (void)createUser
{
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@novousuario", kBaseURL]]];
    [request setHTTPMethod: @"post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setTimeoutInterval:60 * 10];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Gerando Login";
    hud.dimBackground = YES;
    
    NSDictionary *params =     @{@"nome":_txtNome.text,@"senha":_txtSenha.text,@"cidade":_txtCidade.text,@"email":_txtEmail.text,@"login":_txtLogin.text};
    
    NSError *e;
    
    NSLog(@"params PEOPLE %@",[params description]);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&e];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: jsonData];
    
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        
        hud.detailsLabelText = [NSString stringWithFormat:@"Gerando Login"];
        
    }];
    
    SCHomeViewController *vcSCHomeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCHomeViewController"];

    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSError *er;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&er];
        
        NSLog(@"res %@",[res description]);
        
        if (!er) {
            
            if (![res objectForKey:@"err"]) {
                
                
                SCUsuario *usuario = [SCUsuario parseUsuario:res];
                
                vg.userLogado = usuario;
                
                NSLog(@"VAMOS TESTAR ISSO AQUI");
                
                [self.navigationController pushViewController:vcSCHomeViewController animated:YES];
                
                
                
            }
            else
            {
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Atençao" message:@"Ocorreu um erro ao se cadastrar" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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

@end
