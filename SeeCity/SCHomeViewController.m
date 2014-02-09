//
//  SCHomeViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCHomeViewController.h"
#import "SCReportarViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SCHomeViewController ()

@end

@implementation SCHomeViewController

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
    _vwBoxHome.layer.cornerRadius = 5.0f;
    _vwBoxHome.alpha = 0.8f;
    
    _btnEndereco.alpha = 1.0f;
    _btnMapa.alpha = 1.0f;
    _btnReportar.alpha = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)actMapa:(id)sender {
}

- (IBAction)actEndereco:(id)sender {
}
- (IBAction)actSair:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
        NSLog(@"renovar");
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actReportar:(id)sender {
    
    SCReportarViewController *vcSCReportarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCReportarViewController"];
    [self.navigationController pushViewController:vcSCReportarViewController animated:YES];
    
    
}
@end
