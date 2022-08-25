//
//  CircularGradientMeter.swift
//  PlayAround
//
//  Created by Szymon Swietek on 25/08/2022.
//

import UIKit

class CircularGradientMeter: UIView {
    private var backgroundLayer: CAShapeLayer?
    private var frontLayer: CAGradientLayer?
    private let lineWidth: CGFloat = 15

    private let primaryColor: UIColor
    private let secondaryColor: UIColor
    private let meterBackgroundColor: UIColor
    private let textColor: UIColor

    var fillPercentage = 0 {
        didSet {
            drawProgress()
            setValueText()
        }
    }

    override var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    private lazy var percentageValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    init(primaryColor: UIColor, secondaryColor: UIColor, meterBackgroundColor: UIColor, textColor: UIColor) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.meterBackgroundColor = meterBackgroundColor
        self.textColor = textColor
        super.init(frame: CGRect.zero)

        addSubviews()
        setValueText()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawProgress() {
        setNeedsDisplay()
    }

    private func setValueText() {
        let valueAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 76, weight: .bold),
                         NSAttributedString.Key.foregroundColor: textColor]
        let attrString = NSMutableAttributedString(string: "\(fillPercentage)",
                                                   attributes: valueAttr)

        let percentSignAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26),
                               NSAttributedString.Key.foregroundColor: textColor]
        attrString.append(NSMutableAttributedString(string: "%",
                                                    attributes: percentSignAttr))

        percentageValueLabel.attributedText = attrString
    }

    private func addSubviews() {
        addSubview(percentageValueLabel)
        percentageValueLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    override func draw(_ rect: CGRect) {
        backgroundLayer?.removeFromSuperlayer()
        frontLayer?.removeFromSuperlayer()
        backgroundLayer = drawSlice(rect: rect, percent: 100, color: meterBackgroundColor)
        layer.addSublayer(backgroundLayer!)

        let fillLayer = drawSlice(rect: rect,
                                  percent: fillPercentage.clamped(to: 0 ... 100),
                                  color: UIColor.black)

        let gradient = CAGradientLayer()
        gradient.colors = [primaryColor.cgColor, secondaryColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = rect

        gradient.mask = fillLayer
        frontLayer = gradient
        layer.addSublayer(frontLayer!)
    }

    private func drawSlice(rect: CGRect, percent: Int, color: UIColor) -> CAShapeLayer {
        let trimmedPercent = percent >= 0 ? percent : 0
        let zeroAngle = CGFloat.pi

        let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.height - lineWidth / 2)
        let radius = rect.width / 2 - lineWidth / 2

        let val = CGFloat.pi * CGFloat(trimmedPercent) / 100
        let startAngle: CGFloat = zeroAngle
        let endAngle: CGFloat = zeroAngle + val
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        return shapeLayer
    }
}
