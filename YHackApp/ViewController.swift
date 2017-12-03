//
//  ViewController.swift
//  YHackApp
//
//  Created by Jack Boyce on 12/2/17.
//  Copyright © 2017 Jack Boyce. All rights reserved.
//

import UIKit
import SpeechToTextV1
//import FBSDKLoginKit
//import NSLinguisticTagger


class ViewController: UIViewController {
    
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var recordTextView: UITextView!
    var keys: [String] = []

    var speechToText: SpeechToText!
    var speechToTextSession: SpeechToTextSession!
    var isStreaming = false
    var fbid = "testing"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        speechToText = SpeechToText(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        speechToTextSession = SpeechToTextSession(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        outputTextView.layer.borderWidth = 1.0
        outputTextView.layer.borderColor = UIColor.gray.cgColor
        outputTextView.font = UIFont(name: "Helvetica", size: 14)
        outputTextView.textAlignment = NSTextAlignment.center
        recordTextView.layer.borderWidth = 1.0
        recordTextView.layer.borderColor = UIColor.gray.cgColor
        recordTextView.font = UIFont(name: "Helvetica", size: 14)
        
        navigationController?.title = "Reminisce.AI"
        
        testOnline()
        
//        //creating button
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = view.center
//        
//        //adding it to view
//        view.addSubview(loginButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recordTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    public func textToPOS(str: String) {
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
        let schemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        tagger.string = str
        
        tagger.enumerateTags(in: NSMakeRange(0, (str as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
            let token = (str as NSString).substring(with: tokenRange)
//            print("\(token): \(tag)")
            if ["PlaceName", "PersonalName", "Noun"].contains(tag) {
                //outputTextView.text! += "\(token) "
                keys.append(token)
            }
//            outputTextView.text! += "\(token): \(tag)\n"
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var microphoneButton: UIButton!
    public func streamMicrophoneBasic() {
        if !isStreaming {
            
            // update state
            microphoneButton.setTitle("Stop Recording", for: .normal)
            isStreaming = true
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.interimResults = true
            //settings.keywordsThreshold = 0.45
            settings.wordAlternativesThreshold = 0.45
            settings.speakerLabels = true
            
            // define error function
            let failure = { (error: Error) in print(error) }
            
            // start recognizing microphone audio
            speechToText.recognizeMicrophone(settings: settings, failure: failure) {
                results in
                self.recordTextView.text = results.bestTranscript
                self.outputTextView.text = ""
                self.textToPOS(str: self.recordTextView.text)
            }
            
        } else {
            
            // update state
            microphoneButton.setTitle("Start Recording", for: .normal)
            isStreaming = false
            
            // stop recognizing microphone audio
            speechToText.stopRecognizeMicrophone()
            
            //outputTextView.text = ""
            keys.removeAll()
            textToPOS(str: recordTextView.text)
//            for word in outputTextView.text.components(separatedBy: " ") {
//                print("Convos from \(word): \(getConvoFromKeywords(fbid, "\(word)"))");
//            }
            
//            for word in keys {
//                print("Convos from \(word): \(getConvoFromKeywords(fbid, "\(word)"))");
//            }
            
            //let name = recordTextView.text.components(separatedBy: " ")[1]
            
            sendConvo()
            
            //print("Add convo: \(addConvo("testing", "\(name)", "\(recordTextView.text!)"))")
        }
    }
    
    @IBAction func remindButtonPressed(_ sender: Any) {
        for word in keys {
            if word != "" {
                
                var rawConvos = getConvoFromKeywords(fbid, "\(word)")!
                print(rawConvos)
                var dictConvos = stringToDict(string: rawConvos)
                print(rawConvos)
                var printingString = ""
                
                outputTextView.textAlignment = NSTextAlignment.left
                
                for i in dictConvos {
                    if let j = i["convo_data"]{
                        
                        printingString += "•\t" + i["convo_data"]! + "\n"
                    }
                    
                    //printingString += i["convo_data"] ?? ""
                }
                
                
                //print(printingString)
                outputTextView.text = printingString
                //print("Convos from \(word): \(getConvoFromKeywords(fbid, "\(word)"))");
                //print(word)
            }
        }
        
        
    }
    
    public func sendConvo() {
        fbid = "testing"
        //let name = recordTextView.text.components(separatedBy: " ")[1]
        let name = keys[1]
        print("Add user: \(addUser(fbid, "test@gmail.com", "testfirstname", "testlastname"))")
        print("Add friend: \(addFriend(fbid, "\(name)"))")
        print("Add convo: \(addConvo(fbid, "\(name)", "\(recordTextView.text!)"))")
    }

    @IBAction func didPressMicrophoneButton(_ sender: Any) {
        streamMicrophoneBasic()
    }
    
    
    public func testAPI() {
        let attempt = 3
        fbid = "testing\(attempt)"
        print("loaded")
        print("Facebook ID: \(getUserFacebookID(fbid))" )
        print("Friends: \(getFriendsByUserFacebookID(fbid))")
        print("Convos from words: \(getConvoFromKeywords(fbid, "words2"))");
        print("Add user: \(addUser(fbid, "test\(attempt)@gmail.com", "testfirst\(attempt)", "testlast\(attempt)"))")
        print("Add friend: \(addFriend(fbid, "testfriendname\(attempt)"))")
        print("Add convo: \(addConvo(fbid, "testaddconvofriend\(attempt)", "test conversation\(attempt)"))")
        print("Test: \(test())")
        print("after")
    }
    
    public func testOnline() {
        print("Online: \(test())")
    }
}

