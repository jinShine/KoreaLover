//
//  EmailLoginViewController.swift
//  KoreaLover
//
//  Created by 김승진 on 2018. 8. 30..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class EmailLoginViewController: UIViewController {
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var emailAddressTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextLine: UIView!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextLine: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var findPWBtn: UIButton!
    @IBOutlet weak var errorContents: UILabel!
    
    @IBOutlet weak var backBtnTop: NSLayoutConstraint!
    
    private var activityView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInit()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupInit() {
        setupLocalizedText()
        setupActivityIndicator()
        
        loginBtn.layer.cornerRadius = 25
        loginBtn.layer.masksToBounds = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupLocalizedText() {
        signupBtn.setTitle(NSLocalizedString("LOGIN_SIGNUP", comment: ""), for: UIControlState.normal)
        loginTitle.text = NSLocalizedString("LOGIN_SIGNIN", comment: "")
        emailAddressTitle.text = NSLocalizedString("LOGIN_EMAIL_ADDRESS", comment: "")
        passwordTitle.text = NSLocalizedString("LOGIN_PW", comment: "")
        loginBtn.setTitle(NSLocalizedString("LOGIN_SIGNIN", comment: ""), for: UIControlState.normal)
        findPWBtn.setTitle(NSLocalizedString("LOGIN_FIND_PW", comment: ""), for: UIControlState.normal)
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.ballBeat, color: UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
        self.view.addSubview(activityView)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        if sender == emailTextField {
            if (sender.text?.count)! > 0 {
                self.emailTextLine.backgroundColor = UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1)
            } else {
                self.emailTextLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            }
        } else if sender == passwordTextField {
            if (sender.text?.count)! > 0 {
                self.passwordTextLine.backgroundColor = UIColor(red: 227/255.0, green: 72/255.0, blue: 99/255.0, alpha: 1)
            } else {
                self.passwordTextLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            }
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        activityView.startAnimating()
        
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    
                    self.activityView.stopAnimating()
                    
                    if error != nil {
                        if (error! as NSError).code == 17008 {
                            self.errorContents.text = NSLocalizedString("LOGIN_ERROR_USER_NOT_FOUND", comment: "")
                        } else if (error! as NSError).code == 17005 {
                            self.errorContents.text = NSLocalizedString("LOGIN_ERROR_USER_DISABLED", comment: "")
                        } else if (error! as NSError).code == 17009{
                            self.errorContents.text = NSLocalizedString("LOGIN_ERROR_WRONG_PASSWORD", comment: "")
                        }
                        return
                    }

                    print("로그인 성공")
                    self.view.endEditing(true)
                }
            }
        }
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findPWAction(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let signUpVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(signUpVC, animated: true)
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
    
}

extension EmailLoginViewController: UITextFieldDelegate {
    
}
