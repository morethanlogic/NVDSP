//
//  ViewController.m
//  NVDSPExample
//
//  Created by Bart Olsthoorn on 25/04/2013.
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "ViewController.h"

#import "smbPitchShifter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    ringBuffer = new RingBuffer(32768, 2);
    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    
    // Init filters.
    bpf = [[NVBandpassFilter alloc] initWithSamplingRate:samplingRate];
    bpqf = [[NVBandpassQPeakGainFilter alloc] initWithSamplingRate:samplingRate];
    hpf = [[NVHighpassFilter alloc] initWithSamplingRate:samplingRate];
    hsf = [[NVHighShelvingFilter alloc] initWithSamplingRate:samplingRate];
    lpf = [[NVLowpassFilter alloc] initWithSamplingRate:samplingRate];
    lsf = [[NVLowShelvingFilter alloc] initWithSamplingRate:samplingRate];
    nf = [[NVNotchFilter alloc] initWithSamplingRate:samplingRate];
    peqf = [[NVPeakingEQFilter alloc] initWithSamplingRate:samplingRate];
    
    _bpf_on = NO;
    _bpqf_on = NO;
    _hpf_on = NO;
    _hsf_on = NO;
    _lpf_on = NO;
    _lsf_on = NO;
    _nf_on = NO;
    _peqf_on = NO;
    _ps_on = NO;
    
    _bpf_centerFrequency = 2000.0f;
    _bpqf_centerFrequency = 2000.0f;
    _hpf_cornerFrequency = 2000.0f;
    _hsf_centerFrequency = 2000.0f;
    _lpf_cornerFrequency = 2000.0f;
    _lsf_centerFrequency = 2000.0f;
    _nf_centerFrequency = 2000.0f;
    _peqf_centerFrequency = 2000.0f;

    _bpf_Q = 0.5f;
    _bpqf_Q = 0.5f;
    _hpf_Q = 0.5f;
    _hsf_Q = 0.5f;
    _hsf_G = 0.5f;
    _lpf_Q = 0.5f;
    _lsf_Q = 0.5f;
    _lsf_G = 0.5f;
    _nf_Q = 0.5f;
    _peqf_Q = 0.5f;
    _peqf_G = 0.5f;
    
    _ps_semitones = 0.0f;
        
    [self playSound];
    
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         if (![fileReader playing]) {
             [self playSound];
             
             NSLog(@"No play %@", fileReader);
         }
         else {
             [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
             //NSLog(@"Time: %f", fileReader.currentTime);
             
             if (_bpf_on) {
                 bpf.centerFrequency = _bpf_centerFrequency;
                 bpf.Q = _bpf_Q;
                 [bpf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_bpqf_on) {
                 bpqf.centerFrequency = _bpqf_centerFrequency;
                 bpqf.Q = _bpqf_Q;
                 [bpqf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_hpf_on) {
                 hpf.cornerFrequency = _hpf_cornerFrequency;
                 hpf.Q = _hpf_Q;
                 [hpf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_hsf_on) {
                 hsf.centerFrequency = _hsf_centerFrequency;
                 hsf.Q = _hsf_Q;
                 hsf.G = _hsf_G;
                 [hsf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_lpf_on) {
                 lpf.cornerFrequency = _lpf_cornerFrequency;
                 lpf.Q = _hpf_Q;
                 [lpf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_lsf_on) {
                 lsf.centerFrequency = _lsf_centerFrequency;
                 lsf.Q = _lsf_Q;
                 lsf.G = _lsf_G;
                 [lsf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_nf_on) {
                 nf.centerFrequency = _nf_centerFrequency;
                 nf.Q = _hpf_Q;
                 [nf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_peqf_on) {
                 peqf.centerFrequency = _peqf_centerFrequency;
                 peqf.Q = _peqf_Q;
                 peqf.G = _peqf_G;
                 [peqf filterData:data numFrames:numFrames numChannels:numChannels];
             }
             
             if (_ps_on) {
                 float pitchShift = pow(2.0, _ps_semitones / 12.0);
                 smbPitchShifter::smbPitchShift(pitchShift, (long)numFrames, 512, 4, samplingRate, data, data);
             }
         }
     }];
}

- (void)playSound
{
    // Audio File Reading
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"Patron" withExtension:@"mp3"];
    
    fileReader = [[AudioFileReader alloc]
                  initWithAudioFileURL:inputFileURL
                  samplingRate:audioManager.samplingRate
                  numChannels:audioManager.numOutputChannels];
    
    [fileReader play];
    [fileReader setCurrentTime:0.0];
}

- (IBAction)bpf_switchChanged:(id)sender
{
    _bpf_on = [(UISwitch *)sender isOn];
}

- (IBAction)bpf_cfChanged:(id)sender
{
    _bpf_centerFrequency = [(UISlider *)sender value];
    [_bpf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _bpf_centerFrequency]];
}

- (IBAction)bpf_qChanged:(id)sender
{
    _bpf_Q = [(UISlider *)sender value];
    [_bpf_qLabel setText:[NSString stringWithFormat:@"%.2f", _bpf_Q]];
}

- (IBAction)bpqf_switchChanged:(id)sender
{
    _bpqf_on = [(UISwitch *)sender isOn];
}

- (IBAction)bpqf_cfChanged:(id)sender
{
    _bpqf_centerFrequency = [(UISlider *)sender value];
    [_bpqf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _bpqf_centerFrequency]];
}

- (IBAction)bpqf_qChanged:(id)sender
{
    _bpqf_Q = [(UISlider *)sender value];
    [_bpqf_qLabel setText:[NSString stringWithFormat:@"%.2f", _bpqf_Q]];
}

- (IBAction)hpf_switchChanged:(id)sender
{
    _hpf_on = [((UISwitch *)sender) isOn];
}

- (IBAction)hpf_cfChanged:(id)sender
{
    _hpf_cornerFrequency = [(UISlider *)sender value];
    [_hpf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _hpf_cornerFrequency]];
}

- (IBAction)hpf_qChanged:(id)sender
{
    _hpf_Q = [(UISlider *)sender value];
    [_hpf_qLabel setText:[NSString stringWithFormat:@"%.2f", _hpf_Q]];
}

- (IBAction)hsf_switchChanged:(id)sender
{
    _hsf_on = [((UISwitch *)sender) isOn];
}

- (IBAction)hsf_cfChanged:(id)sender
{
    _hsf_centerFrequency = [(UISlider *)sender value];
    [_hsf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _hsf_centerFrequency]];
}

