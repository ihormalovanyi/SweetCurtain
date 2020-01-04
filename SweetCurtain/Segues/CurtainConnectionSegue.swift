//
//  CurtainControllerSegue.swift
//  SweetCurtainRemaster
//
//  Created by Ihor Malovanyi on 30.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

internal class CurtainConnectionSegue: UIStoryboardSegue {

    struct Constants {
        
        static let contentSegueID = "ContentID"
        static let curtainSegueID = "CurtainID"
        
    }
    
    open override func perform() {
        guard let curtainController = source as? CurtainController else {
            //TODO: Ошибка, неверный контроллер
            return
        }
        
        if identifier == Constants.contentSegueID {
            curtainController.addContent(destination)
        }
        
        if identifier == Constants.curtainSegueID {
            curtainController.addCurtain(destination)
        }
    }
    
}
