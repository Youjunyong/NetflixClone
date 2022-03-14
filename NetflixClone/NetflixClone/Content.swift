//
//  Content.swift
//  NetflixClone
//
//  Created by 유준용 on 2022/03/12.
//

import UIKit

struct Content: Decodable {
    let sectionType: SectionType
    let sectionName: String
    let contentItem: [ContentItem]
    
    enum SectionType: String, Decodable{
        case main
        case basic
        case rank
        case large
    }
}

struct ContentItem: Decodable{
    let description: String
    let imageName: String
    var image: UIImage{
        return UIImage(named: self.imageName) ?? UIImage()
    }
}
