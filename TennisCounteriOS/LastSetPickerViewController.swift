//
//  LastSetPicker.swift
//  TennisCounteriOS
//
//  Created by rmounier on 01/09/2017.
//  Copyright © 2017 rmounier. All rights reserved.
//

import UIKit

class LastSetPickerViewController: UIViewController {
    
    //passer les param lors de la création du viewcontroller avant de le push
    //utiliser l'enum au maximum
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: lastSetDelegate!
    
    
}


extension LastSetPickerViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainViewController.choicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "choice")
        
        if cell==nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "choice")
        }
        
        cell.textLabel?.text = MainViewController.choicesArray[indexPath.row].rawValue
        
        
        return cell
    }
    
}


extension LastSetPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate.onReturnChoice(indexChoice: indexPath.row)
        
        navigationController?.popViewController(animated: true)
    }
}

protocol lastSetDelegate{
    func onReturnChoice(indexChoice: Int)
}


