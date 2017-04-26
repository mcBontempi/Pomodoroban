//
//  SectionSelectTableViewController.swift
//  Pomodoroban
//
//  Created by mcBontempi on 26/04/2017.
//  Copyright © 2017 LondonSwift. All rights reserved.
//

import UIKit

protocol SectionSelectTableViewControllerDelegate {
    func sectionSelectTableViewController(sectionSelectTableViewController:SectionSelectTableViewController, didSelectTitles: [String])
    
    func sectionSelectTableViewControllerCancelled(sectionSelectTableViewController:SectionSelectTableViewController)

}

class SectionSelectTableViewController: UITableViewController {

    var delegate:SectionSelectTableViewControllerDelegate!
    var sectionTitles:[String]!
    var selectedSectionTitles:[String]!
    @IBAction func okPressed(_ sender: Any) {
        self.delegate.sectionSelectTableViewController(sectionSelectTableViewController: self, didSelectTitles: self.selectedSectionTitles)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.delegate.sectionSelectTableViewControllerCancelled(sectionSelectTableViewController: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionSelectCellIdentifier", for: indexPath)
        cell.textLabel?.text = sectionTitles[indexPath.row]
//        cell.isSelected = self.selectedSectionTitles.contains(self.sectionTitles[indexPath.row])
        return cell
    }
    

}
