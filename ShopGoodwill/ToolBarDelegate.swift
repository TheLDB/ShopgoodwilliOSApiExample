//
//  CGASceneDelegate+NSToolbar.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//  
//

import UIKit

#if targetEnvironment(macCatalyst)
import AppKit

extension NSToolbarItem.Identifier {
	static let back = NSToolbarItem.Identifier("com.example.back")
}

func updateTitlebarTitle(with: String, session: UISceneSession) {
    let windowScene = session.scene as! UIWindowScene
//    if runningOn == "iPad" {
//        windowScene.subtitle = with
//    } else if runningOn == "Mac" {
        windowScene.title = with
//    }
}
func updateTitlebarSubtitle(with: String, session: UISceneSession) {
    let windowScene = session.scene as! UIWindowScene
//    if runningOn == "Mac" {
        windowScene.subtitle = with
//    }
}

extension SceneDelegate: NSToolbarDelegate {
    
	func toolbarItems() -> [NSToolbarItem.Identifier] {
		return [.back]
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		if itemIdentifier == .back {
			
			let barItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: NSSelectorFromString("goBack:"))
			/*
			 NSToolbarItemGroup does not auto-enable/disable buttons based on the responder chain, so we need an NSToolbarItem here instead
			 */
			
			let item = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barItem)
			
			item.label = "Back"
			item.toolTip = "Back"
			item.isBordered = true
			item.isNavigational = true
			
			return item
		}
		
		return NSToolbarItem(itemIdentifier: itemIdentifier)
	}
}
#endif

extension AppDelegate {
    
    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == UIMenuSystem.context {
            return
        }
        
        super.buildMenu(with: builder)
        
        builder.remove(menu: .format)
        builder.remove(menu: .toolbar)
        builder.remove(menu: .newScene)
        
        /* Add 'Back' option to View menu */
        do {
            let command = UIKeyCommand(input: "[", modifierFlags: [.command], action: NSSelectorFromString("goBack:"))
            command.title = "Go Back"
            command.discoverabilityTitle = "Go Back"
            
            let menu = UIMenu(identifier: UIMenu.Identifier("GoBack"), options: .displayInline, children: [command])
            
            builder.insertChild(menu, atStartOfMenu: .view)
        }
    }
    
}
