//
//  ViewController.swift
//  Timer1
//
//  Created by John Holland on 3/31/19.
//  Copyright © 2019 John Holland. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer




class ViewController: UIViewController {
    var settingHolder : SettingHolder = SettingHolder.shared
    let dateComponentsFormatter = DateComponentsFormatter()
    var defaults = UserDefaults.standard
    @IBOutlet weak var labelClock : UITextField?
    
    @IBOutlet var pauseButton: UIButton!
    
    @IBAction func togglePause() {
        settingHolder.paused = !settingHolder.paused
        if (settingHolder.paused) {
            pauseButton.setTitle("Continue", for: UIControl.State.normal)
            settingHolder.dequeueBellInBackground()
        } else {
            pauseButton.setTitle("Pause",for: UIControl.State.normal)
            settingHolder.queueBellInBackground()
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    func playAudioPlayer() -> Void {
        settingHolder.playSound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabel()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateComponentsFormatter.unitsStyle = .positional
        dateComponentsFormatter.zeroFormattingBehavior = .pad
        dateComponentsFormatter.allowedUnits = [.hour , .minute, .second]
        settingHolder.prepareAudioSession()
        updateLabel()

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        settingHolder.timer?.invalidate()
    }
    
    
    @IBAction func startTimer() {
        settingHolder.start()
        
        
        labelClock?.text = dateComponentsFormatter.string(from:
            TimeInterval(Float(settingHolder.timeRemaining)))
        
        settingHolder.prepareAudioSession()
        
        
        if (settingHolder.timer != nil){
            settingHolder.timer?.invalidate()
            settingHolder.timer = nil
        }
        settingHolder.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats:true);
        settingHolder.queueBellInBackground()
    }
    
    
    
    @objc func updateLabel() -> Void {
        
        if (!settingHolder.paused ) {
            if (!settingHolder.started){
                
                
                labelClock?.text = dateComponentsFormatter.string(from: TimeInterval(Float(settingHolder.desiredTime ?? 0)))
            } else {
                labelClock?.text = dateComponentsFormatter.string(from: TimeInterval(Float(settingHolder.timeRemaining - 1)))
                
                settingHolder.updateTimer()
                if (settingHolder.timeRemaining < 1){
                    labelClock?.text = dateComponentsFormatter.string(from: TimeInterval(Float(0)))
                }
            }
        }
    }
}





