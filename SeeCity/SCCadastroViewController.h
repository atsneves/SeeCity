//
//  SCCadastroViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 22/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCadastroViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *vwBoxCadastro;
@property (weak, nonatomic) IBOutlet UILabel *lblTitulo;
@property (weak, nonatomic) IBOutlet UITextField *txtNome;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCidade;
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
@property (weak, nonatomic) IBOutlet UIButton *btnCadastrar;
@property (weak, nonatomic) IBOutlet UIButton *actCadastrar;

@end
