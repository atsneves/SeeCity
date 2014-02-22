//
//  SCUsuario.m
//  SeeCity
//
//  Created by its4-Desenvolvimento on 11/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCUsuario.h"

@implementation SCUsuario
+ (SCUsuario *) parseUsuario:(NSDictionary *)dictionary
{
    NSLog(@"dictionary %@",[dictionary description]);
    SCUsuario *usuario = [[SCUsuario alloc] init];
    
    usuario._id = [dictionary objectForKey:@"_id"];
    usuario.cidade = [dictionary objectForKey:@"cidade"];
    usuario.data_inicio = [dictionary objectForKey:@"data_inicio"];
    usuario.email = [dictionary objectForKey:@"email"];
    usuario.nome = [dictionary objectForKey:@"nome"];
    usuario.senha = [dictionary objectForKey:@"senha"];
    usuario.situacao = [dictionary objectForKey:@"situacao"];
    usuario.tipo = [dictionary objectForKey:@"usuario"];
    usuario.usuario = [dictionary objectForKey:@"usuario"];
    
    return usuario;
}
@end
