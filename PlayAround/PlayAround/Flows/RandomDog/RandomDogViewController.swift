//
//  DogsViewController.swift
//  PlayAround
//
//  Created by Szymon Swietek on 29/07/2022.
//

import Combine
import SnapKit
import UIKit

protocol DogsViewControllerDelegate: AnyObject {
    func dogsViewControllerWantsToClose()
}

class RandomDogViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let viewModel: RandomDogViewModel
    weak var delegate: DogsViewControllerDelegate?
        
    init(viewModel: RandomDogViewModel, delegate: DogsViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        bindViewModel()
        viewModel.viewDidLoad()
        
    }
    
    private func bindViewModel() {
        viewModel.$state.compactMap { $0 }.sink { [unowned self] state in
            
            switch state {
            case .success(let images):
                self.showImages(images: images)
            case .loading:
                break
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                    self.delegate?.dogsViewControllerWantsToClose()
                }))
                self.present(alert, animated: true)
            }
        }.store(in: &cancellables)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
    }
    
    private func showImages(images: [UIImage]) {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        
        scrollView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }
        
        for image in images {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            imageView.snp.makeConstraints { make in
                make.height.equalTo(200)
            }
            
            stack.addArrangedSubview(imageView)
        }
    }
}
