//
//  ViewController.m
//  LameDemo
//
//  Created by ForC on 2022/1/28.
//

#import "ViewController.h"
#import "MP3Encoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    DemoViewController *vc = [[DemoViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    
    NSString *pcm = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"16k.pcm"];
    NSString *mp3 = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"demo.mp3"];
    MP3Encode encode = MP3Encode(pcm.UTF8String, mp3.UTF8String, 44100, 2, 8);
    encode.Encode();
}

@end
