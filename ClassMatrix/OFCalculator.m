//
//  OFCalculator.m
//  ClassMatrix
//
//  Created by Admin on 19.09.15.
//  Copyright (c) 2015 Olha Fizer. All rights reserved.
//

#import "OFCalculator.h"
#import "OFMatrix.h"

dispatch_queue_t myQueue(){
static dispatch_queue_t myQueue;
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
});
    return myQueue;
}


@implementation OFCalculator

- (void) addMatrix1: (OFMatrix*) matrixOne AndMatrix2: (OFMatrix*) matrixTwo withBlockCallback: (MatrixBlock)callBack
{
    dispatch_group_t addGroup = dispatch_group_create();
    if (matrixOne.sizeOfMatrix == matrixTwo.sizeOfMatrix)
    {
        OFMatrix* matrixAfterSum = [[OFMatrix alloc]
                                    initWithCapacity:matrixOne.sizeOfMatrix];
        for (NSUInteger i=0; i < matrixOne.sizeOfMatrix; i++)
        {
            for (NSUInteger j=0; j < matrixOne.sizeOfMatrix; j++)
            {
              dispatch_group_async(addGroup, myQueue(), ^{
                  matrixAfterSum.matrixItem[i][j] = @([matrixOne.matrixItem[i][j] integerValue]+
                  [matrixTwo.matrixItem[i][j] integerValue]);
                  //NSLog(@"Adding %@", [NSThread currentThread]);
              });
            }
        }
        dispatch_group_wait(addGroup, DISPATCH_TIME_FOREVER);
        callBack(matrixAfterSum);
    }
    else
    {
        NSLog(@"Size of two matrices is inappropriate. They can't be added.");
        callBack(nil);
    }
}

- (void) subtractMatrix1: (OFMatrix*) matrixOne WithMatrix2: (OFMatrix*) matrixTwo withBlockCallback: (MatrixBlock)callBack
{
    dispatch_group_t subrtGroup = dispatch_group_create();
    if (matrixOne.sizeOfMatrix == matrixTwo.sizeOfMatrix)
    {
        OFMatrix* matrixAfterSubtraction = [[OFMatrix alloc]
                                    initWithCapacity:matrixOne.sizeOfMatrix];
        for (NSUInteger i=0; i < matrixOne.sizeOfMatrix; i++)
        {
           for (NSUInteger j=0; j < matrixOne.sizeOfMatrix; j++)
           {
                dispatch_group_async(subrtGroup,myQueue(), ^{
                    matrixAfterSubtraction.matrixItem[i][j] = @([matrixOne.matrixItem[i][j] integerValue]-
                    [matrixTwo.matrixItem[i][j] integerValue]);
                    //NSLog(@"Subtract %@", [NSThread currentThread]);
                });
              
            }
        }
        dispatch_group_wait(subrtGroup, DISPATCH_TIME_FOREVER);
        callBack(matrixAfterSubtraction);
    }
    else
    {
        NSLog(@"Size of two matrices is inappropriate. They can't be subtracted.");
        callBack(nil);
    }
}

- (void) multiplyMatrix1: (OFMatrix*) matrixOne AndMatrix2: (OFMatrix*) matrixTwo withBlockCallback: (MatrixBlock)callBack
{
    dispatch_group_t multGroup = dispatch_group_create();
    if (matrixOne.sizeOfMatrix == matrixTwo.sizeOfMatrix)
    {
        OFMatrix* matrixAfterMultiplication = [[OFMatrix alloc]
                                               initWithCapacity:matrixOne.sizeOfMatrix];
        for (NSUInteger k=0; k < matrixOne.sizeOfMatrix; k++)
        {
            for (NSUInteger i=0; i < matrixOne.sizeOfMatrix; i++)
            {
                dispatch_group_async(multGroup, myQueue(), ^{
                    //NSLog(@"MultM %@", [NSThread currentThread]);
                    NSInteger sum = 0;
                    for (NSUInteger j=0; j < matrixOne.sizeOfMatrix; j++)
                    {
                        sum+=[matrixOne.matrixItem[k][j] integerValue]*
                        [matrixTwo.matrixItem[j][i] integerValue];
                    }
                    matrixAfterMultiplication.matrixItem[k][i]=@(sum);
                });
            }
            
        }
        dispatch_group_wait(multGroup, DISPATCH_TIME_FOREVER);
        callBack(matrixAfterMultiplication);
    }
    else
    {
        NSLog(@"Size of two matrices is inappropriate. They can't be multiplied.");
        callBack(nil);
    }
}

