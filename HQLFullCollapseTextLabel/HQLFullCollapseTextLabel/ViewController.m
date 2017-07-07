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

@property (strong, nonatomic) TextLabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *text = @"这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string";
    TextLabel *label = [[TextLabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    label.labelFrameDidChangeBlock = ^(CGRect labelFrame, CGRect buttonFrame, CGRect totalFrame) {
        NSLog(@"labelFrame %@, buttonFrame %@ totalFrame %@", NSStringFromCGRect(labelFrame), NSStringFromCGRect(buttonFrame), NSStringFromCGRect(totalFrame));
    };
    [label setFont:[UIFont systemFontOfSize:12]];
    label.numberOfCollapseLines = 2;
    [label setText:text];
    [self.view addSubview:label];
    self.label = label;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap {
    static int count = 1;
    if (count % 2 == 0) {
        NSString *text = @"这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string 这是一个超级超级超级长的string";
        [self.label setText:text];
    } else {
        [self.label setText:@"超级短"];
    }
    count++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
