//
//  SpeechRecognitionViewController.swift
//  SwiftDemo
//
//  Created by Sean Zeng on 5/19/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

import Speech
import UIKit

class SpeechRecognitionViewController: UIViewController, SFSpeechRecognizerDelegate {

    private let audioEngine = AVAudioEngine()
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest!
    private var speechRecognitionTask: SFSpeechRecognitionTask!

    private var textView : UITextView!
    private var recordButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: 300.0))
        textView.backgroundColor = UIColor.white
        textView.center = view.center
        textView.textColor = UIColor.black
        view.addSubview(textView)

        recordButton = UIButton.init()
        recordButton.layer.cornerRadius = 10.0
        recordButton.backgroundColor = UIColor.red
        recordButton.frame = CGRect(x: textView.frame.midX, y: textView.frame.maxY + 5.0, width: 20.0, height: 20.0)
        recordButton.addTarget(self, action:#selector(tapRecordButton), for: .touchUpInside)
        view.addSubview(recordButton)

        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private method

    func startSpeechRecognition () {
        let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh_TW"))!
        speechRecognizer.delegate = self

        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        speechRecognitionRequest.shouldReportPartialResults = true

        weak var weakSelf = self
        speechRecognitionTask = speechRecognizer.recognitionTask(with: speechRecognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                isFinal = result.isFinal
                weakSelf?.textView.text = result.bestTranscription.formattedString
            }

            if isFinal || error != nil {
                weakSelf?.stopSpeechRecognition()
            }
        }

        guard let inputNode = audioEngine.inputNode else {
            fatalError("audio engine has no input node")
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            weakSelf?.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
    }

    func stopSpeechRecognition () {
        audioEngine.inputNode?.removeTap(onBus: 0)
        audioEngine.stop()
        speechRecognitionRequest?.endAudio()
        speechRecognitionRequest = nil
        speechRecognitionTask?.cancel()
        speechRecognitionTask = nil
    }

    // MARK: - UI event

    func tapRecordButton() {
        if audioEngine.isRunning {
            stopSpeechRecognition()
            textView.text = ""
        } else {
            startSpeechRecognition()
            textView.text = "(listening...)"
        }
    }
}
