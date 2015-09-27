//
//  main.m
//  ClassMatrix
//
//  Created by Admin on 13.09.15.
//  Copyright (c) 2015 Olha Fizer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OFMatrix.h"
#import "OFCalculator.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //Create 2 random matrices
        OFMatrix * matrix1 = [[OFMatrix alloc] initWithRandomNumbersAndCapacity:5];
        NSLog(@"First random matrix");
        [matrix1 description];
        
        OFMatrix * matrix2 = [[OFMatrix alloc] initWithRandomNumbersAndCapacity:5];
        NSLog(@"Second random matrix");
        [matrix2 description];
         
        //create matrix calculator
        OFCalculator * calculator = [[OFCalculator alloc] init];
        
        NSLog(@"First and Second matrices are equal? - %@",
                  [matrix1 isEqualTo:matrix2]? @"YES":@"NO");
        
        OFMatrix * someCopy = [matrix2 copy];
        NSLog(@"Matrix and its copy are equal? - %@",
                   [someCopy isEqualTo:matrix2]?@"YES":@"NO");
        
        //perform operations with matrix calculator
        [calculator addMatrix1:matrix1 AndMatrix2:matrix2 withBlockCallback:^(OFMatrix* sumMatrix)
         {
             NSLog(@"Sum of 2 matrices:");
             [sumMatrix description];
         }];
        
        [calculator subtractMatrix1:matrix1 WithMatrix2:matrix2 withBlockCallback:^(OFMatrix * subtractedMatrix) {
               NSLog(@"Subtracted matrix:");
               [subtractedMatrix description];
            }];
        
        
        [calculator multiplyMatrix1:matrix1 AndMatrix2:matrix2 withBlockCallback:^(OFMatrix * multiplicationResult) {
            NSLog(@"Product of 2 matrices:");
            [multiplicationResult description];
        }];
              

        [calculator multiplyMatrix:matrix1 ByNumber:15 withBlockCallback:^(OFMatrix * multiplResult) {
            NSLog(@"Matrix multiplied by 15:");
            [multiplResult description];
        }];
    
        [calculator inverseMatrix:matrix2 withBlockCallback:^(OFMatrix * inversed) {
            NSLog(@"Ineversed matrix:");
            [inversed description];
        }];
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
