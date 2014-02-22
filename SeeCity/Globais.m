//
//  Globais.m
//  OnlineBook
//
//  Created by Anderson Neves on 14/11/12.
//  Copyright (c) 2012 Agneves. All rights reserved.
//

#import "Globais.h"

@implementation Globais


static Globais *compatilhada;


+(Globais*)shared{
    if (compatilhada == nil)
    {
        compatilhada = [[self alloc] init];
    }
    
    return compatilhada;

}

-(id)init{

    self = [super init];
    if (self) {
        
        _caminhoArq = [NSHomeDirectory() stringByAppendingString:@"/Documents/usuariosface.plist"];
        
        _caminhoArqCrime = [NSHomeDirectory() stringByAppendingString:@"/Documents/crimes.plist"];
        
        NSFileManager *gerenciadorArquivos = [NSFileManager defaultManager];
        
        
        if ([gerenciadorArquivos fileExistsAtPath:_caminhoArq]) {
            //carregar
            NSLog(@"Executou o dir %@",NSHomeDirectory());
        }
        else{
            //instanciar array
            NSLog(@"Executou o dir %@",NSHomeDirectory());
        }
        
        
        if ([gerenciadorArquivos fileExistsAtPath:_caminhoArqCrime]) {
            //carregar
            NSLog(@"Executou o dir %@",NSHomeDirectory());
            _crimes = [[NSMutableArray alloc] initWithContentsOfFile:_caminhoArqCrime];
        }
        else{
            //instanciar array
            NSLog(@"Executou o dir %@",NSHomeDirectory());
            _crimes = [[NSMutableArray alloc] init];
            
        }
        
        
        
        
    }
    return self;
}


@end
