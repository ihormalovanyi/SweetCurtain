//
//  StartViewController.swift
//  SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 03.01.2020.
//  Copyright © 2020 Ihor Malovanyi. All rights reserved.
//

import UIKit
import SweetCurtain

class StartViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Code usage
        if indexPath == IndexPath(row: 1, section: 0) {
            performCodeUsage()
        } else if indexPath == IndexPath(row: 0, section: 1) {
            share()
        }
    }
    
    private func share() {
        let text = "The sweetest curtain (or bottom sheet, or pull up) component!"
        guard let url = URL(string: "https://github.com/multimediasuite/SweetCurtain") else { return }
        
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
    
    private func performCodeUsage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let contentViewController = storyboard.instantiateViewController(withIdentifier: "PlaygroundSBID")
        let curtainViewController = storyboard.instantiateViewController(withIdentifier: "CurtainSBID")
        let curtainController = CurtainController(content: contentViewController, curtain: curtainViewController)
        
        show(curtainController, sender: nil)
    }
    
}
