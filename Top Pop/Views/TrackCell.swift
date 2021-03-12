//
//  TrackCell.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 10/03/2021.
//

import UIKit

class TrackCell: UITableViewCell {
    
    // MARK: - Properties
        
    private let loadingIndicator = UIActivityIndicatorView()
    private let trackTitleLabel = Utilities.customLabel(withFontSize: 18, bold: true)
    private let artistNameLabel = Utilities.customLabel(withFontSize: 16)
    private let trackDurationLabel = Utilities.customLabel(withFontSize: 14)
    private let trackPositionLabel = Utilities.customLabel(withFontSize: 30, bold: true)
    private lazy var blurredBackgroundView = Utilities.customBlurredBackgroundView()
    private lazy var artistImageView = Utilities.customImageView(withDimensions: 70)
  
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistImageView.image = nil
    }
    
    // MARK: - Helpers
    
    func setUpView() {
        backgroundColor = .clear
        backgroundView = blurredBackgroundView
        
        addSubview(loadingIndicator)
        addSubview(artistImageView)
        addSubview(trackPositionLabel)
        
        let stack = UIStackView(arrangedSubviews: [trackTitleLabel, artistNameLabel, trackDurationLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        addSubview(stack)
        
        artistImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        stack.anchor(top: artistImageView.topAnchor, left: artistImageView.rightAnchor, bottom: artistImageView.bottomAnchor, paddingLeft: 8)
        trackPositionLabel.centerY(inView: self)
        trackPositionLabel.anchor(right: rightAnchor, paddingRight: 8)
        loadingIndicator.centerX(inView: self)
        loadingIndicator.centerY(inView: self)
    }
    
    // if viewModel is nil that means that we are in skeleton mode, otherwise not
    func configureCell(_ viewModel: TrackCellViewModel?) {
        selectionStyle = .none
        isUserInteractionEnabled = viewModel != nil
        viewModel == nil ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        trackTitleLabel.text = viewModel?.trackTitleLabelText
        artistNameLabel.text = viewModel?.artistNameLabelText
        trackDurationLabel.text = viewModel?.trackDurationLabelText
        trackPositionLabel.text = viewModel?.trackPositionLabelText
        artistImageView.sd_setImage(with: viewModel?.artistImageURL)
    }
}
