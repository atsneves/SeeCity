//
//  AKMeme.m
//  AKLookups
//
//  Created by Andrey Kadochnikov on 17.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "TipoListagem.h"

@implementation TipoListagem
+(TipoListagem*)memeWithTitle:(NSString*)title imageName:(NSString*)imageName
{
	TipoListagem* tipoList = [TipoListagem new];
	tipoList.lookupTitle = title;
	tipoList.imageName = imageName;
	return tipoList;
}
@end
