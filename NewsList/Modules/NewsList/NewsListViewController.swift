//
//  NewsListViewController.swift
//  NewsList
// 
//  Created by Andrey Samchenko on 27.07.2023.
//

import UIKit
import SnapKit
import Alamofire

class NewsListViewController: UIViewController {
    
    var dataSource: NewsListPresenterDataSource?
    
    private var newsLineModel: [NewLineModel.Item] = []
    
    private var isLoadingList = false {
        didSet {
            if oldValue && !isLoadingList {
                tableView.performBatchUpdates {
                    tableView.reloadSections(.init(integer: 1), with: .bottom)
                }
            }
        }
    }

    private var scrollView: UIScrollView = {
        return $0
    }(UIScrollView())

    private lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.register(NewsListTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        $0.register(LoadingTableViewCell.self, forCellReuseIdentifier: "LoadingTableViewCell")
        return $0
    }(UITableView(frame: .zero))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        tableView.delegate = self
        tableView.dataSource = self
        dataSource?.fetch(objectFor: self)
        addSubview()
        setupConstraints()
    }

    init(dataSource: NewsListPresenterDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    private func canRequestNext(_ scrollView: UIScrollView) -> Bool {
        return isTableViewAtBottom() && !isLoadingList && (dataSource?.lastId != 0)
    }
    
    private func isTableViewAtBottom() -> Bool {
        let contentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.bounds.height
        let contentOffsetY = tableView.contentOffset.y
        
        return contentOffsetY >= (contentHeight - tableViewHeight)
    }
}


// MARK: - UICollectionViewDataSource
extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return isLoadingList ? 1 : 0
        } else {
            return newsLineModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! NewsListTableViewCell
        if indexPath.section == 0 {
            let item = newsLineModel[indexPath.item]
            cell.delegate = self
            cell.configure(
                title: item.title,
                image: UIImage(named: "image1"),
                type: item.type,
                date: item.createDate,
                commentCount: item.comments,
                repostCount: item.reposts,
                likeCount: item.likes,
                avatarImage: item.avatarImage
            )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell
            cell.loadingView.startAnimating()
            return cell
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if canRequestNext(scrollView) {
            isLoadingList = true
            tableView.performBatchUpdates {
                tableView.reloadSections(.init(integer: 1), with: .bottom)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else {
                    return
                }
                self.dataSource?.fetch(objectFor: self)
            }
        }
    }
}

extension NewsListViewController: NewsListViewViewer {
    func setIsLoadingList(_ value: Bool) {
        isLoadingList = value
    }
    
    func setNewLineModel(_ model: [NewLineModel.Item]) {
        newsLineModel = model
        isLoadingList = false
        tableView.reloadData()
    }
    
    func showError(code: String, message: String?) {
        isLoadingList = false
        let alert = UIAlertController(title: code, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension NewsListViewController: NewsListTableViewCellDelegate {
    func didTapImage(image: UIImage) {
        let fullScreenImageVC = FullScreenImageViewController()
        fullScreenImageVC.setImage(image)
        
        let navigationController = UINavigationController(rootViewController: fullScreenImageVC)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .overFullScreen
        
        present(navigationController, animated: false) {
            UIView.animate(withDuration: 0.3) {
                fullScreenImageVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            }
        }
    }
}
