//
//  StoryModel.swift
//  StoryTextToSpeech
//
//  Created by Yavuz Ulgar on 9.04.2023.
//

import Foundation

struct StoryModel: Codable {
    let id, title, author, story: String?
    let moral: String?
}
