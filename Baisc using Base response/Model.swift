//
//  Model.swift
//  AssignmentApp
//
//  Created by Subhadeep Pal on 16/12/19.
//  Copyright © 2019 Subhadeep Pal. All rights reserved.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    var data: T
}

struct CardResponse: Decodable {
    let cardDetails: CardDetails
    let card: [Card]
    
    enum CardType: String, Decodable {
        case localFood = "local_food"
    }
    
    struct CardDetails: Decodable {
        
        let title: String
        let type: CardType
        let city: String
    }
    
    struct Card: Decodable {
        let title: String
        let desc: String
        let img: String
        
        var imageUrl: URL? {
            return URL(string: img)
        }
        
        let cardNo: Int
        let details: CardDetails
        
        
        struct CardDetails: Decodable {
            let about: [String]
            let locations: [Location]
            let dishes: [String]
            let images: [String]
            
            var urlArray: [URL]? = nil
            
            mutating func imageURLs() -> [URL] {
                if let urls = urlArray {
                    return urls
                } else {
                    let urlArray = images.map { (urlString) -> URL? in
                        return URL(string: urlString)
                    }
                    self.urlArray = urlArray.filter { (url) -> Bool in
                        url != nil
                        } as? [URL]
                    return self.urlArray!
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case about
                case locations = "where"
                case dishes
                case images
            }
            
            struct Location: Decodable {
                let name: String
                let distance: Double?
            }
        }
    }
}
