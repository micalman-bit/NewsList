//
//  NewsListProtocol.swift
//  NewsList
//
//  Created by Andrey Samchenko on 27.07.2023.
//

protocol NewsListViewViewer: AnyObject {
    func setNewLineModel(_ model: [NewLineModel.Item])
    func setIsLoadingList(_ value: Bool)
    func showError(code: String, message: String?)
}

protocol NewsListPresenterDataSource: AnyObject {
    func fetch(objectFor view: NewsListViewViewer)
    var lastId: Int { get }
    var lastSortingValue: Int { get }
}
