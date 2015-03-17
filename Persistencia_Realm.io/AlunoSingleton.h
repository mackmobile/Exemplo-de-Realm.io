//
//  AlunoSingleton.h
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

@interface AlunoSingleton : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (AlunoSingleton*)sharedInstance;

@end
