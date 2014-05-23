//
//  SCDelegaciaTableViewCell.h
//  SeeCity
//
//  Created by Anderson Neves on 23/05/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDelegaciaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nome;

@property (weak, nonatomic) IBOutlet UILabel *distancia;
@property (weak, nonatomic) IBOutlet UILabel *endereco;
@end
