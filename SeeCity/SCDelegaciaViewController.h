//
//  SCDelegaciaViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 23/05/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDelegaciaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabela;
- (IBAction)actMenu:(id)sender;
@end
