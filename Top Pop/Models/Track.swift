//
//  Track.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 10/03/2021.
//

import Foundation

struct Track: Decodable {
    let title: String
    let duration: Int
    let position: Int
    let artist: Artist
    let album: Album
}
