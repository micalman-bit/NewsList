//
//  FullScreenImageViewController.swift
//  NewsList
//
//  Created by Andrey Samchenko on 27.07.2023.
//

import UIKit
import SnapKit

class FullScreenImageViewController: UIViewController {
    
    private var scrollView: UIScrollView = {
        $0.maximumZoomScale = 4.0
        $0.minimumZoomScale = 1.0
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    private var imageView: UIImageView = {
        $0.alpha = 0.0
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        scrollView.delegate = self
        addSubview()
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        view.addGestureRecognizer(tapGesture)
    }
    
    public func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    private func addSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        UIView.animate(withDuration: 0.3) {
            self.imageView.alpha = 1.0
        }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    private func centerImageView() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2.0
        } else {
            frameToCenter.origin.x = 0.0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2.0
        } else {
            frameToCenter.origin.y = 0.0
        }
        
        imageView.frame = frameToCenter
    }

    @objc func dismissFullScreenImage() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.backgroundColor = .clear
            self?.imageView.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        })
    }
}

extension FullScreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }
}
