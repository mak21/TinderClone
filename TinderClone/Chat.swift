//
//  Chat.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/28/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class Chat {
  var content : String?
  var userId : String?
  var userName : String?
  var userImageUrl : String?
  
  
  init(dictionary: [String: Any]) {
    self.content = dictionary["content"] as? String
    self.userName = dictionary["userName"] as? String
    self.userImageUrl = dictionary["userImageUrl"] as? String
    self.userId = dictionary["userId"] as? String
    
  }
  
}
