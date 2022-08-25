//
//  SnapViewController.swift
//  PlayAround
//
//  Created by Szymon Swietek on 29/07/2022.
//

import SnapKit
import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func mainViewControllerWantsToShowRandomDog()
    func mainViewControllerWantsToShowSwiftUI()
}

class MainViewController: UIViewController {
    lazy var randomDogButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Random Dogs Batch", for: .normal)
        return button
    }()
    
    lazy var swiftUIButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Swift UI", for: .normal)
        return button
    }()
    
    let circularMeter = CircularGradientMeter(primaryColor: .primaryMeterColor,
                                              secondaryColor: .secondaryMeterColor,
                                              meterBackgroundColor: .backgroundMeterColor,
                                              textColor: .meterTextColor)

    weak var delegate: MainViewControllerDelegate?

    init(delegate: MainViewControllerDelegate) {
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
        
        circularMeter.fillPercentage = 75
    }
    
    private func bind() {
        randomDogButton.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.mainViewControllerWantsToShowRandomDog()
        }), for: .touchUpInside)
        
        swiftUIButton.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.mainViewControllerWantsToShowSwiftUI()
        }), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = .backgroundColor
        
        let stack = UIStackView()
        stack.axis = .vertical
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        stack.addArrangedSubview(randomDogButton)
        stack.addArrangedSubview(swiftUIButton)
        
        view.addSubview(circularMeter)
        circularMeter.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.lessThanOrEqualTo(350)
            make.left.equalToSuperview().offset(16).priority(750)
            make.right.equalToSuperview().offset(-16).priority(750)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        circularMeter.setNeedsDisplay()
    }
}
