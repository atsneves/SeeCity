//
//  SCCadastroViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 22/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCCadastroViewController.h"

@interface SCCadastroViewController ()
{
    BOOL animate;
    float ver;
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
@end
