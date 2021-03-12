//
//  AlbumDetailsControllerViewModel.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 12/03/2021.
//

import Foundation

class AlbumDetailsControllerViewModel {
    
    // MARK: - Properties
    
    private let track: Track
    private let albumId: Int
    private let networkService = NetworkService()
    var albumTracks: [AlbumTrack]?
    var errorMessage: String?
    
    var trackTitleLabelText: String { return track.title }
    var artistNameLabelText: String { return track.artist.name }
    var albumNameLabelText: String { return track.album.title }
    var albumCoverImageURL: URL? { return URL(string: track.album.coverMedium) }
    
    // MARK: - Lifecycle
    
    init(track: Track) {
        self.track = track
        self.albumId = track.album.id
    }
    
    // MARK: - Helpers
    
    func getAlbum(_ completion: @escaping () -> Void) {
        networkService.getAlbum(albumId) { result in
            switch result {
            case .success(let albumTracks):
                self.albumTracks = albumTracks
                completion()
            case .failure(let error):
                self.errorMessage = error.rawValue
                print("DEBUG: Error: \(error)")
                completion()
            }
        }
    }
}
