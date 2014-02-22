//
//  SCLoginViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 22/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
- (IBAction)actEntrar:(id)sender;

@end
