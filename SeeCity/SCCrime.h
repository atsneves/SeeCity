//
//  SCCrime.h
//  SeeCity
//
//  Created by its4-Desenvolvimento on 11/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCrime : NSObject

@property (nonatomic,strong) NSString *_id;
@property (nonatomic,strong) NSString *categoria;
@property (nonatomic,strong) NSString *descricao;
@property (nonatomic,strong) NSArray *localizacao;
@property (nonatomic,strong) NSString *usuario;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *agradecimento;
@property (nonatomic,strong) NSString *comentarios;

+ (SCCrime *) parseCrime:(NSDictionary *)dictionary;

@end
