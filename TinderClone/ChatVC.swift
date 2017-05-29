//
//  chatVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/27/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
class ChatVC: JSQMessagesViewController  {
  var receiverUser : User?
  let currentUserId = FIRAuth.auth()?.currentUser?.uid
  var messages : [JSQMessage] = []
  var chats: [Chat] = []
  lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
  lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
   var messageRef: FIRDatabaseReference!
   var newMessageRefHandle: FIRDatabaseHandle?
   var updateMessageRefHandle: FIRDatabaseHandle?
   var usersTypingQuery: FIRDatabaseQuery?
   lazy var userIsTypingRef: FIRDatabaseReference = self.messageRef.child("typingIndicator").child(self.senderId)
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let btn1 = UIButton(type: .custom)
      btn1.setImage(UIImage(named: "flag"), for: .normal)
      btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      btn1.tintColor = UIColor.red
      btn1.addTarget(self, action: #selector(handleUnmatch), for: .touchUpInside)
      let item1 = UIBarButtonItem(customView: btn1)
      
      self.navigationItem.setRightBarButtonItems([item1], animated: true)
      
      

      collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
      collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
      self.senderId = FIRAuth.auth()?.currentUser?.uid
      self.senderDisplayName = "testing"
      
      messageRef = FIRDatabase.database().reference().child("messages")
      usersTypingQuery = self.messageRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue:true)
      
      observeMessages()
    }
  func handleUnmatch()  {
    
    let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "REPORT", style: .destructive, handler:nil ))
    ac.addAction(UIAlertAction(title: "UNMATCH", style: .destructive, handler: { (a: UIAlertAction) in
    
      guard let matchedId = self.receiverUser?.id else {return}
      FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("matches/\(matchedId)").removeValue()
      self.navigationController?.popViewController(animated: true)
    }))
    ac.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler:nil ))
    self.present(ac, animated: true, completion: nil)
  
    
  }
   var localTyping = false
  var isTyping: Bool{
    get{
      return localTyping
    }
    set {
      localTyping = newValue
      userIsTypingRef.setValue(newValue)
    }
  }
  
  deinit {
    if let refHandle = newMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
    
    if let refHandle = updateMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    observeTyping()
  }
   func observeTyping() {
    
    let typingIndicatorRef = messageRef.child("typingIndicator")
    self.userIsTypingRef = typingIndicatorRef.child(senderId)
    self.userIsTypingRef.onDisconnectRemoveValue()
    
    
    usersTypingQuery?.observe(.value) { (data:FIRDataSnapshot) in
      if data.childrenCount == 1 && self.isTyping{
        return
      }
      
      self.showTypingIndicator = data.childrenCount > 0
      self.scrollToBottom(animated: true)
      
    }
  }
  
  func observeMessages() {
    let messageQuery = messageRef.queryLimited(toLast:25)
    
    newMessageRefHandle = messageQuery.observe(.childAdded, with: {(snapshot) -> Void in
      
      let messageInfo = snapshot.value as! Dictionary<String, Any>
      guard let messageData = messageInfo as? [String:String] else {
        return
      }
      
      if let id = messageData["sender_id"] as String!,
        let name = messageData["receiver_name"] as String!,
        let text = messageData["message"] as String! {
        
        self.addMessage(withId: id, name: name, text: text)
       
        
        self.finishReceivingMessage()
        
      }
    })
  }
  
  func setupOutgoingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
  }
  
   func setupIncomingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
  }
 
   func addMessage(withId id: String, name:String, text: String){
    if let message = JSQMessage(senderId: id, displayName: name, text: text){
      messages.append(message)
    }
  }

}
extension ChatVC {
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
     let itemRef = messageRef.childByAutoId()
    if let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text){
            let sentDict = ["sender_id" : message.senderId!, "receiver_id" : receiverUser?.id,"receiver_name":"", "message" : message.text!]
    
    itemRef.setValue(sentDict)
      //addMessage(withId: currentUserId!, name: "me", text: message.text!)
    }
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
    finishSendingMessage()
    isTyping = false
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
    let message = messages[indexPath.row]
    let messageUserName = message.senderDisplayName
    
    return NSAttributedString(string: messageUserName!)
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
    return 15
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let bubbleFactory = JSQMessagesBubbleImageFactory()
    
    let message = messages[indexPath.row]
    
    guard let id = FIRAuth.auth()?.currentUser?.uid else {return nil}
    
    if "\(id)" == message.senderId {
      return outgoingBubbleImageView
    } else {
      return incomingBubbleImageView
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return messages[indexPath.row]
  }
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
    let message = messages[indexPath.item]
    
    if message.senderId == senderId {
      cell.textView?.textColor = UIColor.white
    } else {
      cell.textView?.textColor = UIColor.black
    }
    return cell
  }
  
  override func textViewDidChange(_ textView: UITextView) {
    super.textViewDidChange(textView)
    
    isTyping = textView.text != ""
  }
}
