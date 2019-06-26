//
//  Picture.swift
//  Picturama
//
//  Created by Duong Dinh on 6/2/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import Foundation

class Picture {
    var id: Int
    var tags: String
    var url: URL?
    var views: Int
    var likes: Int
    var userImageURL: URL?
    var previewImageURL: URL?
    var size: Int
    
    init() {
        self.id = 0
        self.tags = ""
        self.url = nil
        self.views = 0
        self.likes = 0
        self.userImageURL = nil
        self.previewImageURL = nil
        self.size = 0
    }
}
