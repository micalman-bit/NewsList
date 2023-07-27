//
//  HorizontalTitleWitchSubtitleView.swift
//  NewsList
//
//  Created by Andrey Samchenko on 27.07.2023.
//

import UIKit
import SnapKit

struct HorizontalTitleWitchSubtitleViewModel {
    let title: String
    let subTitle: String
    let image: UIImage?
}

class HorizontalTitleWitchSubtitleView: UIView {
    
    private let leftImageView: UIImageView = {
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.backgroundColor = .red
        $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        
        return $0
    }(UIImageView())

    private let titleLabel: UILabel = {
        $0.font = UIFont(name: "Roboto-Medium", size: 22)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel(frame: .zero))

    private let subTitle: UILabel = {
        $0.text = "На что именно могут быть направлены деньги, источники не уточнили."
        $0.font = UIFont(name: "Roboto-Medium", size: 22)
        $0.numberOfLines = 0
        $0.textColor = .gray
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel(frame: .zero))
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview()
        setupConstraints()
    }
    
    private let rightButton: UIButton = {
        $0.setImage(UIImage(named: "dots"), for: .normal)
        return $0
    }(UIButton())
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ model: HorizontalTitleWitchSubtitleViewModel) {
        titleLabel.text = model.title
        subTitle.text = model.subTitle
        leftImageView.image = model.image
    }
    
    private func addSubview() {
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(subTitle)
        addSubview(rightButton)
    }
    
    private func setupConstraints() {
        leftImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.height.width.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(leftImageView.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview().inset(16)
        }
        
        subTitle.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.top.bottom.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(rightButton.snp.leading)
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(subTitle.snp.centerY)
            $0.width.height.equalTo(22)
        }
    }
}

struct ActionFooterViewModel {
    let commentCount: Int?
    let repostCount: Int?
    let likeCount: Int?
}

class ActionFooterView: UIView {
    
    // MARK: Comment
    private let commentButton: UIButton = {
        $0.setImage(UIImage(named: "comment"), for: .normal)
        return $0
    }(UIButton())
    
    private let commentCountLabel: UILabel = {
        return $0
    }(UILabel())

    // MARK: Repost
    private let repostCountLabel: UILabel = {
        return $0
    }(UILabel())

    private let repostButtom: UIButton = {
        $0.setImage(UIImage(named: "repost"), for: .normal)
        return $0
    }(UIButton())
        
    // MARK: Bookmark
    private let bookmarkButtom: UIButton = {
        $0.setImage(UIImage(named: "bookmark"), for: .normal)
        return $0
    }(UIButton())


    // MARK: Like
    private let likeCountLabel: UILabel = {
        return $0
    }(UILabel())
    
    private let likeButtom: UIButton = {
        $0.setImage(UIImage(named: "bookmark"), for: .normal)
        return $0
    }(UIButton())

    private let dislikeButtom: UIButton = {
        $0.setImage(UIImage(named: "bookmark"), for: .normal)
        return $0
    }(UIButton())

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ model: ActionFooterViewModel) {
        commentCountLabel.text = String(model.commentCount ?? 0)
        repostCountLabel.text = String(model.repostCount ?? 0)
        likeCountLabel.text = String(model.likeCount ?? 0)
    }
    
    private func addSubview() {
        addSubview(commentButton)
        addSubview(commentCountLabel)
        addSubview(repostButtom)
        addSubview(repostCountLabel)
        addSubview(bookmarkButtom)
        addSubview(dislikeButtom)
        addSubview(likeButtom)
        addSubview(likeCountLabel)
    }
    
    private func setupConstraints() {
        commentButton.snp.makeConstraints {
            $0.height.width.equalTo(22)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(commentCountLabel.snp.centerY)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentButton.snp.trailing).offset(4)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        repostButtom.snp.makeConstraints {
            $0.height.width.equalTo(22)
            $0.leading.equalTo(commentCountLabel.snp.trailing).offset(20)
            $0.centerY.equalTo(repostCountLabel.snp.centerY)
        }
        
        repostCountLabel.snp.makeConstraints {
            $0.leading.equalTo(repostButtom.snp.trailing).offset(4)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
        }

        bookmarkButtom.snp.makeConstraints {
            $0.height.width.equalTo(22)
            $0.leading.equalTo(repostCountLabel.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualTo(dislikeButtom.snp.leading)
            $0.centerY.equalTo(repostCountLabel.snp.centerY)
        }

        likeButtom.snp.makeConstraints {
            $0.height.width.equalTo(22)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(likeCountLabel.snp.centerY)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(likeButtom.snp.leading).inset(-6)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        dislikeButtom.snp.makeConstraints {
            $0.height.width.equalTo(22)
            $0.trailing.equalTo(likeCountLabel.snp.leading).inset(-6)
            $0.centerY.equalTo(likeCountLabel.snp.centerY)
        }
    }
}
