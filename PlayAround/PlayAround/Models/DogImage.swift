//
//  DogImage.swift
//  PlayAround
//
//  Created by Szymon Swietek on 29/07/2022.
//

import Foundation

struct DogImage: Codable {
    var imageUrl: String?
    var status: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "message"
        case status
    }
}
