//
//  TopListController.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 09/03/2021.
//

import UIKit

class TopListController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var tracks: [Track] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    private let networkService = NetworkService()
    private let loadingIndicator = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    private var isSkeleton = true
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureTableView()
        configureRefreshControl()
        getChart()
    }
    
    // MARK: - Selectors
    
    @objc func handleSortTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let normalAction = UIAlertAction(title: ApplicationStrings.sortOriginal, style: .default) { _ in
            self.tracks.sort(by: { $0.position < $1.position } )
        }
        let sortAscAction = UIAlertAction(title: ApplicationStrings.sortAscending, style: .default) { _ in
            self.tracks.sort(by: { $0.duration < $1.duration } )
        }
        let sortDescAction = UIAlertAction(title: ApplicationStrings.sortDescending, style: .default) { _ in
            self.tracks.sort(by: { $0.duration > $1.duration } )
        }
        let cancelAction = UIAlertAction(title: ApplicationStrings.sortCancel, style: .cancel, handler: nil)
        sheet.addAction(sortAscAction)
        sheet.addAction(sortDescAction)
        sheet.addAction(normalAction)
        sheet.addAction(cancelAction)
        present(sheet, animated: true)
    }
    
    @objc func handleRefresh() {
        getChart()
    }
    
    // MARK: - Helpers
    
    private func getChart() {
        tracks.removeAll()
        isSkeleton = true
        networkService.getChart { result in
            self.isSkeleton = false
            switch result {
            case .success(let returnedTracks):
                self.tracks = returnedTracks
            case .failure(let error):
                self.tableView.reloadData()
                let alertController = Utilities.createErrorAlert(error: error.rawValue)
                DispatchQueue.main.async { self.present(alertController, animated: true) }
                print("DEBUG: Error: \(error)")
            }
        }
    }
    
    private func configureUI() {
        view.configureGradientLayer()
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = ApplicationStrings.navigationBarTitle
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark //get white status bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: ApplicationStrings.barButtonSortTitle, style: .plain, target: self, action: #selector(handleSortTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: ApplicationStrings.noTitle, style: .plain, target: nil, action: nil)
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.register(TrackCell.self, forCellReuseIdentifier: "\(TrackCell.self)")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
       
    private func configureRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
}

// MARK: - UITableViewDataSource

extension TopListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSkeleton ? 10 : tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TrackCell.self)", for: indexPath) as! TrackCell
        let track = tracks.isEmpty ? nil : tracks[indexPath.row]
        cell.configureCell(TrackCellViewModel(track))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TopListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AlbumDetailsController(track: tracks[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
