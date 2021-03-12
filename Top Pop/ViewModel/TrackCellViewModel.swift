//
//  TrackCellViewModel.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 10/03/2021.
//

import UIKit
import SDWebImage

struct TrackCellViewModel {
    
    // MARK: - Properties
    
    private var track: Track?
    var trackTitleLabelText: String? { return track?.title }
    var artistNameLabelText: String? { return track?.artist.name }
    
    var trackDurationLabelText: String {
        let durationSeconds: TimeInterval = Double(track?.duration ?? 0)
        
        let componentsFormatter = DateComponentsFormatter()
        componentsFormatter.allowedUnits = [.minute, .second]
        componentsFormatter.maximumUnitCount = 2
        componentsFormatter.unitsStyle = .positional
        
        return componentsFormatter.string(from: durationSeconds) ?? ""
    }
    
    var trackPositionLabelText: String {
        let positionString = String(track?.position ?? 0)
        return "#\(positionString)"
    }
    
    var artistImageURL: URL? { return URL(string: track?.artist.pictureSmall ?? "") }
    
    // MARK: - Lifecycle
    
    init?(_ track: Track?) {
        guard let unwrappedTrack = track else { return nil }
        self.track = unwrappedTrack
    }
}

