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
+ (NSDate *)dateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    
	NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    
	[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
	[rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	// Convert the RFC 3339 date time string to an NSDate.
	NSDate *result = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
	return result;
}
+ (NSDictionary*)buscaCategoria:(NSString*)ide
{
    NSArray *arCategoria = [[NSMutableArray alloc] initWithArray:@[@{@"descricao":@"Furto",@"imagem":@"furto.png",@"categoria":@"FURTO"},@{@"descricao":@"Assalto",@"imagem":@"assalto.png",@"categoria":@"ASSALTO"},@{@"descricao":@"Assalto em Curso",@"imagem":@"assaltoemcurso.png",@"categoria":@"ASSALTOCURSO"},@{@"descricao":@"Disparo de Alarme",@"imagem":@"disparodealarme.png",@"categoria":@"ALARME"},@{@"descricao":@"Atividade Suspeita",@"imagem":@"suspeita.png",@"categoria":@"ATIVIDADE"},@{@"descricao":@"Acidente",@"imagem":@"acidente.png",@"categoria":@"ACIDENTE"},@{@"descricao":@"Atentado ao pudor",@"imagem":@"atentado.png",@"categoria":@"ATENTADOPUDOR"},@{@"descricao":@"Comércio e uso de drogas",@"imagem":@"comercio.png",@"categoria":@"DROGAS"},@{@"descricao":@"Arrombamento",@"imagem":@"arrombamento.png",@"categoria":@"ARROMBAMENTO"},@{@"descricao":@"Sequesto Relâmpago",@"imagem":@"sequestro.png",@"categoria":@"SEQUESTRORELAMPAGO"},@{@"descricao":@"Arrastão",@"imagem":@"arrastao.png",@"categoria":@"ARRASTAO"}]];
    
    
    NSArray *filteredarray = [arCategoria filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"categoria = %@", ide]];
    
    NSLog(@"filteredarray %@",[filteredarray description]);
    
    if (filteredarray.count > 0) {
        return [filteredarray objectAtIndex:0];
    }
    else
    {
        return nil;
    }
    
}
- (NSDate *)dateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    
	NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    
	[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
	[rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	// Convert the RFC 3339 date time string to an NSDate.
	NSDate *result = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
	return result;
}

@end
