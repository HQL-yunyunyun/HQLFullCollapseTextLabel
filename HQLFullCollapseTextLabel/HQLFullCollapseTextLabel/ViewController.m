//
//  ViewController.m
//  HQLFullCollapseTextLabel
//
//  Created by weplus on 2017/7/6.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "ViewController.h"

#import "UILabel+FullCollapseTextButton.h"

#import "TextLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *text = @"超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string，超级超级超级长的string";
<<<<<<< Updated upstream
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    label.labelFrameDidChangeBlock = ^(CGRect labelFrame) {
        NSLog(@"labelFrame %@", NSStringFromCGRect(labelFrame));
    };
=======
    TextLabel *label = [[TextLabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
>>>>>>> Stashed changes
    [label setFont:[UIFont systemFontOfSize:12]];
    label.numberOfCollapseLines = 2;
    [label setText:text];
    [self.view addSubview:label];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
