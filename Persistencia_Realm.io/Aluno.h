//
//  Aluno.h
//  Persistencia_Realm.io
//
//  Created by joaquim on 16/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface Aluno : RLMObject

@property (nonatomic, strong) NSString *nome;
@property (nonatomic, strong) NSString *tia;

@end
