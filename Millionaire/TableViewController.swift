//
//  TableViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var recordsTableView: UITableView! {
        didSet {
            self.recordsTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordsTableView.dequeueReusableCell(withIdentifier: "recordsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = "qwe"
        cell.detailTextLabel?.text = "1234"
        
        return cell
    }
}
