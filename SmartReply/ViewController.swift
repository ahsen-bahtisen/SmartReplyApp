//
//  ViewController.swift
//  SmartReply
//
//  Created by Ahsen Bahtışen on 29.10.2022.
//

import UIKit
import MLKitSmartReply


class ViewController: UIViewController {

    var replies: [String] = []
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        
        view.endEditing(true)
        self.answerLabel.text = "..."
        
        // QuestionTextField öğesinin boş olup olmadığını kontrol edin.
        guard let text = questionTextField.text, !text.isEmpty else{
            return
            
        }
        //Kullanıcı bir mesaj gönderdiğinde veya aldığında, mesajı, zaman damgasını ve mesajı gönderenin kullanıcı kimliğini konuşma geçmişine ekleyin.
        let message = TextMessage(text: questionTextField.text!, timestamp: Date().timeIntervalSince1970, userID: "userId", isLocalUser: false)
        
        //Bir mesaja akıllı yanıtlar oluşturmak için, örneğini alın SmartReplyve konuşma geçmişini suggestReplies(for:completion:)yöntemine iletin:

         SmartReply.smartReply().suggestReplies(for: [message]) { (result, error) in
            guard error == nil, let result = result else {
                return
            }
            if (result.status == .notSupportedLanguage) {
                //Konuşma dili ingilizce değil veya sonuç herhangi bir cevap içermiyor
                self.answerLabel.text = "I don't understand."
            } else if (result.status == .success) {
                //Başarılı
                for suggestion in result.suggestions {
                  
                    self.replies.append(suggestion.text)
                }
                // Aldığımız cevaplardan rastgele bir eleman seç ve göster
                self.answerLabel.text = self.replies.randomElement()
            }
            else{
                self.answerLabel.text = "I don't know the answer to that."
            }
            
        }
    }
}

