//
//  NewsListModels.swift
//  NewsList
//
//  Created by Andrey Samchenko on 26.07.2023.
//

import Foundation
import UIKit

struct AttachImage: Decodable {
    let id: String?
    let uuid: String?
    let additionalData: String?
    let type: String?
    let color: String?
    let width: Int?
    let height: Int?
    let size: Int?
    let name: String?
    let origin: String?
    let title: String?
    let description: String?
    let url: String?
}

struct Attach: Decodable {
    let id: String?
    let uuid: String?
    let additionalData: String?
    let type: String?
    let color: String?
    let width: Int?
    let height: Int?
    let size: Int?
    let name: String?
    let origin: String?
    let title: String?
    let description: String?
    let url: String?
    let image: AttachImage?
}

struct SubsiteSmall: Decodable {
    let id: Int?
    let type: Int?
    let name: String?
    let description: String?
    let avatar: Attach?
    let isSubscribed: Bool?
    let isFavorited: Bool?
    let isVerified: Bool?
    let isOnline: Bool?
    let isMuted: Bool?
    let isUnsubscribable: Bool?
    let isEnabledCommentEditor: Bool?
    let commentEditor: CommentEditor?
    let isAvailableForMessenger: Bool?
}

struct CommentEditor: Decodable {
    let enabled: Bool?
    let who: String?
    let text: String?
    let until: String?
    let reason: String?
}

struct SocialAccount: Decodable {
    let id: Int?
    let type: Int?
    let username: String?
    let title: String?
    let url: String?
}

struct Site: Decodable {
    let title: String?
    let url: String?
}

struct Contacts: Decodable {
    let socials: [SocialAccount]?
    let site: Site?
    let email: String?
    let contacts: String?
}

struct Likes: Decodable {
    let summ: Int?
    let counter: Int?
    let isLiked: Int?
}

struct EtcControls: Decodable {
    let editEntry: Bool?
    let pinContent: Bool?
    let unpublishEntry: Bool?
    let banSubsite: Bool?
    let pinComment: Bool?
    let removeThread: Bool?
}

struct Subsite: Decodable {
    let id: Int?
    let type: Int?
    let name: String?
    let description: String?
    let avatar: Attach?
    let cover: Attach?
    let created: Int?
    let url: String?
    let hashtags: [String]?
    let isSubscribed: Bool?
    let isVerified: Bool?
    let isOnline: Bool?
    let isMuted: Bool?
    let isUnsubscribable: Bool?
    let isEnableWriting: Bool?
    let isSubscribedToNewPosts: Bool?
    let rating: Int?
    let contacts: Contacts?
    let commentEditor: CommentEditor?
    let isAvailableForMessenger: Bool?
    let isPlus: Bool?
    let counters: [String: Int]?
    let threeSubscribers: [SubsiteSmall]?
    let threeSubscriptions: [SubsiteSmall]?
    let rules: String?
    let isFavorited: Bool?
    let counterSubscribers: Int?
    let isRecommended: Bool?
}
struct EntryBlockData: Decodable {
    let title: String?
}
struct EntryBlock: Decodable {
    let type: String?
    let data: EntryBlockData
//    let cover: Bool?
//    let anchor: String?
}

struct Counters: Decodable {
    
}
struct Entry: Decodable {
    let id: Int?
    let author: Subsite?
    let subsiteId: Int?
    let subsite: Subsite
    let title: String?
    let date: Int?
    let blocks: [EntryBlock]?
//    let html: [String: Int]?
    let counters: [String: Int]?
//    let commentsSeenCount: [String: Int]?
//    let dateFavorite: Int?
//    let hitsCount: Int?
//    let isCommentsEnabled: Bool?
//    let isLikesEnabled: Bool?
//    let isFavorited: Bool?
//    let isRepost: Bool?
    let likes: Likes?
//    let isPinned: Bool?
//    let canEdit: Bool?
//    let etcControls: EtcControls?
//    let repost: [String: Subsite]?
//    let isRepostedByMe: Bool?
//    let subscribedToTreads: Bool?
//    let isFlash: Bool?
//    let isBlur: Bool?
//    let isShowThanks: Bool?
//    let isStillUpdating: Bool?
//    let isFilledByEditors: Bool?
//    let isEditorial: Bool?
//    let isPromoted: Bool?
    let audioUrl: String?
//    let commentEditor: CommentEditor?
//    let coAuthor: Subsite?
}

struct Event: Decodable {
    let id: Int?
    let type: Int?
    let title: String?
    let archived: Bool?
    let city: String?
    let cityId: Int?
    let cityName: String?
    let price: String?
    let date: Int?
    let company: SubsiteSmall?
    let interested: Int?
    let address: String?
}

struct Vacancy: Decodable {
        let id: Int?
        let type: Int?
        let title: String?
        let city: String?
        let salary: String?
        let salaryTo: Int?
        let salaryFrom: Int?
        let archived: Bool?
        let area: Int?
        let areaText: String?
        let schedule: Int?
        let scheduleText: String?
//        let company: SubsiteSmall?
}

struct TimelineSubItem: Decodable {
        let type: String?
//        let data: [Event]? // or [Vacancy], depending on the 'type'
}


// MARK: - TimelineItem
enum TimelineItemType: String, Decodable {
    case news = "news"
    case entry = "entry"
    case vacancies = "vacancies"
    case events = "events"
    case onboarding = "onboarding"
    case flash = "flash"
    case rating = "rating"
}

// Не удалил ибо по свагеру могут прилетать 3 разних типа, но по факту прилетает один
//enum TimelineItemData: Decodable {
//    case timelineSubItem([TimelineSubItem])
//    case entry(Entry)
//    case none(Empty)
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let oneValue = try? container.decode(Entry.self) {
//            self = .entry(oneValue)
//        } else if let twoValue = try? container.decode([TimelineSubItem].self) {
//            self = .timelineSubItem(twoValue)
//        } else {
//            self = .none(Empty())
//        }
//    }
//}

struct TimelineItem: Decodable {
    let type: TimelineItemType?
    let data: Entry

//    enum CodingKeys: String, CodingKey {
//        case type, data
//    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        type = try container.decode(TimelineItemType.self, forKey: .type)
//        data = try container.decode(TimelineItemData.self, forKey: .data)
//    }
}


// MARK: - Result
struct Result: Decodable {
    let items: [TimelineItem]
    let lastId: Int? //
//    let lastSortingValue: String? //
}

// MARK: - TimelineData
struct ErrorResponse: Decodable {
    let code: Int?
}
struct TimelineDataResponseModel: Decodable {
    let result: Result?
    let error: ErrorResponse?
    let message: String?
}

struct NewLineModel {
    var item: [Item]
    
    struct Item {
        let type: String?
        let createDate: Int?
        let title: String?
        let description: String?
        let comments: Int?
        let favorites: Int?
        let reposts: Int?
        let likes: Int?
        let avatarUUID: String?
        var avatarImage: UIImage?
        
        init(_ model: Entry) {
            self.type = model.subsite.name
            self.createDate = model.date
            self.title = model.title
            self.description = "На что именно могут быть направлены деньги, источники не уточнили."
            self.comments = model.counters?["comments"]
            self.favorites = model.counters?["favorites"]
            self.reposts = model.counters?["reposts"]
            self.likes = model.likes?.summ
            self.avatarUUID = model.subsite.cover?.uuid
            self.avatarImage = UIImage(named: "blasco")
        }
    }
}
