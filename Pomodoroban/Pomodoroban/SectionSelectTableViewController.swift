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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    @IBAction func okPressed(_ sender: Any) {
        
        print(self.selectedSectionTitles)
        
        self.delegate.sectionSelectTableViewController(sectionSelectTableViewController: self, didSelectTitles: self.selectedSectionTitles)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.delegate.sectionSelectTableViewControllerCancelled(sectionSelectTableViewController: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionSelectCellIdentifier", for: indexPath) as! SectionSelectTableViewCell
            cell.sectionLabel?.text = sectionTitles[indexPath.row]
        
        let selected = self.selectedSectionTitles.contains(self.sectionTitles[indexPath.row])
        
        if (selected == true) {
            
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        print(selected)
        
        cell.isSelected = selected
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSectionTitles.append(self.sectionTitles[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedSectionTitles.remove(at: self.selectedSectionTitles.index(of: self.sectionTitles[indexPath.row])!)
    }

}
