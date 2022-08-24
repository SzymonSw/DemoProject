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
    enum Constatns {
        static let imageHeight: CGFloat = 200
        static let imagesSpacing: CGFloat = 10
    }
    var cancellables = Set<AnyCancellable>()
    
    let viewModel: RandomDogViewModel
    weak var delegate: DogsViewControllerDelegate?
    
    let loadingView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        return indicatorView
    }()
    
    lazy var redoButton = UIBarButtonItem(systemItem: .refresh, primaryAction: UIAction(handler: { [unowned self] _ in
        self.viewModel.redoTapped()
    }), menu: nil)
    
    let scrollView = UIScrollView()
    var imagesStack: UIStackView?
        
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
                loadingView.stopAnimating()
                redoButton.isEnabled = true
                self.showImages(images: images)
            case .loading:
                imagesStack?.removeFromSuperview()
                loadingView.startAnimating()
                redoButton.isEnabled = false

            case .failure(let error):
                loadingView.stopAnimating()
                redoButton.isEnabled = true
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                    self.delegate?.dogsViewControllerWantsToClose()
                }))
                self.present(alert, animated: true)
            }
        }.store(in: &cancellables)
    }
    
    private func setupViews() {
        title = "Random Dogs"
        view.backgroundColor = .backgroundColor
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        navigationItem.setRightBarButton(redoButton, animated: false)
    }
    
    private func showImages(images: [UIImage]) {
        imagesStack = UIStackView()
        imagesStack!.axis = .vertical
        imagesStack!.spacing = Constatns.imagesSpacing
        
        scrollView.addSubview(imagesStack!)
        imagesStack!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }
        
        for image in images {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            imageView.snp.makeConstraints { make in
                make.height.equalTo(Constatns.imageHeight)
            }
            
            imagesStack!.addArrangedSubview(imageView)
        }
    }
}
