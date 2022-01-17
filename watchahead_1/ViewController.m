//
//  ViewController.m
//  watchahead_1
//
//  Created by Ziyu.Wang on 05/03/2016.
//  Copyright © 2016 Ziyu.Wang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController (){

    AVAudioPlayer *alarm;       // declare an audio player named alarm
    __weak IBOutlet UILabel *displaydistance;

}


@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add an audio to this file
    NSString *path = [NSString stringWithFormat:@"%@/lockcar.mp3", [[NSBundle mainBundle] resourcePath]];       //the path of obtaining the audio
    NSURL *alarmURL = [NSURL fileURLWithPath:path];
    alarm = [[AVAudioPlayer alloc] initWithContentsOfURL:alarmURL error:nil];       //add the audio to a pointer
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takephoto:(id)sender {
    
    //take a picture
    picker = [[UIImagePickerController alloc] init];        //declare a picker
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:NULL];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //process that picture
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];            //set the captured picture as "image"
    [PhotoView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    float pointperrow = 425;        //set the resolution
    float pointperline = 625;
    
    //get the RGB values of that picture
    NSMutableArray *picRGB = [NSMutableArray new];      //set an array to represent the RGB value of an image
    CGImageRef Refimage = [image CGImage];      //set the captured picture as the reference image
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData= (unsigned char*) calloc(pointperrow * pointperline * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * pointperrow;
    NSUInteger bitsPerComponent = 8;
    CGContextRef contest = CGBitmapContextCreate(rawData, pointperrow, pointperline, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast |kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(contest, CGRectMake(0, 0, pointperrow, pointperline), Refimage);
    CGContextRelease(contest);
    
    float x = 0;
    float y = 0;
    //int e = 0;
    int r = 0;
    float vx0 = 0;      //the position on x axis of the first red point
    float vxd = 0;      //the distance between the first and the last red point
    int danger = 0;
    int al = 0;
    int dis = 0;
    
    for (int n = 0; n<(pointperrow * pointperline); n++) {
        int indext  = (bytesPerRow * y) + bytesPerPixel * x;
        int red     = rawData[indext];
        int green   = rawData[indext + 1];
        int blue    = rawData[indext + 2];
        int alpha   = rawData[indext + 3];
        NSArray * a = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i", red], [NSString stringWithFormat:@"%i",green], [NSString stringWithFormat:@"%i", blue], [NSString stringWithFormat:@"%i",alpha], nil];        //the first number in that array is represent the red componen, the second is green, the third one is for blue and the last one is for transparance
        
        //set the constrings of red colour
        if (red >= 125) {
            if (green <= 50) {
                if (blue <= 50) {
                    //NSLog(@"the position of this red point is ( %.0f, %.0f)", x, y);
                    //e++;
                    r++;        //if there is a new red point in this line, r will plus 1
                    if (r == 1) {
                        vx0 = x;
                    }
                    //vxd = al;
                    //vxd = 0;
                    vxd = x - vx0 + 1;          //vxd represent the longest pixel width of red items in this line
                    if (vxd >= al) {
                        al = vxd;
                    }
                    
                }
                
            }
            
        }
        
        
        [picRGB addObject:a];
        x++;
        if (x == pointperrow) {
            if (r > 1) {
                //NSLog(@" the pixelwidth between the first and the last red point in %.0f row is %.0f pixel" ,y, vxd);
                //NSLog(@" up till now, the biggest pixel width is %i", al);
            }
            if (vxd >= 23) {
                danger++;
            }
            r = 0;
            x = 0;
            y++;
        }
        
    }
    
    dis = 580/al;       //this formular is obtained according to the Thin Lens Equation and the real resolution of the image
    displaydistance.text = [NSString stringWithFormat:@"Distance: %dm", dis];
    //log out RGB value of all points in the picture
    //NSLog(@"%@", picRGB);
    //log out the number of red points in the picture
//    if (e > 0) {
//        NSLog(@"There are %i red colour points.", e);
//    }
//    else{
//        NSLog(@"There is no red point in this picture.");
//    }
    
    
    // make decision whether to give an alarm
    if (dis >= 25) {
        //NSLog(@"hh");
        
        [alarm play];
    }
    
    free(rawData);
    
    //return image;
    
}
//-(void)diplaydistance:(int)danger{
//    
//    self->displaydistance.text = [NSString stringWithFormat:@"Distance: %i", danger];
//}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
