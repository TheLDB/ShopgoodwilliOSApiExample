//
//  getAllAuctions.swift
//  ShopGoodwillAPI
//
//  Created by Landon Boles on 1/5/22.
//

import Foundation
import SwiftyJSON


// Please make changes to the code in SearchTableViewController.swift now

struct BrowseListingInfo: Decodable {
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

struct SingleListing: Decodable {
    let endTime: String
    let shipping: Float
    let insurance: Bool
    let bidIncrement: Float
    let handlingPrice: Float
    let isStock: Bool
    let discount: Float
    let pickupCountry: String
    let itemId: Int
    let categoryId: Int
    let sellerShipperName: String
    let currentPrice: Float
    let startTime: String
    let bidHistory: JSON
    let remainingTime: String
    let noCombineShipping: Bool
    let pickupZip: String
    let discountedBuyNowPrice: Float
    let sellerAllowPickup: Bool
    let sellerCompanyName: String
    let buyNowPrice: Float
    let isItemEndTimeExpire: Bool
    let inWatchlist: Bool
    let title: String
    let pickupOnly: Bool
    let isReserveMet: Bool
    let quantity: Int
    let displayWeight: Float
    let minimumBid: Float
    let sellerItemProfile: String
    let description: String
    let noInternationalShippingMessage: String
    let weight: Float
    let isAuction: Bool
    let imageUrlString: String
    let pickupCity: String
    let numberOfBids: Int
    let pickupHours: String
    let allowShippingCalculation: Bool
}
