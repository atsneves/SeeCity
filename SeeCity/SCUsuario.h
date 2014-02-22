//
//  SCUsuario.h
//  SeeCity
//
//  Created by its4-Desenvolvimento on 11/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCUsuario : NSObject

@property (nonatomic,strong) NSString *_id;
@property (nonatomic,strong) NSString *cidade;
@property (nonatomic,strong) NSString *data_inicio;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *nome;
@property (nonatomic,strong) NSString *senha;
@property (nonatomic,strong) NSString *situacao;
@property (nonatomic,strong) NSString *tipo;
@property (nonatomic,strong) NSString *usuario;



+ (SCUsuario *) parseUsuario:(NSDictionary *)dictionary;

@end
