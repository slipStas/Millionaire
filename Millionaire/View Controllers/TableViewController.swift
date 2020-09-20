//
//  TableViewController.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    private var records: [GameSession] = []
    
    @IBOutlet weak var recordsTableView: UITableView! {
        didSet {
            self.recordsTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let records = try? GameCaretaker.shared.load() else {return}
        self.records = records
        recordsTableView.reloadData()
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordsTableView.dequeueReusableCell(withIdentifier: "recordsTableViewCell", for: indexPath)
        
        let record = records[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm:ss, EEE, d MMM, yyyy"
        
        cell.textLabel?.text = record.value + "₽"
        cell.detailTextLabel?.text = dateFormatter.string(from: record.date)
        
        return cell
    }
}
