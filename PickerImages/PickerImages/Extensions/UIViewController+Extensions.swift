//
//  UIViewController+Extensions.swift
//  PickerImages
//
//  Created by Trinh Thai on 12/1/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showNormalAlert(title: String, with completeHandler: @escaping (UIAlertAction) -> Void)  {
        let alert = UIAlertController(title: nil, message:title , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: completeHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlert(message: String, with completeHandler: @escaping (UIAlertAction) -> Void){
        let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 17.0)!]
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        deleteAlert.setValue(messageAttrString, forKey: "attributedMessage")
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler:{ (UIAlertAction)in
            print("Clicked Cancel")
        })
        let lightBrownColor = UIColor(hexString: "E3A666")
        cancelAction.setValue(lightBrownColor, forKey: "titleTextColor")
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: completeHandler))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
}
