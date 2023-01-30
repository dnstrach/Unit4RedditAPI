//
//  PostController.swift
//  RedditAPI
//
//  Created by Dominique Strachan on 1/11/23.
//

import Foundation
import UIKit

class PostController {
    
    static let baseURL = URL(string: "https://www.reddit.com")
    static let rComponent = "r"
    static let JSONextension = "json"
    
    //https://www.reddit.com/r/funny.json
    //passing in searchterm of type string
    //@escaping so result can be used outside of function throughout VC
    //result has type success and type failure
    static func fetchPostWith(searchTerm: String, completion: @escaping (Result<[Post], PostError>) -> Void) {
        
        //**CONSTRUCTING URL**
        //guarding because baseURL is optional if option click variable above - possible that there could be a fail in converting url to string
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        //adding r component to baseURL
        let rURL = baseURL.appendingPathComponent(rComponent)
        
        //appending searchterm parameter
        //searchterm will be funny
        let searchURL = rURL.appendingPathComponent(searchTerm)
        
        let finalURL = searchURL.appendingPathExtension(JSONextension)
        
        //print to check finalURL is https://www.reddit.com/r/funny.json
        print(finalURL)
        //**CONSTRUCTING URL**
        
        //DATA TASK must be paired with .resume() or code execution will stop
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            //handling error
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            //handling response
            //only not 200 print error
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("POST STATUS CODE: \(response.statusCode)")
                }
            }
            
            //unwrapping data
            guard let data = data else { return completion(.failure(.noData)) }
            
            //handling success
            do {
                //decoding top level object which contains all objects/arrays leading to post
                //passing in data to decoder
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let secondLevelObject = topLevelObject.data
                //third level object is an array
                let thirdLevelObject = secondLevelObject.children
                
                var arrayOfPosts: [Post] = []
                
                //looping through array to grab each object in children/third level object array
                //dictionary because objects are dicts in swift
                for dict in thirdLevelObject {
                    //data object inside of each object being looped through contains post keys/values
                    let post = dict.data
                    arrayOfPosts.append(post)
                }
                
                return completion(.success(arrayOfPosts))
             
            //handling error
            } catch {
                //return completion(.failure(.thrownError(error)))
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchThumbnailFor(post: Post, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        
        guard let thumbnailURL = URL(string: post.thumbnail) else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("THUMBNAIL STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let thumbnail = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(thumbnail))
            
        }.resume()
    }
    
} //end of class
