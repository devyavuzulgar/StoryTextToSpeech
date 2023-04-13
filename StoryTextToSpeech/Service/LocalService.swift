//
//  LocalService.swift
//  StoryTextToSpeech
//
//  Created by Yavuz Ulgar on 13.04.2023.
//

import Foundation


struct LocalService {
    // Download a random story
    func downloadStories(url: URL, completion: @escaping (StoryModel?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let storyModels = try? JSONDecoder().decode(StoryModel.self, from: data)
                
                if let serviceStoryModel = storyModels {
                    completion(serviceStoryModel)
                }
            }
        }.resume()
    }
}

