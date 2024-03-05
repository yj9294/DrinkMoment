//
//  PrivacyVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/22.
//

import UIKit

class PrivacyVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Privacy Policy"
    }

}

extension PrivacyVC {
    override func setupUI() {
        super.setupUI()
        
        let textView = UITextView()
        textView.textColor = .black
        textView.font  = .systemFont(ofSize: 14)
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.text = """
Thank you for choosing to use the Drink-Moment Water App. We take user privacy very seriously, and through this Privacy policy, we will explain to you how we collect, use and protect your personal information.
1. Collected information
To provide a better drinking experience, the Drink-Moment Water App may collect the following information:
User Settings information: We may collect your water reminder Settings, target water volume and other information to provide personalized services.
Usage Data: We may collect data about your use of the App, such as recorded drinking time, water volume, etc., to improve the app's functionality and user experience.
2. Purpose of using the information
The information we collect is used only for the following purposes:
Provide personalized service: User-set information is used for personalized reminder services to ensure that you stay hydrated according to your needs.
Improve app functionality: Usage data helps us understand user behavior, optimize app functionality, and provide a better user experience.
3. Protection of information
We take reasonable security measures to protect your personal information to prevent unauthorized access, use or disclosure. We promise not to sell, rent or share your personal information with third parties.
4. Third-party services
The Drink-Moment App may use third-party services, such as analytics tools, to help us better understand how the App is being used. These services may collect some information, and we encourage you to check the privacy policy of the relevant services for details.
5. Privacy options
You can choose whether to share specific information in the app Settings. We will respect your privacy choices.
6. Changes to the Privacy policy
We may update this Privacy Policy from time to time, and we will post the changes through in-app notifications or on the website when updated.
By using the Drink-Moment Drink App, you agree to this Privacy Policy. If you have any privacy questions, please contact us at: aiyayanet@outlook.com
Last updated: 2024.1.18
"""
        textView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
