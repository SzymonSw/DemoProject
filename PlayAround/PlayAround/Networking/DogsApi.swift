//
//  DogsApi.swift
//  PlayAround
//
//  Created by Szymon Swietek on 02/08/2022.
//

import Foundation
import UIKit

protocol DogsAPIProvider {
    func fetchRandomDogImage() async throws -> UIImage
    func fetchRandomDogImages(number: Int) async throws -> [UIImage]
}

class DogsApi: DogsAPIProvider {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func fetchRandomDogImage() async throws -> UIImage {
        let urlRequest = URLRequest(url: URL(string: "https://dog.ceo/api/breeds/image/random")!)
        print("Random fetch started")
        do {
            let data = try await session.data(for: urlRequest)
            let decoder = JSONDecoder()
            let dogImage = try decoder.decode(DogImage.self, from: data.0)
            if let imageUrlRaw = dogImage.imageUrl, let imageUrl = URL(string: imageUrlRaw) {
                let imageRequest = URLRequest(url: imageUrl)
                let imageData = try await session.data(for: imageRequest).0
                if let image = UIImage(data: imageData) {
                    print("Random fetch finished with success")
                    return image
                } else {
                    throw CustomError.couldNotLoadImage
                }
            } else {
                throw CustomError.couldNotLoadImage
            }
        } catch {
            throw error
        }
    }

    func fetchRandomDogImages(number: Int) async throws -> [UIImage] {
        try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self, body: { group in
            for _ in 0 ..< number {
                group.addTask {
                    try await self.fetchRandomDogImage()
                }
            }
            var resultImages: [UIImage] = []
            for try await image in group {
                resultImages.append(image)
            }
            return resultImages

        })
    }

    func fetch2RandomDogImages() async throws -> [UIImage] {
        async let image1 = fetchRandomDogImage()
        async let image2 = fetchRandomDogImage()
        let images = try await [image1, image2]
        return images
    }
}
