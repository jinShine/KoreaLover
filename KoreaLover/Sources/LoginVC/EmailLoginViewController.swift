//
//  EmailLoginViewController.swift
//  KoreaLover
//
//  Created by 김승진 on 2018. 8. 30..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit

class EmailLoginViewController: UIViewController {

    
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var emailAddressTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var findPWBtn: UIButton!
    
    @IBOutlet weak var backBtnTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInit()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupInit() {
        setupLocalizedText()
        
        loginBtn.layer.cornerRadius = 25
        loginBtn.layer.masksToBounds = true
        
    }
    
    private func setupLocalizedText() {
        signupBtn.setTitle(NSLocalizedString("LOGIN_SIGNUP", comment: ""), for: UIControlState.normal)
        loginTitle.text = NSLocalizedString("LOGIN_SIGNIN", comment: "")
        emailAddressTitle.text = NSLocalizedString("LOGIN_EMAIL_ADDRESS", comment: "")
        passwordTitle.text = NSLocalizedString("LOGIN_PW", comment: "")
        loginBtn.setTitle(NSLocalizedString("LOGIN_SIGNIN", comment: ""), for: UIControlState.normal)
        findPWBtn.setTitle(NSLocalizedString("LOGIN_FIND_PW", comment: ""), for: UIControlState.normal)
        
    }
    
    @objc private func keyboardWillShow(noti: Notification) {
        
        let notiInfo = noti.userInfo! as Dictionary
        let keyboardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height
        
        if self.view.frame.height - findPWBtn.frame.origin.y < keyboardHeight {
            self.backBtnTop.constant = -keyboardHeight + (self.view.frame.height - findPWBtn.frame.origin.y)
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
    
    @IBAction func loginAction(_ sender: UIButton) {
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findPWAction(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
    }
    
}
