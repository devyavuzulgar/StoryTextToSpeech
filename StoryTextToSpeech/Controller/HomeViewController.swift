//
//  HomeViewController.swift
//  StoryTextToSpeech
//
//  Created by Yavuz Ulgar on 9.04.2023.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    @IBOutlet weak var tapsView: UIView!
    var storyModel: StoryModel?
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let utteranceFirst = AVSpeechUtterance(string: "The application is opened. If you double-tap the screen with one finger, it will tell a story. Double tap again and it will tell a different story. If you double tap with two fingers the storytelling will stop, if you double tap with two fingers again it will continue.")
        utteranceFirst.rate = 0.5
        utteranceFirst.voice = AVSpeechSynthesisVoice(language: "en_US")
        synthesizer.speak(utteranceFirst)
        
        
        let gestureStartSpeech = UITapGestureRecognizer(target: self, action: #selector(startSpeech))
        gestureStartSpeech.numberOfTapsRequired = 2
        tapsView.addGestureRecognizer(gestureStartSpeech)
        
        let gestureStopSpeech = UITapGestureRecognizer(target: self, action: #selector(stopSpeech))
        gestureStopSpeech.numberOfTouchesRequired = 2
        gestureStopSpeech.numberOfTapsRequired = 2
        tapsView.addGestureRecognizer(gestureStopSpeech)
        
    }
    
    @objc func startSpeech() {
        
        let url = URL(string: "https://shortstories-api.onrender.com")!
        NetworkManager().downloadStories(url: url) { serviceStoryModel in
            self.storyModel = serviceStoryModel
        }
        
        guard let modelStory = storyModel?.story else { return }
        guard let modelTitle = storyModel?.title else { return }
        
        if (synthesizer.isSpeaking) {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        
        let utteranceTitle = AVSpeechUtterance(string: "Story Title: \(modelTitle)")
        utteranceTitle.rate = 0.4
        utteranceTitle.pitchMultiplier = 1.8
        utteranceTitle.voice = AVSpeechSynthesisVoice(language: "en_US")
        synthesizer.speak(utteranceTitle)
        
        let utteranceStory = AVSpeechUtterance(string: "Story: \(modelStory)")
        utteranceStory.rate = 0.4
        utteranceStory.pitchMultiplier = 1.8
        utteranceStory.voice = AVSpeechSynthesisVoice(language: "en_US")
        synthesizer.speak(utteranceStory)
        
    }
    
    @objc func stopSpeech() {
        
        if (synthesizer.isPaused) {
            synthesizer.continueSpeaking();
        } else {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        }
    }
}












/*
 Note: The download Stories() function is written differently in the Local Service file to be more useful.
 func downloadStories() {
     // Download a random story
     let url = URL(string: "https://shortstories-api.onrender.com")
     
     if url != nil {
         let request = URLRequest(url: url!)
         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
             if let error = error {
                 print(error.localizedDescription)
             } else if let data = data {
                 self.storyModel = try? JSONDecoder().decode(StoryModel.self, from: data)
                 }
         }
         task.resume()
     }
 }
 */