- (void) multiplyMatrix: (OFMatrix*) someMatrix ByNumber: (NSInteger) someNumber withBlockCallback: (MatrixBlock)callBack
{
    dispatch_group_t multGroup = dispatch_group_create();
    OFMatrix* matrixAfterMultiplication =
    [[OFMatrix alloc]initWithCapacity:someMatrix.sizeOfMatrix];
    for (NSUInteger i=0; i < someMatrix.sizeOfMatrix; i++)
    {
        for (NSUInteger j=0; j < someMatrix.sizeOfMatrix; j++)
        {
            dispatch_group_async(multGroup, myQueue(), ^{
                matrixAfterMultiplication.matrixItem[i][j] =
                @([someMatrix.matrixItem[i][j] integerValue]*someNumber);
                //NSLog(@"MultNum %@", [NSThread currentThread]);
            });
            
        }
    }
    dispatch_group_wait(multGroup, DISPATCH_TIME_FOREVER);
    callBack(matrixAfterMultiplication);
}

- (void) inverseMatrix: (OFMatrix*) someMatrix withBlockCallback: (MatrixBlock)callBack
{
    OFMatrix* mutableCopyOfMatrix = [[OFMatrix alloc]initWithMatrix:someMatrix];
    
    dispatch_group_t replaceGroup = dispatch_group_create();
    dispatch_group_t divGroup = dispatch_group_create();
    dispatch_group_t multGroup = dispatch_group_create();
    
    for (NSUInteger i=0; i < someMatrix.sizeOfMatrix; i++)
    {
        if (fabs([mutableCopyOfMatrix.matrixItem[i][i] intValue]) == 0)
        {
            __block BOOL replaced = NO;
            for (NSUInteger j=i+1; j < someMatrix.sizeOfMatrix; j++)
            {
                if (fabs([mutableCopyOfMatrix.matrixItem[j][i] intValue]) > 0)
                {
                    dispatch_group_async(replaceGroup, myQueue(), ^{
                        NSNumber * temporary = mutableCopyOfMatrix.matrixItem[i];
                        mutableCopyOfMatrix.matrixItem[i]=mutableCopyOfMatrix.matrixItem[j];
                        mutableCopyOfMatrix.matrixItem[j]=temporary;
                        //NSLog(@"InvReplace %@", [NSThread currentThread]);
                        replaced = YES;
                    });
                    
                    break;
                }
            }
            dispatch_group_wait(replaceGroup, DISPATCH_TIME_FOREVER);
            if (!replaced)
            {
               NSLog(@"This matrix can't be inversed");
               callBack(nil);
            }
        }
        
        double division = [mutableCopyOfMatrix.matrixItem[i][i] doubleValue];
        for (NSUInteger m=0; m < someMatrix.sizeOfMatrix; m++)
        {
            dispatch_group_async(divGroup, myQueue(), ^{
                mutableCopyOfMatrix.matrixItem[i][m]=
                @([mutableCopyOfMatrix.matrixItem[i][m] doubleValue] / division);
                //NSLog(@"InvDiv %@", [NSThread currentThread]);
            });
            
        }
        dispatch_group_wait(divGroup, DISPATCH_TIME_FOREVER);
        
        for (NSUInteger j=i+1; j < someMatrix.sizeOfMatrix; j++)
        {
            double multiply = [mutableCopyOfMatrix.matrixItem[j][i] doubleValue];
            for (NSUInteger m=0; m < someMatrix.sizeOfMatrix; m++)
            {
                dispatch_group_async(multGroup, myQueue(), ^{
                    mutableCopyOfMatrix.matrixItem[j][m]=
                    @([mutableCopyOfMatrix.matrixItem[j][m] doubleValue]-
                    (multiply*[mutableCopyOfMatrix.matrixItem[i][m] doubleValue]));
                    //NSLog(@"InvMultSub %@", [NSThread currentThread]);
                });
                
            }
        }
        dispatch_group_wait(multGroup, DISPATCH_TIME_FOREVER);
    }

    dispatch_group_t subtractGroup = dispatch_group_create();
    for (NSUInteger i = someMatrix.sizeOfMatrix - 1; i > 0; i--)
    {
        for (NSUInteger j = i - 1; j+1>0; j--)
        {
            double multiply = [mutableCopyOfMatrix.matrixItem[j][i] doubleValue];
            for (NSUInteger m=0; m < someMatrix.sizeOfMatrix; m++)
            {
                dispatch_group_async(subtractGroup, myQueue(), ^{
                    mutableCopyOfMatrix.matrixItem[j][m]=
                    @([mutableCopyOfMatrix.matrixItem[j][m] doubleValue]-
                    (multiply*[mutableCopyOfMatrix.matrixItem[i][m] doubleValue]));
                    //NSLog(@"InvSubtr %@", [NSThread currentThread]);
                });
                
            }
        }
    }
    dispatch_group_wait(subtractGroup, DISPATCH_TIME_FOREVER);
    callBack(mutableCopyOfMatrix);
}

@end
