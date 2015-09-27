//
//  OFMatrix.h
//  ClassMatrix
//
//  Created by Admin on 13.09.15.
//  Copyright (c) 2015 Olha Fizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFMatrix : NSObject <NSCopying>

@property (strong, nonatomic) NSMutableArray * matrixItem;
@property (assign, nonatomic) NSUInteger sizeOfMatrix;

- (id) initWithCapacity: (NSUInteger) capacity;
- (id) initWithRandomNumbersAndCapacity: (NSUInteger) capacity;
- (id) initWithMatrix: (OFMatrix*) someMatrix;

- (void) description;
- (BOOL) isEqualTo:(OFMatrix*)someMatrix;

@end
