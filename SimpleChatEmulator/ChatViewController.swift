//
//  ChatViewController.swift
//  SimpleChatEmulator
//
//  Created by Чингиз Б on 04.07.17.
//  Copyright © 2017 Chingiz Bayshurin. All rights reserved.
//

import UIKit

enum MessageType {
    case yourMessage
    case yourContactMessage
}
struct ChatMessage {
    var time : String!
    var type : MessageType
    var message : String!
    
    init (time: String, type: MessageType, message : String) {
        self.time = time
        self.type = type
        self.message = message    }
}




class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var chatMessages : [ChatMessage] = [ChatMessage]()
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var messageInputViewBottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTable.delegate = self
        chatTable.dataSource = self
        
        
        // Заголовок в NavigationBar'е
        self.navigationController?.navigationBar.topItem?.title = "Эмулятор чата"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont.init(name: "Avenir", size: 20.0)
        ]
        
        
        //слушатель на текстовое поле
        messageInput.addTarget(nil, action: #selector(closeKeyboard), for: .editingDidEndOnExit)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
         sendMessage()
    }
    
    
    func closeKeyboard() {
        if(!(messageInput.text?.isEmpty)!){
            sendMessage()  // try to send message
            messageInput.text = ""
        } else {
            view.endEditing(true)
        }
    }
    
    
    
    
    func keyboardWasShown(notification: NSNotification) {
        print("Keyboard appeared")
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                messageInputViewBottomConstraint.constant = keyboardSize.height //+ 20
                self.view.layoutIfNeeded()
            }
        }
        
        if( chatMessages.count > 0  ) {
            let lastRow = chatMessages.count - 1
            var lastIndex = IndexPath(row: lastRow, section: 0)
            self.chatTable.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: true)
            
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        print("Keyboard hidden")
        
        UIView.animate(withDuration: 0.25, animations: {
            self.messageInputViewBottomConstraint.constant = 0
            self.messageInput.text = ""
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    
    func sendMessage(){
        let msg = messageInput.text ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"        //"yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "Moscow/Europe") as TimeZone!
        let shortStringDate = dateFormatter.string(from: Date())
        let newMsg = ChatMessage(time: shortStringDate, type: .yourMessage,
                                 message: msg)
        chatMessages.append(newMsg)
        chatTable.reloadData()
        view.endEditing(true)
        messageInput.text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.answer()
        })
    }
    
    
    
    func answer() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"        //"yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "Moscow/Europe") as TimeZone!
        let shortStringDate = dateFormatter.string(from: Date())
        
        let answers : [String] = [  "Ля-ля, тополя",
                                    "Я предрлчитаю не говорить об этом, друг",
                                    "Спасибо, у меня тоже все нормально!",
                                    "Не знаю, позвони мне",
                                    "Да ты серьезно? Ну ты даешь",
                                    "И что ты сделал?",
                                    "Слушай, не одолжишь мне 10000 до получки. Точно отдам!",
                                    "Вы ошиблись адресом",
                                    "Приходи завтра в 7, будет вечеринка",
                                    "Продам авто на металлолом",
                                    "Что за абракдабру ты мне постоянно пишешь, научись уже работать с Т9!",
                                    "Отстань, я занят"]
        let ii = Int(arc4random()) % answers.count
        
        let answer = answers[ ii ]
        
        let newMsg = ChatMessage(time: shortStringDate, type: .yourContactMessage, message: answer)
        
        
        chatMessages.append(newMsg)
        
        chatTable.reloadData()
        
        if( chatMessages.count > 0  ) {
            let lastRow = chatMessages.count - 1
            var lastIndex = IndexPath(row: lastRow, section: 0)
            self.chatTable.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: true)
            
        }
    }
    
    
    
    
    
    //MARK: TariffsTable Lifecycle
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msg = chatMessages[indexPath.row]
       
        if msg.type == .yourMessage {
            let identifier = "yourMessage"
            let cell =  tableView.dequeueReusableCell(withIdentifier: identifier)! as! ChatCell
            cell.yourNickname.text  = "Ваш ник Eduard"
            cell.yourTimestamp.text = msg.time
            cell.yourMessage.text   = msg.message
            return cell
        } else {
            let identifier = "yourContactMessage"
            let cell =  tableView.dequeueReusableCell(withIdentifier: identifier)! as! ChatCell
            cell.yourContactNickname.text  = "Ник вашего друга Vasya"
            cell.yourContactTimestamp.text = msg.time
            cell.yourContactMessage.text   = msg.message
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Заголовок для header'а секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "..."
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        headerView.backgroundColor = UIColor("#d9d9d9")
        
        let sectionLabel = UILabel(frame: CGRect.init(x: 15.0, y: 4.0, width: 300.0, height: 20.0))
        sectionLabel.font = UIFont(name: "Avenir", size: 16.0)
        sectionLabel.textColor = UIColor("#99a1a3")
        sectionLabel.text = "\(Date())"
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
        
    }

    
    
    
    

}// ----- end of class declaration -----------------
