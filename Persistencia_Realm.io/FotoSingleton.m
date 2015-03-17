//
//  FotoSingleton.m
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "FotoSingleton.h"

@implementation FotoSingleton

static FotoSingleton *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

-(void)salvarFoto:(UIImage *)foto comNome:(NSString *)nome {
    // Criando caminho
    NSString *fileName = [NSString stringWithFormat:@"%@.png", nome];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    // Salvando a imagem no formato PNG
    [UIImagePNGRepresentation(foto) writeToFile:filePath atomically:YES];
}

-(UIImage *)recuperarFotoComNome:(NSString *)nome {
    // Criando caminho
    NSString *fileName = [NSString stringWithFormat:@"%@.png", nome];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    // Recuperando foto
    return [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[FotoSingleton alloc] init];
}

- (id)mutableCopy
{
    return [[FotoSingleton alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}


@end
