//
//  OFMatrix.m
//  ClassMatrix
//
//  Created by Admin on 13.09.15.
//  Copyright (c) 2015 Olha Fizer. All rights reserved.
//

#import "OFMatrix.h"
#import <stdlib.h>

@implementation OFMatrix
@synthesize matrixItem=_matrixItem;
@synthesize sizeOfMatrix=_sizeOfMatrix;

- (id) initWithCapacity: (NSUInteger) capacity
{
    self = [super init];
    if (self)
    {
        _sizeOfMatrix = capacity;
        _matrixItem = [[NSMutableArray alloc] initWithCapacity:_sizeOfMatrix];
        for (NSUInteger i=0; i < _sizeOfMatrix; i++)
        {
            _matrixItem[i]=[[NSMutableArray alloc] initWithCapacity:_sizeOfMatrix];
            for (NSUInteger j=0; j < _sizeOfMatrix; j++)
            {
                [_matrixItem[i] addObject:@0];
            }
        }
    }
    return self;
}

- (id) initWithRandomNumbersAndCapacity: (NSUInteger) capacity
{
    self = [super init];
    if (self)
    {
        self = [self initWithCapacity:capacity];
        for (NSUInteger i=0; i < self.sizeOfMatrix; i++)
        {
            for (NSUInteger j=0; j < self.sizeOfMatrix; j++)
            {
                self.matrixItem[i][j]=@(arc4random_uniform(10));
            }
        }
    }
    return self;
}

- (id) initWithMatrix: (OFMatrix*) someMatrix
{
    self = [super init];
    if (self)
    {
        self = [self initWithCapacity:someMatrix.sizeOfMatrix];
        for (NSUInteger i=0; i < self.sizeOfMatrix; i++)
        {
            for (NSUInteger j=0; j < self.sizeOfMatrix; j++)
            {
                self.matrixItem[i][j]=[someMatrix.matrixItem[i][j] copy];
            }
        }
        
    }
    return self;
}


-(void) description
{
    for (NSUInteger i=0 ; i < self.sizeOfMatrix; i++)
    {
        NSString * rowString = [[NSString alloc]init];
        for (NSUInteger j=0; j < self.sizeOfMatrix; j++)
        {
            rowString=[rowString stringByAppendingString:[NSString stringWithFormat:@"%ld ",[self.matrixItem[i][j] integerValue]]];
        }
        NSLog(@"%@",[rowString stringByAppendingString:@"\n"]);
    }
}

- (BOOL) isEqualTo:(OFMatrix*)someMatrix
{
    if (self.sizeOfMatrix == someMatrix.sizeOfMatrix)
    {
        for (NSUInteger i=0; i < self.sizeOfMatrix; i++)
        {
            for (NSUInteger j=0; j < self.sizeOfMatrix; j++)
            {
                if (self.matrixItem[i][j] != someMatrix.matrixItem[i][j])
                {
                    return NO;
                }
               
            }
        }
        return YES;
    }
    else return NO;
}


#pragma mark - NSCopying
- (id) copyWithZone:(NSZone *)zone
{
    OFMatrix * copyOfMatrix = [[OFMatrix alloc] initWithMatrix:self];
    return copyOfMatrix;
}

@end
