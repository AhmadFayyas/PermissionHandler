
//  Created by Yousef Younes on 2/19/18.
//  Copyright © 2018 Yousef Younes. All rights reserved.
//

import Foundation
import Contacts
import AddressBook
import UIKit
import Photos
import EventKit
import UserNotifications

//Enum used to specify which permission to request, add more to it and you can handle its call within _requestAccess_
enum PermissionType {
    case contacts
    case photos
    case events
    case notification
    case reminders
    //TODO: add more permission types
}

/**
 A simple iOS permission handler in Swift
 
 - Author: Yousef Younis
 */
class PermissionHandler {
    
    /**
     The main access point to this handler, in which you can specify which permission to request and a completion handler for the return value of the permission status.
     
     - parameter permissionType: an enum value of type PermissionType to specify which permission to be handled
     
     - parameter completionHandler: a handler with a return value of Bool indicating if the permission is granted or not
     -  accessGranted: the retunred Bool for indicating whether the permission is granted or not
     
     - Author: Yousef Younis
     */
    
    class func requestAccess(permissionType:PermissionType, completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        // call the corresponding function for each permission
        switch permissionType {
        case .contacts:
            requestContactsPermission(completionHandler)
            
        case .photos:
            requestPhotoLibraryAccess(completionHandler)
            
        case .reminders:
            requestRemindersPermission(completionHandler)
            
        case .events:
            requestEventsPermission(completionHandler)
            
        case .notification:
            requestNotificationAccess(completionHandler)
        }
    }
    
    /* All of the below code is called privately by _requestAccess_ */
    
    /// handles granting and checking contacts access permission
    private class func requestContactsPermission( _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            completionHandler(granted)
        }
    }
    
    /// handle granting and checking Photo/Video acceess permission
    private class func requestPhotoLibraryAccess( _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization({ (photosStatus:PHAuthorizationStatus) in
            completionHandler(photosStatus == .authorized ? true : false)
        })
    }
    
    /// handles granting and checking Events access permission, referred to by the OS as Calendar
    private class func requestEventsPermission( _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        EKEventStore().requestAccess(to: .event, completion: { (granted, error) in
            completionHandler(granted)
        })
    }
    
    /// handles granting and checking Reminders access permission, which uses the same EKEventStore as Events but is handled with seperate permissions and reading/writing methods
    private class func requestRemindersPermission( _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        EKEventStore().requestAccess(to: .reminder, completion: { (granted, error) in
            completionHandler(granted)
        })
        
    }
    
    
    ///handles notification access permission
    private class func requestNotificationAccess( _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            completionHandler(granted)
        }
    }
}

