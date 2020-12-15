//
//  RecordsTableViewController.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/14/20.
//

import UIKit

class RecordsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Game.shared.records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "record", for: indexPath)
        let record = Game.shared.records[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let strDate = dateFormatter.string(from: record.date)
        
        cell.textLabel?.text = "\(strDate):   \(record.value)/5"
        return cell
    }

}
