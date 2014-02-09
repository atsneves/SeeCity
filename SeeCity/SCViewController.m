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

@interface SCViewController ()
{
    Globais *vg;
    MBProgressHUD *hud;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

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
    

    
    [FBSession openActiveSessionWithPublishPermissions:[[NSArray alloc] initWithObjects:@"publish_stream",@"publish_actions",@"basic_info",@"email",
                                                        @"manage_pages", nil] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSLog(@"SESSAO %@",[session appID]);
        
        [FBSession setActiveSession:session];
        
        NSLog(@"status %d",status);
        
        NSLog(@"Erro %@",[error description]);
        
        
        if (!error) {
            
            [[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me"] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *errorGraph) {
                if (!errorGraph) {
                    
                    NSLog(@"user facebook %@",[user description]);
                    
                    
                    if (![vg.dadosFacebook containsObject:user]) {

                        hud.detailsLabelText = @"Criando usuário";
                        
                        [vg.dadosFacebook addObject:user];
                        
                        [vg.dadosFacebook writeToFile:vg.caminhoArq atomically:YES];
                        
                    }
                    else
                    {
                        hud.detailsLabelText = @"Autenticando usuário";
                    }
                    
                    vg.userLogado = user;
                    
                    
                    
                    hud.hidden = YES;
                    [hud removeFromSuperViewOnHide];
                    
                    
                    [self.navigationController pushViewController:vcSCHomeViewController animated:YES];
                    
                }
            }];
            
        }
        
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
