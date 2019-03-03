//
//  Fade.swift
//  ForeCast
//
//  Created by sumit oberoi on 3/2/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import UIKit
class Fade: UIStoryboardSegue {
    
    override func perform() {
        
        guard let destinationView = self.destination.view else {
            // Fallback to no fading
            self.source.present(self.destination, animated: false, completion: nil)
            return
        }
        
        destinationView.alpha = 0
        self.source.view?.addSubview(destinationView)
        
        UIView.animate(withDuration: 1.0, animations: {
            destinationView.alpha = 1
        }, completion: { _ in
            self.source.present(self.destination, animated: false, completion: nil)
        })
    }
}
