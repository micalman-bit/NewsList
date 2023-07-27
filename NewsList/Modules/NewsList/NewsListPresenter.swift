//
//  NewsListPresenter.swift
//  NewsList
//
//  Created by Andrey Samchenko on 27.07.2023.
//

import Foundation
import Alamofire
import Kingfisher

class NewsListPresenter {
    
    // MARK: - Private property
    private weak var viewer: NewsListViewViewer?
        
    private var newsLineModel: [NewLineModel.Item] = []
    
    var lastId: Int = 0
    var lastSortingValue: Int = 0

    init(
    ) {
    }

    deinit {
    }
}

// MARK: - NewsListPresenterDataSource
extension NewsListPresenter: NewsListPresenterDataSource {
    func fetch(objectFor view: NewsListViewViewer) {
        self.viewer = view
        makeTimelineRequest()
    }
}

fileprivate extension NewsListPresenter {
    func makeTimelineRequest() {
        print("makeTimelineRequest!!!")
        let baseURL = "https://api.dtf.ru/v2.1"
        
        let endpoint = "/timeline"
        
        var url = "\(baseURL)\(endpoint)?allSite=false&sorting=day"
        if lastId != 0 {
            url = url + "&lastId=\(String(lastId))"
        }

        let headers: HTTPHeaders = [
            "X-Device-Token": "07c9b788thisistoken0d5da517285263715531"
        ]
        
        AF.request(url, method: .get, headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let decoder = JSONDecoder()
                    let apiResponse = try decoder.decode(TimelineDataResponseModel.self, from: jsonData)
                    guard let self = self else { return }
                    if let result = apiResponse.result {
                        self.lastId = apiResponse.result?.lastId ?? 0
                        self.lastSortingValue = apiResponse.result?.lastId ?? 0
                        
                        let newNewsLineModel = NewLineModel(
                            item: result.items.map {
                                NewLineModel.Item($0.data)
                            }
                        )
                        
                        self.newsLineModel.append(contentsOf: newNewsLineModel.item)
                        self.viewer?.setIsLoadingList(false)
                        self.viewer?.setNewLineModel(self.newsLineModel)
                    } else if let error = apiResponse.error {
                        self.viewer?.showError(
                            code: String(error.code ?? 0),
                            message: apiResponse.message
                        )
                        self.viewer?.setIsLoadingList(false)
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    self?.viewer?.setIsLoadingList(false)
                }
            case .failure(let error):
                print("Error: \(error)")
                self?.viewer?.setIsLoadingList(false)
                self?.viewer?.showError(
                    code: "Ошибка",
                    message: ""
                )
            }
        }
    }
    
//    func loadAvatarImagesForItems(_ items: [NewLineModel.Item]) {
//        var newModel: [NewLineModel.Item] = []
//        for item in items {
//            // Вызываем метод загрузки изображения для каждого элемента
//            var i = item
//            loadImageForItem(item) { image in
//                // Присваиваем загруженное изображение в avatarImage элемента
//                i.avatarImage = image
//            }
//            newModel.append(i)
//        }
//        print("WowWOw")
//        print(newModel)
//        self.viewer?.setNewLineModel(newModel)
//    }
//
//    func loadImageForItem(_ item: NewLineModel.Item, completion: @escaping (UIImage?) -> Void) {
//        guard let avatarUUID = item.avatarUUID else {
//            completion(nil)
//            return
//        }
//
//        let url = URL(string: "https://leonardo.osnova.io/\(avatarUUID)")!
//
//        KingfisherManager.shared.retrieveImage(with: url) { result in
//            switch result {
//            case .success(let value):
//                completion(value.image)
//            case .failure(let error):
//                completion(nil)
//            }
//        }
//    }
}
