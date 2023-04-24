//
//  CourseListViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 21/02/23.
//

import UIKit

final class CourseListViewController: UITableViewController {
    let entries = Course.allCourses()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Mata Kuliah"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let entry = entries[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "\(entry.id)\t" + entry.name
        cell.contentConfiguration = config
        
        return cell
    }


}
