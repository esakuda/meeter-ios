//
//  SettingsViewController.swift
//  Meeter
//
//  Created by Damian on 8/2/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation

class SettingsViewController : UITableViewController {
    
    let repository = LoginRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0 && indexPath.section == 1) {
            self.repository.logout( {
                    self.navigationController?.popToRootViewControllerAnimated(false)
                }, failure:{
                    self.view.makeToast("No se pudo desloguear", duration: 2.0, position: CSToastPositionBottom)
            })
        }
    }
    
}