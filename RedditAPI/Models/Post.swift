//
//  Post.swift
//  RedditAPI
//
//  Created by Dominique Strachan on 1/11/23.
//

import Foundation
            
                    //Can also use Codable which contains encodable and decodable
                    //struct must contain decodable class for JSON decoding in do catch block
struct TopLevelObject: Decodable {
    let data: SecondLevelObject
}

struct SecondLevelObject: Decodable {
    let children: [ThirdLevelObject]
}

struct ThirdLevelObject: Decodable {
    let data: Post
}

struct Post: Decodable {
    let title: String
    let ups: Int
    let thumbnail: String
}
