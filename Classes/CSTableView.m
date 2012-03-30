//
//  CSTableView.m
//  CreateSend
//
//  Created by Nathan de Vries on 30/03/12.
//  Copyright (c) 2012 Nathan de Vries. All rights reserved.
//

#import "CSTableView.h"
#import <QuartzCore/QuartzCore.h>

@interface CSTableView ()
@property (nonatomic, retain, readwrite) CALayer* scrollingBackgroundLayer;
@end

@implementation CSTableView

@synthesize scrollingBackgroundLayer=_scrollingBackgroundLayer;

- (void)layoutSubviews {
  [super layoutSubviews];
  
  if (!self.scrollingBackgroundLayer) {
    self.scrollingBackgroundLayer = [CALayer layer];
    self.scrollingBackgroundLayer.backgroundColor = [UIColor colorWithWhite:0.961f alpha:1.f].CGColor; // #F5F5F5
    self.scrollingBackgroundLayer.cornerRadius = 8.f;
    self.scrollingBackgroundLayer.borderColor = [UIColor colorWithWhite:0.867f alpha:1.f].CGColor; // #DDD
    self.scrollingBackgroundLayer.borderWidth = 1.f;
  }
  
  [self.layer insertSublayer:self.scrollingBackgroundLayer atIndex:0];
  self.scrollingBackgroundLayer.frame = CGRectMake(0.f, 10.f, self.contentSize.width, self.contentSize.height - 10.f);
}

- (void)dealloc {
  [_scrollingBackgroundLayer release];
  
  [super dealloc];
}

@end
