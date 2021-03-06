//
//  LMModels+Api+Community.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Api {
    enum Community {
        
        struct GetCommunity: Codable {
            let id: Int?
            let name: String?
            let auth: String?
        }
        
        struct GetCommunityResponse: Codable {
            let communityView: LMModels.Views.CommunityView
            let moderators: [LMModels.Views.CommunityModeratorView]
            let online: Int
            
            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
                case moderators, online
            }
        }
        
        struct CreateCommunity: Codable {
            let name: String
            let title: String
            let description: String?
            let icon: String?
            let banner: String?
            let categoryId: Int
            let nsfw: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, title, description, icon, banner
                case categoryId = "category_id"
                case nsfw, auth
            }
        }
        
        struct CommunityResponse: Codable {
            let communityView: LMModels.Views.CommunityView
            
            enum CodingKeys: String, CodingKey {
                case communityView = "community_view"
            }
        }
        
        struct ListCommunities: Codable {
            let type: LMModels.Others.ListingType
            let sort: LMModels.Others.SortType
            let page: Int?
            let limit: Int?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case type = "type_"
                case sort, page, limit, auth
            }
        }
        
        struct ListCommunitiesResponse: Codable {
            let communities: [LMModels.Views.CommunityView]
        }
        
        struct BanFromCommunity: Codable {
            let communityId: Int
            let userId: Int
            let ban: Bool
            let removeData: Bool // Removes/Restores their comments and posts for that community
            let reason: String?
            let expires: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case userId = "user_id"
                case ban
                case removeData = "remove_data"
                case reason, expires, auth
            }
        }
        
        struct BanFromCommunityResponse: Codable {
            let userView: LMModels.Views.UserViewSafe
            let banned: Bool
            
            enum CodingKeys: String, CodingKey {
                case userView = "user_view"
                case banned
            }
        }
        
        struct AddModToCommunity: Codable {
            let communityId: Int
            let userId: Int
            let added: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case userId = "user_id"
                case added, auth
            }
        }
        
        struct AddModToCommunityResponse: Codable {
            let moderators: [LMModels.Views.CommunityModeratorView]
        }
        
        /**
        * Only mods can edit a community.
        */
        struct EditCommunity: Codable {
            let communityId: Int
            let title: String
            let description: String?
            let icon: String?
            let banner: String?
            let categoryId: Int
            let nsfw: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case categoryId = "category_id"
                case title, description, icon, banner, nsfw, auth
            }
        }
        
        struct DeleteCommunity: Codable {
            let communityId: Int
            let deleted: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case deleted, auth
            }
        }
        
        struct RemoveCommunity: Codable {
            let communityId: Int
            let removed: Bool
            let reason: String?
            let expires: Int?
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case removed, reason, expires, auth
            }
        }
        
        struct FollowCommunity: Codable {
            let communityId: Int
            let follow: Bool
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case follow, auth
            }
        }
        
        struct GetFollowedCommunities: Codable {
            let auth: String
        }
        
        struct GetFollowedCommunitiesResponse: Codable {
            let communities: [LMModels.Views.CommunityFollowerView]
        }
        
        struct TransferCommunity: Codable {
            let communityId: Int
            let userId: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
                case userId = "user_id"
                case auth
            }
        }
    }
}
