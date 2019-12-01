//
//  CommonViewController.swift
//  PickerImages
//
//  Created by Trinh Thai on 12/1/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    private func setupNavigation() {
        if let naviController = navigationController {
            let naviBar = naviController.navigationBar
            naviBar.isTranslucent = false
            naviBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            // Bar button color
            naviBar.tintColor = .white
            // Navigation background color
            naviBar.barTintColor = UIColor(hexString: "D80B24")
            // Remove the navigation shadow
            naviBar.setBackgroundImage(UIImage(), for: .default)
            naviBar.shadowImage = UIImage()
        }
    }
}
