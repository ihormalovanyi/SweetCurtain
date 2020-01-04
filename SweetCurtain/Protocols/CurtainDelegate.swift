//
//  CurtainControllerDelegate.swift
//  SweetCurtain
//
//  Created by Ihor Malovanyi on 28.12.2019.
//

import Foundation

///The methods declared by the CurtainDelegate protocol allow the adopting delegate to respond to messages from the CurtainController class and thus respond to, and in some affect, operations such as changing height state, dragging, and updating actual curtain height coefficient.
public protocol CurtainDelegate: class {
    
    ///Tells the delegate when the curtain did change ir's height state.
    ///- Parameter curtain: The object that represents curtain properties.
    ///- Parameter heightState: The new height state of the curtain.
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState)
    
    ///Tells the delegate when the curtain is about to start dragging.
    ///- Parameter curtain: The object that represents curtain properties.
    func curtainWillBeginDragging(_ curtain: Curtain)
    
    ///Tells the delegate when dragging ended in the curtain.
    ///- Parameter curtain: The object that represents curtain properties.
    func curtainDidEndDragging(_ curtain: Curtain)
    
    ///Tells the delegate when the user draggs the curtain.
    ///- Parameter curtain: The object that represents curtain properties.
    func curtainDidDrag(_ curtain: Curtain)
    
}

public extension CurtainDelegate {
    
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState) {}
    func curtainWillBeginDragging(_ curtain: Curtain) {}
    func curtainDidEndDragging(_ curtain: Curtain) {}
    func curtainDidDrag(_ curtain: Curtain) {}
    
}
