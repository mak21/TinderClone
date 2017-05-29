//
//  segueFromLeft.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
class SegueFromLeft: UIStoryboardSegue
{
  override func perform()
  {
    let src = self.source
    let dst = self.destination
    
    src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
    dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
    
    UIView.animate(withDuration: 0.05,
                               delay: 0.1,
                               options: UIViewAnimationOptions.curveEaseInOut,
                               animations: {
                                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
    },
                               completion: { finished in
                              
                                src.present(dst, animated: false, completion: nil)
    }
    )
  }
}