- (IBAction)hsf_qChanged:(id)sender
{
    _hsf_Q = [(UISlider *)sender value];
    [_hsf_qLabel setText:[NSString stringWithFormat:@"%.2f", _hsf_Q]];
}

- (IBAction)hsf_gChanged:(id)sender
{
    _hsf_G = [(UISlider *)sender value];
    [_hsf_gLabel setText:[NSString stringWithFormat:@"%.2f", _hsf_G]];
}

- (IBAction)lpf_switchChanged:(id)sender
{
    _lpf_on = [((UISwitch *)sender) isOn];
}

- (IBAction)lpf_cfChanged:(id)sender
{
    _lpf_cornerFrequency = [(UISlider *)sender value];
    [_lpf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _lpf_cornerFrequency]];
}

- (IBAction)lpf_qChanged:(id)sender
{
    _lpf_Q = [(UISlider *)sender value];
    [_lpf_qLabel setText:[NSString stringWithFormat:@"%.2f", _lpf_Q]];
}

- (IBAction)lsf_switchChanged:(id)sender
{
    _lsf_on = [((UISwitch *)sender) isOn];
}

- (IBAction)lsf_cfChanged:(id)sender
{
    _lsf_centerFrequency = [(UISlider *)sender value];
    [_lsf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _lsf_centerFrequency]];
}

- (IBAction)lsf_qChanged:(id)sender
{
    _lsf_Q = [(UISlider *)sender value];
    [_lsf_qLabel setText:[NSString stringWithFormat:@"%.2f", _lsf_Q]];
}

- (IBAction)lsf_gChanged:(id)sender
{
    _lsf_G = [(UISlider *)sender value];
    [_lsf_gLabel setText:[NSString stringWithFormat:@"%.2f", _lsf_G]];
}

- (IBAction)nf_switchChanged:(id)sender
{
    _nf_on = [((UISwitch *)sender) isOn];
}

- (IBAction)nf_cfChanged:(id)sender
{
    _nf_centerFrequency = [(UISlider *)sender value];
    [_nf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _nf_centerFrequency]];
}

- (IBAction)nf_qChanged:(id)sender
{
    _nf_Q = [(UISlider *)sender value];
    [_nf_qLabel setText:[NSString stringWithFormat:@"%.2f", _nf_Q]];
}

- (IBAction)peqf_switchChanged:(id)sender
{
    _peqf_on = [((UISwitch *)sender) isOn];
}

- (IBAction)peqf_cfChanged:(id)sender
{
    _peqf_centerFrequency = [(UISlider *)sender value];
    [_peqf_cfLabel setText:[NSString stringWithFormat:@"%.2f", _peqf_centerFrequency]];
}

- (IBAction)peqf_qChanged:(id)sender
{
    _peqf_Q = [(UISlider *)sender value];
    [_peqf_qLabel setText:[NSString stringWithFormat:@"%.2f", _peqf_Q]];
}

- (IBAction)peqf_gChanged:(id)sender
{
    _peqf_G = [(UISlider *)sender value];
    [_peqf_gLabel setText:[NSString stringWithFormat:@"%.2f", _peqf_G]];
}

- (IBAction)ps_switchChanged:(id)sender
{
    _ps_on = [((UISwitch *)sender) isOn];
}

- (IBAction)ps_stChanged:(id)sender
{
    _ps_semitones = [(UISlider *)sender value];
    [_ps_stLabel setText:[NSString stringWithFormat:@"%.2f", _ps_semitones]];
}

- (void)dealloc
{
    [_bpf_cfLabel release];
    [_bpf_qLabel release];
    [_bpqf_cfLabel release];
    [_bpqf_qLabel release];
    [_hpf_cfLabel release];
    [_hpf_qLabel release];
    [_hsf_cfLabel release];
    [_hsf_qLabel release];
    [_hsf_gLabel release];
    [_lpf_cfLabel release];
    [_lpf_qLabel release];
    [_lsf_cfLabel release];
    [_lsf_qLabel release];
    [_lsf_gLabel release];
    [_nf_cfLabel release];
    [_nf_qLabel release];
    [_peqf_cfLabel release];
    [_peqf_qLabel release];
    [_peqf_gLabel release];
    
    [_ps_stLabel release];
    [super dealloc];
}

@end
