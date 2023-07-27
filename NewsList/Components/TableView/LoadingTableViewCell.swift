//
//  LoadingTableViewCell.swift
//  NewsList
//
//  Created by Andrey Samchenko on 27.07.2023.
//

import UIKit

public class LoadingTableViewCell: UITableViewCell {

    public private(set) lazy var loadingView: LoadingView = {
        return $0
    }(LoadingView(frame: .zero))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
