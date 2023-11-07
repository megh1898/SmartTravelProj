//
//  Extension.swift
//  SmartTravel 1
//
//  Created by Invotyx Mac on 07/11/2023.
//

import Foundation
import SwiftUI

extension View {
    
    /**with this function we can create alert with textfield**/
    func alertTF(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String) -> (), secondaryAction: @escaping() -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field  in
            field.placeholder = hintText
        }
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))
        rootViewController().present(alert, animated: true, completion: nil)
    }
    
    
    func rootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    func removeSpaces(from string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
}
