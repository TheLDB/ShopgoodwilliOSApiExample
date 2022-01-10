//
//  Saved Auctions Data Model.swift
//  Saved Auctions Data Model
//
//  Created by Dylan McDonald on 9/19/21.
//  Copyright © 2021 Dylan McDonald. All rights reserved.
//

import CoreData
import UIKit

var savedAuctions: [NSManagedObject] = []

func getSavedAuctions() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.automaticallyMergesChangesFromParent = true
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedAuctions")
//    var sectionSortDescriptor: NSSortDescriptor
//    sectionSortDescriptor = NSSortDescriptor(key: "sortIndex", ascending: true)
//    let sortDescriptors = [sectionSortDescriptor]
//    fetchRequest.sortDescriptors = sortDescriptors
    do {
        savedAuctions = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch data. \(error), \(error.userInfo)")
    }
    //    NotificationCenter.default.post(name: Notification.Name("UpdateInformation"), object: nil)
}

/// Get Data
func SavedAuctionsTitle(forIndex: Int) -> String {
    return savedAuctions[forIndex].value(forKeyPath: "title") as? String ?? ""
}

func SavedAuctionsID(forIndex: Int) -> String {
    return savedAuctions[forIndex].value(forKeyPath: "itemID") as? String ?? ""
}
/// Save Data
func saveToSavedAuctionsCoreData(key: String, data: Any, forIndex: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.automaticallyMergesChangesFromParent = true
    let dataToSave = savedAuctions[forIndex]
    dataToSave.setValue(data, forKeyPath: key)
    do {
        managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save data. \(error), \(error.userInfo)")
    }
}

func SaveSavedAuctionsTitle(with: String, forIndex: Int) {
    saveToSavedAuctionsCoreData(key: "title", data: with, forIndex: forIndex)
}
func SaveSavedAuctionsID(with: String, forIndex: Int) {
    saveToSavedAuctionsCoreData(key: "itemID", data: with, forIndex: forIndex)
}

// Create New
func createNewSavedAuction(title: String, id: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.automaticallyMergesChangesFromParent = true
    let entity = NSEntityDescription.entity(forEntityName: "SavedAuctions", in: managedContext)!
    let dataToSave = NSManagedObject(entity: entity, insertInto: managedContext)
    dataToSave.setValue(title, forKeyPath: "title")
    dataToSave.setValue(id, forKeyPath: "itemID")
    do {
        managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        try managedContext.save()
        savedAuctions.append(dataToSave)
    } catch let error as NSError {
        print("Could not save data. \(error), \(error.userInfo)")
    }
}

// Delete
func deleteAllDataForSavedAuction(forIndex: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.automaticallyMergesChangesFromParent = true
    
    let company = savedAuctions[forIndex]
    managedContext.delete(company)
    do {
        managedContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        try managedContext.save()
    } catch let error as NSError {
        print("Error While Deleting Note: \(error.userInfo)")
        
    }
    getSavedAuctions()
}

var allSavedAuctionIDs: [String] {
    var toReturn: [String] = []
    if savedAuctions.count > 0 {
        for index in 0...savedAuctions.count - 1 {
            toReturn.append(SavedAuctionsID(forIndex: index))
        }
    }
    return toReturn
}
