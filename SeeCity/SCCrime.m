//
//  SCCrime.m
//  SeeCity
//
//  Created by its4-Desenvolvimento on 11/02/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCCrime.h"

@implementation SCCrime
+ (SCCrime *) parseCrime:(NSDictionary *)dictionary;
{
    NSLog(@"dictionary %@",[dictionary description]);
    SCCrime *crime = [[SCCrime alloc] init];
    
    crime._id = [dictionary objectForKey:@"_id"];
    crime.categoria = [dictionary objectForKey:@"categoria"];
    crime.descricao = [dictionary objectForKey:@"descricao"];
    crime.localizacao = [dictionary objectForKey:@"localizacao"];
    crime.usuario = [dictionary objectForKey:@"usuario"];
    crime.data = [dictionary objectForKey:@"data"];
    crime.agradecimento = [dictionary objectForKey:@"agradecimento"];
    return crime;
}


@end
