//
//  SCCrimesViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCrimesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)actReport:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (weak, nonatomic) IBOutlet UIView *vwBoxTitulo;

@end
