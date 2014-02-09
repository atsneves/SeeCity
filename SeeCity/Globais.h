//
//  Globais.h
//  OnlineBook
//
//  Created by Anderson Neves on 14/11/12.
//  Copyright (c) 2012 Agneves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
@interface Globais : NSObject


@property (nonatomic,strong) NSMutableArray *dadosFacebook;

@property (nonatomic,strong) NSMutableArray *crimes;

@property (nonatomic,strong) NSString *caminhoArq;

@property (nonatomic,strong) NSString *caminhoArqCrime;

@property (nonatomic,strong) NSDictionary *userLogado;

+(Globais*)shared;


@end
