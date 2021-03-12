//
//  Album.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 10/03/2021.
//

import Foundation

struct Album: Decodable {
    let id: Int
    let title: String
    let coverMedium: String
    let tracklist: String
}
