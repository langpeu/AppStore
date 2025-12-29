//
//  AppDetailItem.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

struct AppDetailItem: Decodable, Identifiable {
    var id: Int
    let name: String
    let iconUrl: String
    let userRatingCount: Int
    let averageUserRating: Float
    let genres: [String]
    let screenshotUrls: [String]
    
    
    enum CodingKeysTest: String, CodingKey {
        case id = "trackId"
        case name = "trackName"
        case iconUrl = "artworkUrl100"
        case userRatingCount
        case averageUserRating
        case genres
        case screenshotUrls
    }
}
