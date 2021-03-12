//
//  NetworkService.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 10/03/2021.
//

import Foundation

struct NetworkService {
    private let chartBaseURLString = "https://api.deezer.com/chart"
    private let albumBaseURLString = "https://api.deezer.com/album/"
    
    // MARK: - getChart
    
    func getChart(completion: @escaping (Result<[Track], TPError>) -> Void) {
        
        guard let url = URL(string: chartBaseURLString) else {
            completion(Result.failure(.badUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(Result.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(Result.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(Result.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(Chart.self, from: data)
                let tracks = decodedData.tracks.data
                completion(Result.success(tracks))
            } catch {
                completion(Result.failure(.decodingFailure))
            }
            
        }
        
        task.resume()
    }
    
    // MARK: - getAlbum
    
    func getAlbum(_ albumId: Int ,completion: @escaping (Result<[AlbumTrack], TPError>) -> Void) {
        
        let fullAlbumURLString = albumBaseURLString + String(albumId)
        
        guard let url = URL(string: fullAlbumURLString) else {
            completion(Result.failure(.badUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(Result.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(Result.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(Result.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(AlbumTracks.self, from: data)
                let albumTracks = decodedData.tracks.data
                completion(Result.success(albumTracks))
            } catch {
                completion(Result.failure(.decodingFailure))
            }
            
        }
        
        task.resume()
    }
}

// MARK: - Custom Error type

enum TPError: String, Error {
    case badUrl = "Bad url!"
    case unableToComplete = "Unable to complete!"
    case invalidResponse = "Invalid response!"
    case invalidData = "Invalid data!"
    case decodingFailure = "Decoding failed!"
}
