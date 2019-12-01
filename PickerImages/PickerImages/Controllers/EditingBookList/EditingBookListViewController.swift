//
//  EditingBookListViewController.swift
//  PickerImages
//
//  Created by Trinh Thai on 12/1/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit

class EditingBookListViewController: CommonViewController {
    @IBOutlet weak var ibTableView: UITableView!
    var numberOfRow = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        ibTableView.delegate = self
        ibTableView.dataSource = self
        
        let nib = UINib.init(nibName: "EditingBookTableViewCell", bundle: nil)
        ibTableView.register(nib, forCellReuseIdentifier: "EditingBookTableViewCell")
        ibTableView.tableFooterView = UIView()
    }
}

extension EditingBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EditingBookTableViewCell", for: indexPath) as? EditingBookTableViewCell {
            cell.ibDeleteButton.tag = indexPath.row
            cell.deleteActionHandler = { index in
                self.showDeleteAlert(message: "Do you want delete this row?", with: { _ in
                    print(index)
                    self.numberOfRow -= 1
                    self.ibTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.ibTableView.reloadData()
                })
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
