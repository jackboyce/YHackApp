//
//  ViewController.swift
//  YHackApp
//
//  Created by Jack Boyce on 12/2/17.
//  Copyright © 2017 Jack Boyce. All rights reserved.
//

import UIKit
import SpeechToTextV1
//import NSLinguisticTagger


class ViewController: UIViewController {
    
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var recordTextView: UITextView!

    var speechToText: SpeechToText!
    var speechToTextSession: SpeechToTextSession!
    var isStreaming = false

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
        fbid = "testing2"
        print("loaded")
        print("Facebook ID: \(getUserFacebookID(fbid))" )
        print("Friends: \(getFriendsByUserFacebookID(fbid))")
        print("Convos from words: \(getConvoFromKeywords(fbid, "words2"))");
        print("Add user: \(addUser(fbid, "test2@gmail.com", "testfirst2", "testlast2"))")
        print("Add friend: \(addFriend(fbid, "testfriendname2"))")
        print("Add convo: \(addConvo(fbid, "testaddconvofriend2", "test conversation2"))")
        print("Test: \(test())")
        print("after")
//        let text = "The American Red Cross was established in Washington, D.C., by Clara Barton."
//        let tagger = NSLinguisticTagger(tagSchemes: ["nameType"], options: 0)
//        tagger.string = "The American Red Cross was established in Washington, D.C., by Clara Barton."
//        let range = NSRange(location:0, length: text.utf16.count)
//        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
//        let tags: [String] = ["personalName", "placeName", "organizationName"]
//        tagger.enumerateTags(in: range, scheme: "nameType", options: options) { tag, tokenRange, otherRange, stop in
//            print("Inside")
//            if tag != "" && tags.contains(tag) {
//                let name = (text as NSString).substring(with: tokenRange)
//                print("\(name): \(tag)")
//            }
//            if tag != "" {
//                print(tag)
//            }
//            
//        }
        
    }
    
    public func textToPOS(str: String) {
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
        let schemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        tagger.string = str
        tagger.enumerateTags(in: NSMakeRange(0, (str as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
            let token = (str as NSString).substring(with: tokenRange)
            //print("\(token): \(tag)")
            outputTextView.text! += "\(token): \(tag)\n"
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
            microphoneButton.setTitle("Stop Microphone", for: .normal)
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
            microphoneButton.setTitle("Start Microphone", for: .normal)
            isStreaming = false
            
            // stop recognizing microphone audio
            speechToText.stopRecognizeMicrophone()
            
            outputTextView.text = ""
            textToPOS(str: recordTextView.text)
        }
    }

    @IBAction func didPressMicrophoneButton(_ sender: Any) {
        streamMicrophoneBasic()
    }
}

