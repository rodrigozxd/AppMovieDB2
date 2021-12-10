//
//  ApiService.swift
//  AppMovieDB2
//
//  Created by Mac 10 on 11/24/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import Foundation

class ApiService {
    
    var dataTask: URLSessionDataTask?
    var apikey = "1865f43a0549ca50d341dd9ab8b29f49"
    
    func getNowPlayingMovies(completion: @escaping (Result<MoviesData, Error>) -> Void){
        let rutaPopular = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apikey)&language=en-US&page=1"
        guard let url = URL(string: rutaPopular) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }catch let error{
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<MoviesData, Error>) -> Void){
        let rutaPopular = "https://api.themoviedb.org/3/movie/popular?api_key=\(apikey)&language=en-US&page=1"
        guard let url = URL(string: rutaPopular) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }catch let error{
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<MoviesData, Error>) -> Void){
        let rutaPopular = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apikey)&language=en-US&page=1"
        guard let url = URL(string: rutaPopular) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }catch let error{
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<MoviesData, Error>) -> Void){
        let rutaPopular = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apikey)&language=en-US&page=1"
        guard let url = URL(string: rutaPopular) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }catch let error{
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
