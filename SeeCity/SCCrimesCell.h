//
//  SCCrimesCell.h
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCrimesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTipo;
@property (weak, nonatomic) IBOutlet UIImageView *imgCategoria;

@property (weak, nonatomic) IBOutlet UILabel *lblPor;
@property (weak, nonatomic) IBOutlet UITextView *txtDescricao;
@property (weak, nonatomic) IBOutlet UILabel *lblData;
@end
