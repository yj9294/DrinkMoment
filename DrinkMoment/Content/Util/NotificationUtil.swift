//
//  NotificationUitl.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import Foundation
import UserNotifications

class NotificationUtil: NSObject {
    
    static let shared = NotificationUtil()

    // time eg: 08:32
    func appendReminder(_ time: ReminderModel) {
        
        deleteNotifications(time)

        if Date().isWeekend, CacheUtil.shared.weekMode {
            return
        }
        
        let noticeContent = UNMutableNotificationContent()
        noticeContent.title = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
        noticeContent.body = "The body needs energy, don't forget to drink water!"
        noticeContent.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time.timeSinceNowInSec, repeats: false)
        
        let request = UNNotificationRequest(identifier: time.title , content: noticeContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                debugPrint("[UN] 通知错误。\(error?.localizedDescription ?? "")")
            }
        }
        
    }
    
    func deleteNotifications(_ time: ReminderModel) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [time.title])
    }
    
    func register(completion: ((Bool)->Void)? = nil) {
        let noti = UNUserNotificationCenter.current()
        noti.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if granted {
                print("开启通知")
                completion?(true)
            } else {
                print("关闭通知")
                completion?(false)
            }
        }
        
        noti.getNotificationSettings { settings in
            print(settings)
        }
        
        noti.delegate = NotificationUtil.shared
    }
}

extension NotificationUtil: UNUserNotificationCenterDelegate {
    
    /// 应用内收到
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .list])
        let title = notification.request.identifier
        let reminder = ReminderModel.parse(title)
        NotificationUtil.shared.appendReminder(reminder)
        debugPrint("收到通知")
    }
    
    
    /// 点击应用外弹窗
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint("点击通知")
    }
}
