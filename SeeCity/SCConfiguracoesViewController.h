//
//  SCConfiguracoesViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 24/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCConfiguracoesViewController : UIViewController<UIAlertViewDelegate>
- (IBAction)actSair:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtSenhaAtual;
@property (weak, nonatomic) IBOutlet UITextField *txtNovaSenha;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmacao;
- (IBAction)actSalvar:(id)sender;
- (IBAction)actRemoverConta:(id)sender;
- (IBAction)actMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwBox;
@end
