//
//  NewsListTableViewCell.swift
//  NewsList
//
//  Created by Andrey Samchenko on 27.07.2023.
//

import UIKit
import SnapKit

protocol NewsListTableViewCellDelegate: AnyObject {
    func didTapImage(image: UIImage)
}

class NewsListTableViewCell: UITableViewCell {
    
    weak var delegate: NewsListTableViewCellDelegate?

    private var topView: HorizontalTitleWitchSubtitleView = {
        return $0
    }(HorizontalTitleWitchSubtitleView())
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 22.0)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel(frame: .zero))

    private let descriptionLabel: UILabel = {
        $0.text = "На что именно могут быть направлены деньги, источники не уточнили."
        
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel(frame: .zero))

    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        return gesture
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let actionFooterView: ActionFooterView = {
        return $0
    }(ActionFooterView())
    
    private let seporatorView: UIView = {
        $0.backgroundColor = .brown.withAlphaComponent(0.5)
        
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }

    func configure(
        title: String?,
        image: UIImage?,
        type: String?,
        date: Int?,
        commentCount: Int?,
        repostCount: Int?,
        likeCount: Int?,
        avatarImage: UIImage?
    ) {
        titleLabel.text = title
        thumbnailImageView.image = image
        topView.configure(
            HorizontalTitleWitchSubtitleViewModel(
                title: type ?? "",
                subTitle: formatTimeAgo(timeInt: date ?? 0),
                image: avatarImage
            )
        )
        actionFooterView.configure(
            ActionFooterViewModel(
                commentCount: commentCount,
                repostCount: repostCount,
                likeCount: likeCount
            )
        )
    }

    private func setupConstraints() {
        contentView.addSubview(topView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(actionFooterView)
        contentView.addSubview(seporatorView)
        thumbnailImageView.addGestureRecognizer(tapGesture)
        thumbnailImageView.isUserInteractionEnabled = true
        
        topView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.5) // Пусть высота изображения будет половиной ширины
        }

        actionFooterView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        seporatorView.snp.makeConstraints {
            $0.top.equalTo(actionFooterView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(16)
        }
    }

    func formatTimeAgo(timeInt: Int) -> String {
        let periods: [(String, Int)] = [
            ("день", 86400),
            ("час", 3600),
        ]

        let currentTimeInt = Int(Date().timeIntervalSince1970)
        let timeDiff = currentTimeInt - timeInt

        if timeDiff < 0 {
            return "В будущем"
        }

        var remainingTime = timeDiff
        var timeAgoComponents = [String]()

        for (periodName, periodSeconds) in periods {
            if remainingTime >= periodSeconds {
                let numPeriods = remainingTime / periodSeconds
                let pluralSuffix = (numPeriods == 1) ? "" : (numPeriods > 4 ? "ов" : "а")
                let timeString = "\(numPeriods) \(periodName)\(pluralSuffix)"
                timeAgoComponents.append(timeString)
                remainingTime %= periodSeconds
            }
        }

        return timeAgoComponents.joined(separator: " и ")
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if let image = thumbnailImageView.image {
            delegate?.didTapImage(image: image)
        }
    }
}

