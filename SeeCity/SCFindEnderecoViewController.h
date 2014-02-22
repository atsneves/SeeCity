//
//  SCFindEnderecoViewController.h
//  SeeCity
//
//  Created by Anderson Neves on 22/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFindEnderecoViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

- (IBAction)actClose:(id)sender;
@end
