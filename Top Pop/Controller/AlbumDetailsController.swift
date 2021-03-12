//
//  AlbumDetailsController.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 11/03/2021.
//

import UIKit

class AlbumDetailsController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: AlbumDetailsControllerViewModel?
    private let tableView = UITableView()
    private let trackTitleLabel = Utilities.customLabel(withFontSize: 26, bold: true)
    private let artistNameLabel = Utilities.customLabel(withFontSize: 24)
    private let albumNameLabel = Utilities.customLabel(withFontSize: 22)
    private lazy var albumCoverImageView = Utilities.customImageView(withDimensions: 250)
    private lazy var blurredBackgroundView = Utilities.customBlurredBackgroundView()

    // MARK: - Lifecycle
    
    init(track: Track) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = AlbumDetailsControllerViewModel(track: track)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.configureGradientLayer()
        configureTableView()
        setUpView()
        getAlbum()
    }
    
    // MARK: - Helpers
    
    private func getAlbum() {
        viewModel?.getAlbum({
            DispatchQueue.main.async {
                if let errorMessage = self.viewModel?.errorMessage {
                    let alertController = Utilities.createErrorAlert(error: errorMessage)
                    self.present(alertController, animated: true)
                }
                self.configureViewData()
                self.tableView.reloadData()
            }
        })
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 20
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.dataSource = self
    }
    
    private func setUpView() {
        view.addSubview(blurredBackgroundView)
        view.addSubview(albumCoverImageView)
        view.addSubview(albumNameLabel)
        view.addSubview(tableView)
        blurredBackgroundView.frame = view.frame
        
        let trackStack = UIStackView(arrangedSubviews: [trackTitleLabel, artistNameLabel])
        trackStack.axis = .vertical
        trackStack.distribution = .equalSpacing
        trackStack.alignment = .center
        view.addSubview(trackStack)
        trackStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(top: trackStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingRight: 8)
        dividerView.setHeight(height: 0.75)
        
        albumCoverImageView.centerX(inView: view)
        albumCoverImageView.anchor(top: dividerView.bottomAnchor, paddingTop: 16)
        albumNameLabel.centerX(inView: view)
        albumNameLabel.anchor(top: albumCoverImageView.bottomAnchor, paddingTop: 8)
        
        let secondDividerView = UIView()
        secondDividerView.backgroundColor = .white
        view.addSubview(secondDividerView)
        secondDividerView.anchor(top: albumNameLabel.bottomAnchor, paddingTop: 8)
        secondDividerView.centerX(inView: self.view)
        secondDividerView.setDimensions(height: 0.75, width: 200)
        
        tableView.anchor(top: secondDividerView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
    }

    private func configureViewData() {
        self.trackTitleLabel.text = self.viewModel?.trackTitleLabelText
        self.artistNameLabel.text = self.viewModel?.artistNameLabelText
        self.albumNameLabel.text = self.viewModel?.albumNameLabelText
        albumCoverImageView.sd_setImage(with: viewModel?.albumCoverImageURL)
    }
}

// MARK: - UITableViewDataSource

extension AlbumDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.albumTracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = viewModel?.albumTracks?[indexPath.row].title ?? ""
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.centerX(inView: cell.contentView)
        cell.backgroundColor = .clear
        return cell
    }
    
}
