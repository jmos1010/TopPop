//
//  Tracks.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 10/03/2021.
//

import Foundation

struct Tracks: Decodable {
    let data: [Track]
    let total: Int
}
