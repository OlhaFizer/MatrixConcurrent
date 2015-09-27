//
//  OFCalculator.h
//  ClassMatrix
//
//  Created by Admin on 19.09.15.
//  Copyright (c) 2015 Olha Fizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OFMatrix;

typedef void (^MatrixBlock)(OFMatrix*);

@interface OFCalculator : NSObject

- (void) addMatrix1: (OFMatrix*)matrixOne AndMatrix2: (OFMatrix*)matrixTwo
       withBlockCallback: (MatrixBlock)callBack;
- (void) subtractMatrix1: (OFMatrix*)matrixOne WithMatrix2: (OFMatrix*)matrixTwo withBlockCallback: (MatrixBlock)callBack;
- (void) multiplyMatrix1: (OFMatrix*)matrixOne AndMatrix2: (OFMatrix*)matrixTwo withBlockCallback: (MatrixBlock)callBack;
- (void) multiplyMatrix: (OFMatrix*) someMatrix ByNumber: (NSInteger) someNumber withBlockCallback: (MatrixBlock)callBack;
- (void) inverseMatrix: (OFMatrix*) someMatrix withBlockCallback: (MatrixBlock)callBack;

@end
