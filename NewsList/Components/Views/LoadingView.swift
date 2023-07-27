//
//  LoadingView.swift
//  NewsList
//
//  Created by Andrey Samchenko on 27.07.2023.
//

import UIKit
import SnapKit

public class LoadingView: UIView {

    @objc public dynamic var progress: Progress? {
        didSet {
            guard
                oldValue == nil,
                progress != nil
            else {
                return
            }
            if let progress = progress {
                setupProgress(progress)
            } else {
                resetProgress()
            }
        }
    }

    public var timingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
    public var duration: TimeInterval = 2.0

    public let indicatorLayer = CAShapeLayer()
    public let circleLayer = CAShapeLayer()
    private let circleColor: UIColor
    private let indicatorColor: UIColor
    private var statusAnimation = false
    private var progressObservation: NSKeyValueObservation?
    private var isFinishedObservation: NSKeyValueObservation?
    private var progressValue: CGFloat = 0.0

    var completion: (() -> Void)?
    var pausingHandler: (() -> Void)?
    var resumingHandler: (() -> Void)?
    var cancellationHandler: (() -> Void)?

    var isAnimating: Bool {
        return statusAnimation
    }

    public init(
        frame: CGRect = .zero,
        circleColor: UIColor = .red,
        indicatorColor: UIColor = .black
    ) {
        self.circleColor = circleColor
        self.indicatorColor = indicatorColor
        super.init(frame: frame)
        setup()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        circleColor = .red
        indicatorColor = .black
        super.init(coder: aDecoder)
        setup()
    }

    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        guard statusAnimation && !isHidden else { return }
        DispatchQueue.main.async { [weak self] in
            self?.indicatorLayer.removeAllAnimations()
            self?.animateIndicator()
        }
    }

    private func animateIndicator() {
        CATransaction.begin()
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        if self.progress == nil {
            self.indicatorLayer.strokeEnd = 0.25
        }
        self.indicatorLayer.add(rotation, forKey: "rotationAnimation")
        CATransaction.commit()
    }

    public func startAnimating() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isHidden = false
            if !self.statusAnimation {
                self.animateIndicator()
                self.statusAnimation.toggle()
            }
        }
    }

    public func finishAnimating() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isHidden = true
            if self.statusAnimation {
                self.indicatorLayer.removeAnimation(forKey: "rotationAnimation")
                self.statusAnimation.toggle()
            }
        }
    }

    private func setup() {
        isHidden = true
        let maxWidth = max(frame.width, frame.height)
        let circleSize = (frame == .zero)
            ? CGSize(width: 20, height: 20)
            : CGSize(width: maxWidth, height: maxWidth)

        let circlePath = UIBezierPath(
            arcCenter: CGPoint.zero,
            radius: circleSize.height / 2,
            startAngle: 0.0,
            endAngle: CGFloat(Double.pi * 2.0),
            clockwise: true
        )

        let indicatorPath = UIBezierPath(
            arcCenter: CGPoint.zero,
            radius: circleSize.height / 2,
            startAngle: 0.0,
            endAngle: CGFloat(Double.pi * 2.0),
            clockwise: true
        )

        let сircle = UIView()
        сircle.backgroundColor = .clear

        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = circleColor.cgColor
        circleLayer.lineWidth = 2.0
        circleLayer.strokeEnd = 1.0
        circleLayer.position = CGPoint(x: circleSize.width / 2, y: circleSize.height / 2)

        indicatorLayer.path = indicatorPath.cgPath
        indicatorLayer.fillColor = UIColor.clear.cgColor
        indicatorLayer.strokeColor = indicatorColor.cgColor
        indicatorLayer.lineWidth = 2.0
        indicatorLayer.strokeEnd = 0.25
        indicatorLayer.position = CGPoint(x: circleSize.width / 2, y: circleSize.height / 2)

        сircle.layer.addSublayer(circleLayer)
        сircle.layer.addSublayer(indicatorLayer)
        addSubview(сircle)

        сircle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(circleSize.width)
            make.height.equalTo(circleSize.height)
        }
    }

    private func resetProgress() {
        indicatorLayer.strokeEnd = 0.25
    }

    private func setupProgress(_ progress: Progress) {
        if progress.totalUnitCount < 0 {
            setProgress(1)
            completion?()
        } else {
            setProgress(0)
        }
        progress.pausingHandler = { [weak self] in
            self?.pausingHandler?()
        }
        progress.resumingHandler = { [weak self] in
            self?.resumingHandler?()
        }
        progress.cancellationHandler = { [weak self] in
            self?.cancellationHandler?()
        }
        progressObservation = observe(\.progress?.fractionCompleted, options: [.old, .new], changeHandler: { [weak self] _, change in
            guard
                let self = self,
                let oldValue = change.oldValue,
                let newValue = change.newValue,
                let oldValueUnwraped = oldValue,
                let newValueUnwraped = newValue,
                (newValueUnwraped - oldValueUnwraped) >= 0.01
            else {
                return
            }
            DispatchQueue.main.async {
                self.setProgress(Float(newValueUnwraped))
            }
        })
        isFinishedObservation = observe(\.progress?.isFinished, options: [.new], changeHandler: { [weak self] _, change in
            guard let self = self,
                  let finished = change.newValue,
                  finished == true else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [weak self] in
                self?.completion?()
            })
        })
    }

    public func setProgress(_ value: Float) {
        layoutIfNeeded()
        let value = CGFloat(min(value, 1.0))
        let oldValue = indicatorLayer.presentation()?.strokeEnd ?? progressValue
        progressValue = value
        indicatorLayer.strokeEnd = progressValue
        CATransaction.begin()
        let path = #keyPath(CAShapeLayer.strokeEnd)
        let fill = CABasicAnimation(keyPath: path)
        fill.fromValue = oldValue
        fill.toValue = value
        fill.duration = duration
        fill.timingFunction = timingFunction
        indicatorLayer.add(fill, forKey: "fill")
        CATransaction.commit()
    }
}
