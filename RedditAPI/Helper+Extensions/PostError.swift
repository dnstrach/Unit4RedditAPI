//
//  PostError.swift
//  RedditAPI
//
//  Created by Dominique Strachan on 1/11/23.
//

import Foundation

enum PostError: LocalizedError {
    
    case invalidURL
    //taking in type Error not variable error
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The server failed to reach the necessary URL."
                        //naming passed in error
        case .thrownError(let error):
                            //localizedDescription error is human readable error
            return "Error: \(error.localizedDescription) --\(error)"
        case .noData:
            return "The server responded with no data"
        case .unableToDecode:
            return "Unable to decode the data"
        }
    }
    
} //end of enum
