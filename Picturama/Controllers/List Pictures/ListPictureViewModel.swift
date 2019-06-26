//
//  ListPictureViewModel.swift
//  Picturama
//
//  Created by Duong Dinh on 6/2/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import Foundation

protocol ListPictureViewModelProtocol {
    
    func numberOfRecords() -> Int
    func currentRecordsCount() -> Int
    func recordAt(_ index: Int) -> Picture?
    func fetchData(completion: @escaping ([IndexPath]) -> Void)
}

class ListPictureViewModel: ListPictureViewModelProtocol {
    
    // MARK: - Variables
    private var pictures = [Picture]()
    private var pictureService = PictureService()
    private var totalPictures = 0
    private var isFetchingData = false
    
    func numberOfRecords() -> Int {
        return pictureService.getTotalRecords()
    }
    
    func currentRecordsCount() -> Int {
        return pictures.count
    }
    
    func recordAt(_ index: Int) -> Picture? {
        return pictures[safe: index]
    }
    
    func fetchData(completion: @escaping ([IndexPath]) -> Void) {
        guard !isFetchingData else {
            return
        }
        isFetchingData = true
        
        let newData = pictureService.fetchData()
        
        DispatchQueue.main.async {
            self.pictures.append(contentsOf: newData)
            completion(self.calculateIndexPathsToReload(newDataCount: newData.count, totalLoadedDataCount: self.pictures.count))
            self.isFetchingData = false
        }
    }
}

private extension ListPictureViewModel {
    
    func calculateIndexPathsToReload(newDataCount: Int, totalLoadedDataCount: Int) -> [IndexPath] {
        let startIndex = totalLoadedDataCount - newDataCount
        let endIndex = totalLoadedDataCount
        
        return (startIndex..<endIndex).map {
            IndexPath(row: $0, section: 0)
        }
    }
}
