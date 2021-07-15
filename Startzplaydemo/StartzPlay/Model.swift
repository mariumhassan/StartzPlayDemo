//
//  ViewController.swift
//  StartzPlay
//
//  Created by Marim Hassan on 13/07/2021.
//

import Foundation

struct TvShowDetails : Codable {
    var backdrop_path : String?
    var first_air_date : String?
    var name : String?
    var number_of_episodes : Int?
    var number_of_seasons : Int?
    var overview : String?
    var genres : [Genres]?
}

struct Genres : Codable {
    var id : Int?
    var name : String?
}

struct SeasonDetails : Codable{
   
    var episodes : [Episode]?
    var id :  Int?
    var name : String?
    var poster_path : String?
    var season_number :  Int?
}

struct Episode : Codable {
    var air_date : String?
    var crew : Crew?
    var episode_number : Int?
    var guest_stars : GuestStars?
    var id : Int?
    var name : String?
    var overview : String?
    var production_code : String?
    var season_number : Int?
    var still_path : String?
    var vote_average : Double?
    var vote_count : Int?
    
}

struct Crew : Codable {
    
}

struct GuestStars : Codable {
    
}


struct ParsedResponse<T> {
    var responseCode: String?
    var responseDescription: String?
    var responsePayload: T?
    
    init(responseCode: String?, responseDescription: String?, responsePayload: T?) {
        self.responseCode = responseCode
        self.responseDescription = responseDescription
        self.responsePayload = responsePayload
    }
    
}
