//
//  getAllAuctions.swift
//  ShopGoodwillAPI
//
//  Created by Landon Boles on 1/5/22.
//

import Foundation


// Please make changes to the code in SearchTableViewController.swift now

struct BrowseListingInfo: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    let isFavorite: Bool
    let shippingPrice: Float
    let relistId: Int
    let numBids: Int
    let remainingTime: String
    let itemCount: Int
    let featured: Bool
    let categoryName: String
    let categoryId: Int
    let isStock: Bool
    let views: Int
    let itemgallery: Bool
    let buyNowPrice: Float
    let itemId: Int
    let imageStatus: Int
    let imageURL: String
    let galleryURL: String
    let endTime: String
    let discount: Float
    let gallery: Bool
    let title: String
    let discountedBuyNowPrice: Float
    let minimumBid: Float
    let description: String
    let startingPrice: Float
    let imagePurged: Bool
    let currentPrice: Float
    let itemfeatured: Bool
    let startTime: String
}
