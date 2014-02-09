//
//  SCHomeViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *vwBoxHome;

- (IBAction)actMapa:(id)sender;
- (IBAction)actEndereco:(id)sender;
- (IBAction)actReportar:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEndereco;
@property (weak, nonatomic) IBOutlet UIButton *btnMapa;
@property (weak, nonatomic) IBOutlet UIButton *btnReportar;
@end
