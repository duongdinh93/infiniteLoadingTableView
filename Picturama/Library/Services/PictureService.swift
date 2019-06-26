//
//  PictureService.swift
//  Picturama
//
//  Created by Duong Dinh on 6/2/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import Foundation

protocol PictureServiceProtocol {
    func fetchData() -> [Picture]
    func getTotalRecords() -> Int
}

class PictureService: PictureServiceProtocol {
    
    // MARK: - Variables
    private var currentPage = 0
    private var totalRecords = 0
}

// MARK: - Public APIs
extension PictureService {
    
    func fetchData() -> [Picture] {
        let nextPage = currentPage + 1
        
        return getPicturesAt(page: nextPage)
    }
    
    func getTotalRecords() -> Int {
        return totalRecords
    }
}

// MARK: - Private functions
extension PictureService {
    
    private func getPicturesAt(page: Int) -> [Picture] {
        var pictures = [Picture]()
        
        let request = APIRequest(method: .get, path: "")
        
        let accessKeyQueryItem = URLQueryItem(name: "key", value: "12655795-1503a77817e6b536569a13860")
        let pageQueryItem = URLQueryItem(name: "page", value: "1")
        let perPageQueryItem = URLQueryItem(name: "per_page", value: "5")
        request.queryItems = [accessKeyQueryItem, pageQueryItem, perPageQueryItem]
        
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        
        APIClient().request(request) { (httpResponse, data, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    guard let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary else {
                        return
                    }
                    
                    if let totalRecords = jsonData["totalHits"] as? Int {
                        self.totalRecords = totalRecords
                    }
                    
                    guard let jsonPictures = jsonData["hits"] as? [NSDictionary] else {
                        return
                    }
                    
                    for jsonPicture in jsonPictures {
                        let picture = Picture()
                        
                        if let id = jsonPicture["id"] as? Int {
                            picture.id = id
                        }
                        
                        if let previewURL = jsonPicture["previewURL"] as? String {
                            picture.previewImageURL = URL(string: previewURL)
                        }
                        
                        if let tags = jsonPicture["tags"] as? String {
                            picture.tags = tags
                        }
                        
                        if let likes = jsonPicture["likes"] as? Int {
                            picture.likes = likes
                        }
                        
                        if let views = jsonPicture["views"] as? Int {
                            picture.views = views
                        }
                        
                        if let size = jsonPicture["size"] as? Int {
                            picture.size = size
                        }
                        
                        pictures.append(picture)
                    }
                    
                    dispatchSemaphore.signal()
                    
                } catch {
                    
                }
            }
        }
        dispatchSemaphore.wait()
        
        currentPage = page
        
        return pictures
    }
}
