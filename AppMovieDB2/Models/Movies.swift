//
//  Movies.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 11/22/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import Foundation
struct MoviesData: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys:String, CodingKey{
        case movies = "results"
    }
    
}
struct Movie: Decodable {
    let id: Int?
    let title: String?
    let backdrop_path: String?
    let poster_path: String?
    let overview: String?
    let vote_average: Double?
    let release_date: String?
    let genre_ids: [Int]?
    let key: String?
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop_path ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path ?? "")")!
    }
    var genreText:String{
        switch genre_ids!.first {
        case 28:
            return "Action"
        case 12:
            return "Adventure"
        case 16:
            return "Animation"
        case 35:
            return "Comedy"
        case 99:
            return "Documentary"
        case 80:
            return "Crime"
        case 18:
            return "Drama"
        case 10751:
            return "Family"
        case 14:
            return "Fantasy"
        case 36:
            return "History"
        case 27:
            return "Horror"
        case 10402:
            return "Music"
        case 9648:
            return "Mystery"
        case 10749:
            return "Romance"
        case 878:
            return "Science Fiction"
        case 10770:
            return "TV Movie"
        case 53:
            return "Thriller"
        case 10752:
            return "War"
        case 37:
            return "Western"
        default:
            return "Ningun genero"
        }
    }
        
}
    

