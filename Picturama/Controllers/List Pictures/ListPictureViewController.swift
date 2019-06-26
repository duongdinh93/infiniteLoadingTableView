//
//  ListPictureViewController.swift
//  Picturama
//
//  Created by Duong Dinh on 6/2/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import UIKit
import SDWebImage

class ListPictureViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Variables
    var viewModel: ListPictureViewModelProtocol = ListPictureViewModel()
}

// MARK: - Life Cycle
extension ListPictureViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewComponents()
        reloadData()
    }
}

// MARK: - Views initializing
extension ListPictureViewController {
    
    func initViewComponents() {
        // Table view
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: PictureTableViewCell.cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: PictureTableViewCell.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        // Navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Activity indicator view
        activityIndicatorView.hidesWhenStopped = true
    }
}

// MARK: - Data loading
extension ListPictureViewController {
    
    func reloadData() {
        activityIndicatorView.startAnimating()
        
        // Call view model to request data
        viewModel.fetchData {_ in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ListPictureViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pictureCell = tableView.dequeueReusableCell(withIdentifier: PictureTableViewCell.cellIdentifier,
                                                              for: indexPath) as! PictureTableViewCell
        
        let picture = viewModel.recordAt(indexPath.row)
        
        if isLoadingCell(at: indexPath) {
            pictureCell.configureCell(with: .none)
        } else {
            pictureCell.configureCell(with: picture)
        }
        
        return pictureCell
    }
}

extension ListPictureViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { isLoadingCell(at: $0) }) {
            viewModel.fetchData { (indexPathsToReload) in
                let indexPathsShouldBeReloaded = self.indexPathsShouldBeReloaded(from: indexPathsToReload)
                
                // Reload rows
                self.tableView.reloadRows(at: indexPathsShouldBeReloaded, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ListPictureViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

private extension ListPictureViewController {
    
    func isLoadingCell(at indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentRecordsCount()
    }
    
    func indexPathsShouldBeReloaded(from indexPathsToReload: [IndexPath]) -> [IndexPath] {
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        let indexPathsShouldBeReloaded = Set(indexPathsToReload).intersection(visibleIndexPaths)
        
        return Array(indexPathsShouldBeReloaded)
    }
}
