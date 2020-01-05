//
//  CustomCurtainController.swift
//  SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 24.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit
import SweetCurtain

class CustomCurtainViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var dataArray: [String] = ["🍦 Soft Ice Cream", "🍧 Shaved Ice", "🍨 Ice Cream", "🍩 Doughnut", "🍪 Cookie", "🎂 Birthday Cake", "🍰 Shortcake", "🧁 Cupcake", "🥧 Pie", "🍫 Chocolate Bar", "🍬 Candy", "🍭 Lollipop", "🍮 Custard", "🍯 Honey Pot"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } 
        view.layer.cornerRadius = 10
        view.layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: -2, blur: 5, spread: 0)
    }

}

extension CustomCurtainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataArray.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(dataArray[indexPath.row])"
        cell.backgroundColor = .clear
        return cell
    }
    
}
