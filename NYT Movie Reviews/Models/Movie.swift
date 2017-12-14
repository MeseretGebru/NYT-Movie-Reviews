//
//  Movie.swift
//  NYT Movie Reviews
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

struct AllInfo: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let movieTitle: String?
    let displayName: String?
    let byline: String?
    let headline: String?
    let summaryShort: String?
    let link: Link?
    let multimedia: Multimedia?
    enum CodingKeys: String, CodingKey {
        case movieTitle = "display_title"
        case displayName = "display_name"
        case byline
        case headline
        case summaryShort = "summary_short"
        case link
        case multimedia
    }
}

struct Link: Codable {
    let type: String
    let url: String
    let suggestedLinkText: String
    enum CodingKeys: String, CodingKey {
        case type
        case url
        case suggestedLinkText = "suggested_link_text"
    }
}

struct Multimedia:  Codable {
    let type: String?
    let src: String?
    let resource: Resource?
}

struct Resource: Codable {
    let type: String?
    let src: String?
}

struct Favorite {
    
}

