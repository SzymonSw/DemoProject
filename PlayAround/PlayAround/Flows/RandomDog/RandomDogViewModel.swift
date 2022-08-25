//
//  DogsViewModel.swift
//  PlayAround
//
//  Created by Szymon Swietek on 29/07/2022.
//

import Combine
import UIKit

@MainActor
class RandomDogViewModel {
    typealias Dependencies = HasDogApiPrvider & HasOtherDependencyProvider

    enum State: Equatable {
        case loading
        case success(images: [UIImage])
        case failure(error: CustomError)
    }

    @Published var state: State = .loading
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func viewDidLoad() {
        fetchRandomImages()
    }
    
    func redoTapped() {
        fetchRandomImages()
    }

    private func fetchRandomImages() {
        state = .loading
        Task {
            do {
                let images = try await dependencies.dogsApi.fetchRandomDogImages(number: 9)
                state = .success(images: images)

            } catch {
                if let error = error as? CustomError {
                    state = .failure(error: error)
                } else {
                    state = .failure(error: .otherError)
                }
            }
        }
    }
}

enum CustomError: String, Error {
    case couldNotLoadImage
    case otherError
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldNotLoadImage:
            return "Could not load image"
        case .otherError:
            return "Unknown error"
        }
    }
}
