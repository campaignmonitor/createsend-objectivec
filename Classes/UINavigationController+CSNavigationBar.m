//
//  UINavigationController+CSNavigationBar.m
//  CreateSend
//
//  Created by Nathan de Vries on 30/03/12.
//  Copyright (c) 2012 Nathan de Vries. All rights reserved.
//

#import "UINavigationController+CSNavigationBar.h"
#import "CSNavigationBar.h"

@implementation UINavigationController (CSNavigationBar)

- (id)initWithRootViewController:(UIViewController *)rootViewController
       applyCSNavigationBarStyle:(BOOL)applyCSNavigationBarStyle {
  
  if (applyCSNavigationBarStyle == NO)
    return [self initWithRootViewController:rootViewController];
  
  if ((self = [self initWithRootViewController:rootViewController])) {
    NSKeyedUnarchiver* unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:[NSKeyedArchiver archivedDataWithRootObject:self]] autorelease];
    [unarchiver setClass:[CSNavigationBar class] forClassName:@"UINavigationBar"];
    self = [[unarchiver decodeObjectForKey:@"root"] retain];
    
    [self setViewControllers:[NSArray arrayWithObject:rootViewController]];
  }
  
  return self;  
}

+ (id)controllerWithRootViewController:(UIViewController *)rootViewController
             applyCSNavigationBarStyle:(BOOL)applyCSNavigationBarStyle {
  
  return [[[self alloc] initWithRootViewController:rootViewController
                         applyCSNavigationBarStyle:applyCSNavigationBarStyle] autorelease];
}

@end
