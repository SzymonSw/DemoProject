//
//  SnapViewController.swift
//  PlayAround
//
//  Created by Szymon Swietek on 29/07/2022.
//

import SnapKit
import UIKit

protocol SnapViewControllerDelegate: AnyObject {
    func snapViewControllerWantsToShowRandomDog()
    func snapViewControllerWantsToShowSwiftUI()
}

class SnapViewController: UIViewController {
    lazy var randomDogButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Random Dogs", for: .normal)
        return button
    }()
    
    lazy var swiftUIButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Swift UI", for: .normal)
        return button
    }()
    
    weak var delegate: SnapViewControllerDelegate?

    init(delegate: SnapViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        bind()
    }
    
    private func bind() {
        randomDogButton.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.snapViewControllerWantsToShowRandomDog()
        }), for: .touchUpInside)
        
        swiftUIButton.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.snapViewControllerWantsToShowSwiftUI()
        }), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(randomDogButton)
        randomDogButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(swiftUIButton)
        swiftUIButton.snp.makeConstraints { make in
            make.top.equalTo(randomDogButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
}
