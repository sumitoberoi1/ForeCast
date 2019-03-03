//
//  SplashVC.swift
//  ForeCast
//
//  Created by sumit oberoi on 3/2/19.
//  Copyright © 2019 sumit oberoi. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    @IBOutlet weak var nameLabek: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        delayWithSeconds(0.2) {
            self.logoAnimation()
        }
        
    }
    
    func logoAnimation() {
        
        UIView.animate(withDuration: 1.2,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: [],
                       animations: {
                        self.logo.transform = CGAffineTransform.identity
        },
                       completion: { Void in()
                        self.showTitleLabel()
        }
        )
    }
    
    func showTitleLabel() {
        UIView.animate(withDuration: 0.4, animations: {
            self.nameLabek.alpha = 1.0
        }, completion: { Void in()
            self.presentController()
        })
    }
    
    func presentController() {
        performSegue(withIdentifier: "Fade", sender: nil)
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}
