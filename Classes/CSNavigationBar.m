//
//  CSNavigationBar.m
//  CreateSend
//
//  Created by Nathan de Vries on 30/03/12.
//  Copyright (c) 2012 Nathan de Vries. All rights reserved.
//

#import "CSNavigationBar.h"

@implementation CSNavigationBar

- (void)drawRect:(CGRect)rect {
  UIImage* navigationBarBackground = [UIImage imageNamed:@"CSNavigationBar-Background.png"];
  [navigationBarBackground drawInRect:rect];
}

@end
