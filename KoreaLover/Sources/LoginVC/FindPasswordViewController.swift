//
//  FindPasswordViewController.swift
//  KoreaLover
//
//  Created by 김승진 on 2018. 8. 31..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var findPWTitle: UILabel!
    @IBOutlet weak var emailAddressTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextLine: UIView!
    @IBOutlet weak var findPWSubTitle: UILabel!
    @IBOutlet weak var findPWSubContents: UILabel!
    @IBOutlet weak var errorContents: UILabel!
    @IBOutlet weak var findPWBtn: UIButton!
    
    @IBOutlet weak var backBtnTop: NSLayoutConstraint!
    
    private var activityView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInit()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findPWAction(_ sender: UIButton) {
        activityView.startAnimating()
        
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                
                self.activityView.stopAnimating()
                
                if error != nil {
                    if let err = error {
                        self.errorContents.text = ((err as NSError).userInfo["NSLocalizedDescription"] as! String)
                    }
                    return
                }
                
                let alertController = UIAlertController(title: NSLocalizedString("LOGIN_CHECK_EMAIL", comment: ""), message: "\(self.emailTextField.text!)" + NSLocalizedString("LOGIN_FIND_PW_RESET", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: NSLocalizedString("LOGIN_OK", comment: ""), style: UIAlertActionStyle.default) { (alert)in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true) { }
                
            }
        }
        
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        
        if sender == emailTextField {
            if (sender.text?.count)! > 0 {
                self.emailTextLine.backgroundColor = UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1)
            } else {
                self.emailTextLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            }
        }
    }
    
    private func setupInit() {
        setupLocalizedText()
        setupActivityIndicator()
        
        findPWBtn.layer.cornerRadius = 25
        findPWBtn.layer.masksToBounds = true
    }
    
    private func setupLocalizedText() {
        findPWTitle.text = NSLocalizedString("LOGIN_FORGOT_PW", comment: "")
        emailAddressTitle.text = NSLocalizedString("LOGIN_EMAIL_ADDRESS", comment: "")
        findPWSubTitle.text = NSLocalizedString("LOGIN_FIND_PW", comment: "")
        findPWSubContents.text = NSLocalizedString("LOGIN_FIND_PW_CONTENTS", comment: "")
        findPWBtn.setTitle(NSLocalizedString("LOGIN_SIGNIN", comment: ""), for: UIControlState.normal)
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.ballBeat, color: UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
        self.view.addSubview(activityView)
    }
    
    @objc private func keyboardWillShow(noti: Notification) {
        
        let notiInfo = noti.userInfo! as Dictionary
        let keyboardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height
        
        if self.view.frame.height - errorContents.frame.origin.y < keyboardHeight {
            self.backBtnTop.constant = -keyboardHeight + (self.view.frame.height - errorContents.frame.origin.y)
        }
        
        UIView.animate(withDuration: notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(noti: Notification) {
        
        let notiInfo = noti.userInfo! as Dictionary
        
        self.backBtnTop.constant = 20
        
        UIView.animate(withDuration: notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    //Email 정규식
    private func validateEmail(email: String) -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
