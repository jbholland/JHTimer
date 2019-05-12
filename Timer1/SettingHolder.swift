//
//  SettingHolder.swift
//  Timer1
//
//  Created by John Holland on 4/14/19.
//  Copyright © 2019 John Holland. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import UserNotifications


class SettingHolder {
    init() {
        defaults = UserDefaults.standard
        desiredTime = defaults.integer(forKey: "Time")
        timeRemaining = 0
        hour = 0
        minutes = 0
        seconds = 0
    }
    static var shared : SettingHolder = SettingHolder()
    var defaults : UserDefaults
    var timeRemaining:Int
    var paused = false
    var timer : Timer?
    var started = false
    private var audioPlayer: AVAudioPlayer!
    var playedSound = false
    
    
    var hour:Int {
        didSet(newValue){
            print("\(newValue)")
            desiredTime =  (60*60*hour) + (60*minutes) + seconds
        }
    }
    var minutes:Int{
        didSet(newValue){
            print("\(newValue)")
            desiredTime =  (60*60*hour) + (60*minutes) + seconds
        }
        
    }
    var seconds:Int{
        didSet(newValue){
            print("\(newValue)")
            desiredTime =  (60*60*hour) + (60*minutes) + seconds
        }
    }
    
    var desiredTime:Int?
    /*{
        didSet(newValue) {
            if (newValue != nil) {
                 if (newValue! < 1) {
                    timeRemaining = 10
                } else {
                    timeRemaining = newValue!
                }
                print("desired time set to: \(timeRemaining)")
            }
        }
    } */
    
    var suspendTime:Date = Date.init()
    
    func getDesiredTime()->Int? {
        return desiredTime
    }
    
    func start() {
        started = true
        timeRemaining = desiredTime!
    }
    
    func playSound() {
        audioPlayer.play()
    }
    func prepareAudioSession() -> Void {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            let audioFileName = "ting"
            let audioFileExtension = "mp3"
            guard let filePath = Bundle.main.path(forResource: audioFileName, ofType: audioFileExtension) else {
                print("Audio file not found at specified path")
                return
            }
            let alertSound = URL(fileURLWithPath: filePath)
            try? audioPlayer = AVAudioPlayer(contentsOf: alertSound)
            audioPlayer?.prepareToPlay()
            
        } catch let myError{
            print("Issue with Audio Session \(myError)")
        }
    }
    
    func setDefaults() {
        
        desiredTime = defaults.integer(forKey:"Time")
        timeRemaining = desiredTime!
    }
    
    func updateTimer() {
        if  timeRemaining >= 0 {
            if timeRemaining < 1  && !playedSound {
                playedSound = true
                
                playSound()
                if (timer != nil){
                    timer?.invalidate()
                    timer = nil
                    timeRemaining = getDesiredTime()!
                    //
                    playedSound = false
                    timeRemaining = 0
                }
                
            } else {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
    }
    func dequeueBellInBackground() {
        if (!paused) {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["Bell"])
            print("cancelled notification")
        }
    }
    func queueBellInBackground() {
        if (!paused) {
            
            let interval:TimeInterval =  TimeInterval(timeRemaining)
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "ting.caf"))
            print("setting notification center  seconds: \(timeRemaining)")
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:interval, repeats: false)
            let request = UNNotificationRequest(identifier: "Bell", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print("error adding request:\(theError)")// Handle any errors
                }
            }
            print("added request to notification center")
        }
    }
}


