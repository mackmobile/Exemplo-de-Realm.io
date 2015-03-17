//
//  FotoSingleton.h
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FotoSingleton : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (FotoSingleton*)sharedInstance;

- (void)salvarFoto:(UIImage *)foto comNome:(NSString *)nome;
- (UIImage *)recuperarFotoComNome:(NSString *)nome;

@end
