//
//  LoginViewController.swift
//  KoreaLover
//
//  Created by 김승진 on 2018. 8. 30..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit

class LoginEntryViewController: UIViewController {

    @IBOutlet weak var welcomSubTitle: UILabel!
    @IBOutlet weak var emailLogin: UIButton!
    @IBOutlet weak var facebookLogin: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupInit() {
        setupLoginUI()
        
        self.welcomSubTitle.text = NSLocalizedString("LOGIN_WELCOM", comment: "")
        self.skipBtn.setTitle(NSLocalizedString("LOGIN_SKIP", comment: ""), for: UIControlState.normal)
    }
    
    private func setupLoginUI() {
        self.emailLogin.layer.cornerRadius = 20
        self.emailLogin.layer.masksToBounds = true
        self.emailLogin.setTitle(NSLocalizedString("LOGIN_EMAIL_LOGIN", comment: ""), for: UIControlState.normal)
        
        self.facebookLogin.layer.cornerRadius = 20
        self.facebookLogin.layer.masksToBounds = true
        self.facebookLogin.setTitle(NSLocalizedString("LOGIN_EMAIL_LOGIN", comment: ""), for: UIControlState.normal)
    }

    @IBAction func emailLoginAction(_ sender: UIButton) {
       
       let emailLoginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "EmailLoginViewController")
        self.navigationController?.pushViewController(emailLoginVC, animated: true)
    }
    

}
