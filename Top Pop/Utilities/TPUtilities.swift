//
//  TPUtilities.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 12/03/2021.
//

import UIKit

struct Utilities {
    
    //MARK: - ErrorAlert
    
    static func createErrorAlert(error: String) -> (UIAlertController) {
        let alert = UIAlertController(title: ApplicationStrings.alertControllerTitle, message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: ApplicationStrings.sortCancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
    
    //MARK: - customImageView
    
    static func customImageView(withDimensions dimensions: Int) -> (UIImageView) {
        let imageView = UIImageView()
        let dimensionsCGF = CGFloat(dimensions)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(height: dimensionsCGF, width: dimensionsCGF)
        imageView.layer.cornerRadius = 5
        return imageView
    }
    
    //MARK: - customLabel
    
    static func customLabel(withFontSize size: Int, bold: Bool = false) -> (UILabel) {
        let label = UILabel()
        let fontSizeCGF = CGFloat(size)
        label.font = bold ? UIFont.boldSystemFont(ofSize: fontSizeCGF) : UIFont.systemFont(ofSize: fontSizeCGF)
        return label
    }
    
    //MARK: - customBlurredBackgroundView

    static func customBlurredBackgroundView() -> (UIView) {
            let view = UIView()
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            view.addSubview(blurEffectView)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
    }
}
