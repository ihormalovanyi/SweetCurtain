//
//  ViewController.swift
//  SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 18.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit
import SweetCurtain

class PlaygroundToolViewController: UIViewController {
    
    private enum Cells: Int {
        
        case header
        case heights
        case moving
        case other
        
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var changeHeightCoefficientsHandler: (CGFloat, CGFloat?, CGFloat) -> () {
        return { min, mid, max in
            self.curtainController?.curtain.minHeightCoefficient = min
            self.curtainController?.curtain.midHeightCoefficient = mid
            self.curtainController?.curtain.maxHeightCoefficient = max
        }
    }
    
    private var curtainHideHandler: (Bool) -> () {
        return { hide in
            self.curtainController?.moveCurtain(to: hide ? .hide : .min, animated: true)
        }
    }
    
    private var changeMovePropertiesHandler: (CGFloat, TimeInterval, Bool, Bool) -> () {
        return { resistance, moveDuration, topBounce, bottomBounce in
            self.curtainController?.curtain.swipeResistance = .custom(velocity: resistance)
            self.curtainController?.curtain.movingDuration = moveDuration
            self.curtainController?.curtain.topBounce = topBounce
            self.curtainController?.curtain.bottomBounce = bottomBounce
        }
    }
    
    private var changeOtherPropertiesHandler: (Bool) -> () {
        return { showsHandleIndicator in
            self.curtainController?.curtain.showsHandleIndicator = showsHandleIndicator
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        curtainController?.curtainDelegate = self
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SweetCurtainHeaderCell", bundle: nil), forCellReuseIdentifier: "SweetCurtainHeaderCell")
        tableView.register(UINib(nibName: "SweetCurtainHeighsCell", bundle: nil), forCellReuseIdentifier: "SweetCurtainHeighsCell")
        tableView.register(UINib(nibName: "SweetCurtainMovePropertiesCell", bundle: nil), forCellReuseIdentifier: "SweetCurtainMovePropertiesCell")
        tableView.register(UINib(nibName: "SweetCurtainViewChangePropertiesCell", bundle: nil), forCellReuseIdentifier: "SweetCurtainViewChangePropertiesCell")
        tableView.register(UINib(nibName: "SweetCurtainOtherPropertiesCell", bundle: nil), forCellReuseIdentifier: "SweetCurtainOtherPropertiesCell")
    }
    
}

extension PlaygroundToolViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Cells(rawValue: indexPath.row) {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SweetCurtainHeaderCell", for: indexPath)
            (cell as? SweetCurtainHeaderCell)?.hideHandler = curtainHideHandler
            return cell
        case .heights:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SweetCurtainHeighsCell", for: indexPath)
            (cell as? SweetCurtainHeighsCell)?.changeHandler = changeHeightCoefficientsHandler
            return cell
        case .moving:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SweetCurtainMovePropertiesCell", for: indexPath)
            (cell as? SweetCurtainMovePropertiesCell)?.changeHandler = changeMovePropertiesHandler
            return cell
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SweetCurtainOtherPropertiesCell", for: indexPath)
            (cell as? SweetCurtainOtherPropertiesCell)?.changeHandler = changeOtherPropertiesHandler
            return cell
            
        default: return UITableViewCell()
        }
    }
    
}

extension PlaygroundToolViewController: CurtainDelegate {
   
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState) {
        (tableView.cellForRow(at: IndexPath(row: Cells.header.rawValue, section: 0)) as? SweetCurtainHeaderCell)?.performDelegateIndicator(.didChangeState)
        
        print(curtain.heightCoefficient)
        
        if heightState != .max {
            UIView.animate(withDuration: 0.3) {
                self.tableView.contentInset.bottom = curtain.actualHeight
            }
        }
    }
    
    func curtainWillBeginDragging(_ curtain: Curtain) {
        (tableView.cellForRow(at: IndexPath(row: Cells.header.rawValue, section: 0)) as? SweetCurtainHeaderCell)?.performDelegateIndicator(.willBeginDragging)
    }
    
    func curtainDidEndDragging(_ curtain: Curtain) {
        (tableView.cellForRow(at: IndexPath(row: Cells.header.rawValue, section: 0)) as? SweetCurtainHeaderCell)?.performDelegateIndicator(.didEndDragging)
    }
    
    func curtainDidDrag(_ curtain: Curtain) {
        (tableView.cellForRow(at: IndexPath(row: Cells.header.rawValue, section: 0)) as? SweetCurtainHeaderCell)?.performDelegateIndicator(.didDrag)
    }
    
}
