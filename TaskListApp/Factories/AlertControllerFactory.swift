//
//  AlertControllerFactory.swift
//  TaskListApp
//
//  Created by Лилия Андреева on 26.11.2023.
//

import Foundation
import UIKit

protocol AlertControllerActionFactory {
    func createAlertAction() -> UIAlertAction
}

final class FilledAlertControllerActionFactory {
    let title: String
    let style: UIAlertAction.Style
    
    init(title: String, style: UIAlertAction.Style) {
        self.title = title
        self.style = style
    }
    
}

extension FilledAlertControllerActionFactory: AlertControllerActionFactory {
    func createAlertAction() -> UIAlertAction {
        let alertAction = UIAlertAction(
         title: title,
         style: style)
        
        
        return alertAction
    }
}

