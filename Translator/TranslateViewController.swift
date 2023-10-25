//
//  TranslateViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit
import AVFoundation
import Speech
import Toast_Swift

final class TranslateViewController: UIViewController {
    
    private var whatIsPlayingNow: Type = .source
    
    private var translateManager = TranslationManager()
    
    // MARK: - Top Section
    private let topSection = TopSectionOfTranslate()
    
    // MARK: - Middle Section
    private let middleSection = MiddleSectionOfTranslate()
    
    // MARK: - Bottom Section
    private let bottomSection = BottomSectionOfTranslate()
    
    // MARK: - Translate UI ScrollView
    private let scrollView = TranslateScrollView()
    
    // MARK: - Audio Player
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Speech Recognition
    private var speechRecognizer: SFSpeechRecognizer!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Translation".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "historyIcon"),
            style: .done,
            target: self,
            action: #selector(moveToHistory)
        )
        
        setupViews()
        
        topSection.delegate = self
        middleSection.delegate = self
        bottomSection.delegate = self
    
        prepareRecognizer(identifier: TranslationManager.sourceLanguage.languageIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFavouriteStarImage), name: .changeFavouriteStarImage, object: nil)
        
        hideKeyboard()
        
        // 토스트 메세지 Tap 시 사라짐
        ToastManager.shared.isTapToDismissEnabled = true
        // 임시
        //        UserDefaults.standard.set(
        //            nil, forKey: UserDefaults.Key.historyList.rawValue
        //        )
        //
        //        UserDefaults.standard.set(
        //            nil, forKey: UserDefaults.Key.favouriteList.rawValue
        //        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear")
        topSection.delegate = self
        middleSection.isAllUserEventsEnabled(isEnabled: true)
        bottomSection.delegate = self
        
        stopAudio()
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            middleSection.isVoiceInputButtonEnabled(false)
            middleSection.updateVoiceInputButtonImage(false)
            print("Stop Recording")
        }
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func moveToHistory() {
        print("히스토리 화면으로 이동!!")
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @objc func changeFavouriteStarImage(_ notification: Notification) {
        if let isFavourite = notification.object as? Bool {
            bottomSection.updateFavouriteButton(isFavourite)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup Views
private extension TranslateViewController {
    func setupViews() {
        view.addSubview(scrollView)
        
        // MARK: - Configure The Constraints of Translate UI ScrollView
        scrollView.configureUI(view, topSection, middleSection, bottomSection)
        
        // MARK: - Configure The Contraints of Top Section of Translate UI
        topSection.configureUI(scrollView.getContentView())
        
        // MARK: - Configure The Contraints of Middle Section of Translate UI
        middleSection.configureUI(scrollView.getContentView(), topSection)
        
        // MARK: - Configure The Contraints of Bottom Section of Translate UI
        bottomSection.configureUI(scrollView.getContentView(), middleSection)
        bottomSection.isHidden = true
    }
}

// MARK: - Functions for Audio
extension TranslateViewController: AVAudioPlayerDelegate {
    func playAudio(data: Data, type: Type) {
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Initialize the audio player with the downloaded audio data
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 5.0
            audioPlayer?.play()
            
            whatIsPlayingNow = type
        } catch {
            print("Failed to create audio player: \(error)")
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        audioPlayer?.delegate = nil
        
        middleSection.updateSourceLanguagePronunciationPlayButtonImage(isAudioPlaying: false)
        bottomSection.updateTargetLanguagePronunciationPlayButtonImage(isAudioPlaying: false)
    }
    
    // Implement AVAudioPlayerDelegate "did finish" callback to cleanup and notify listener of completion.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
        if flag {
            stopAudio()
        } else {
            print("정상적으로 재생이 종료되지 않았습니다.")
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("ERROR - \(error?.localizedDescription)")
    }
}

// MARK: - Set up User Events' Behavior
extension TranslateViewController: TopSectionOfTranslateDelegate {
    func swapButtonTapped(
        _ sourceLanguageNationalFlagImageView: UIImageView,
        _ sourceLanguageLabel: UILabel,
        _ targetLanguageNationalFlagImageView: UIImageView,
        _ targetLanguageLabel: UILabel
    ) {
        swap(&sourceLanguageNationalFlagImageView.image, &targetLanguageNationalFlagImageView.image)
        swap(&sourceLanguageLabel.text, &targetLanguageLabel.text)
        
        middleSection.updateSourceLangaugeLabel(sourceLanguageLabel.text!)
        bottomSection.updateTargetLangaugeLabel(targetLanguageLabel.text!)
        
        let sourceLanguage = Language.allCases.filter { $0.language == sourceLanguageLabel.text! }[0]
        let targetLanguage = Language.allCases.filter { $0.language == targetLanguageLabel.text! }[0]
        TranslationManager.sourceLanguage = sourceLanguage
        prepareRecognizer(identifier: sourceLanguage.languageIdentifier)
        TranslationManager.targetLanguage = targetLanguage
        
        if !TranslationManager.inputText.isEmpty {
            TranslationManager.inputText = TranslationManager.translatedText
            
            middleSection.updateInputTextView(TranslationManager.inputText)
            
            let inputText = TranslationManager.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // swap 후 재번역
            translateManager.translate(inputText) { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        
                        if let isPlaying = weakSelf.audioPlayer?.isPlaying {
                            if isPlaying {
                                weakSelf.stopAudio()
                            }
                        }
                        
                        weakSelf.bottomSection.updateResultLabel(response.translatedText)
                        weakSelf.bottomSection.updateFavouriteButton()
                        weakSelf.bottomSection.isHidden = false
                    }
                    
                    let newHistoryModel = CustomCellModel(
                        sourceLanguage: TranslationManager.sourceLanguage,
                        targetLanguage: TranslationManager.targetLanguage,
                        inputText: TranslationManager.inputText,
                        translateText: response.translatedText,
                        isFavourite: false
                    )
                    
                    UserDefaults.standard.historyList = [newHistoryModel] + UserDefaults.standard.historyList
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func stackViewTapped(
        _ nationalFlagImageView: UIImageView,
        _ languageLabel: UILabel,
        _ type: Type
    ) {
        let actionSheet = UIAlertController(title: "Please select a language".localized, message: nil, preferredStyle: .actionSheet)
        
        Language.allCases.forEach { value in
            actionSheet.addAction(
                UIAlertAction(
                    title: value.language,
                    style: .default,
                    handler: { [weak self] _ in
                        guard let weakSelf = self else { return }
                        print("\(value.language)가 선택되었습니다.")
                        
                        DispatchQueue.main.async {
                            languageLabel.text = value.language
                            nationalFlagImageView.image = UIImage(named: value.nationalFlag)
                            switch type {
                            case .source:
                                weakSelf.middleSection.updateSourceLangaugeLabel(value.language)
                                weakSelf.prepareRecognizer(identifier: value.languageIdentifier)
                                DispatchQueue.global().async {
                                    TranslationManager.sourceLanguage = value
                                }
                            case .target:
                                weakSelf.bottomSection.updateTargetLangaugeLabel(value.language)
                                DispatchQueue.global().async {
                                    TranslationManager.targetLanguage = value
                                }
                            }
                        }
                    }
                )
            )
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

extension TranslateViewController: MiddleSectionOfTranslateDelegate {
    
    func playPronumciationSound(_ inputText: String) {
        print(inputText)
        AudioManager().getAudioContent(inputText, TranslationManager.sourceLanguage, .source) {[weak self] result, type in
            guard let weakSelf = self else { return }
            guard let type = type else { return }
            
            switch result {
            case .success(let audioData):
                print(audioData)
                DispatchQueue.main.async {
                    
                    // 오디오 재생중일 시 멈춤
                    if let isPlaying = weakSelf.audioPlayer?.isPlaying {
                        if isPlaying && type == weakSelf.whatIsPlayingNow {
                            weakSelf.stopAudio()
                            return
                        }
                    }
                    
                    weakSelf.playAudio(data: audioData, type: type)
                    weakSelf.middleSection.updateSourceLanguagePronunciationPlayButtonImage(isAudioPlaying: true)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    weakSelf.middleSection.updateSourceLanguagePronunciationPlayButtonImage(isAudioPlaying: false)
                }
            }
            DispatchQueue.main.async {
                weakSelf.bottomSection.updateTargetLanguagePronunciationPlayButtonImage(isAudioPlaying: false)
            }
        }
    }
    
    func clearInputButtonTapped(_ inputTextView: UITextView) {
        inputTextView.text = ""
    }
    
    func voiceInputButtonTapped(_ inputTextView: UITextView) {
        stopAudio()
        
        requestAuthorization()
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            middleSection.isVoiceInputButtonEnabled(false)
            print("Stop Recording")
        } else {
            topSection.delegate = nil
            middleSection.isAllUserEventsEnabled(isEnabled: false)
            bottomSection.delegate = nil
            middleSection.updateVoiceInputButtonImage(true)
            
            startRecording(inputTextView)
            print("Start Recording")
        }
    }
    
    func translateButtonTapped(_ inputText: String) {
        
        translateManager.translate(inputText) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    if let isPlaying = weakSelf.audioPlayer?.isPlaying {
                        if isPlaying {
                            weakSelf.stopAudio()
                        }
                    }
                    
                    weakSelf.bottomSection.updateResultLabel(response.translatedText)
                    weakSelf.bottomSection.updateFavouriteButton()
                    weakSelf.bottomSection.isHidden = false
                }
                
                let newHistoryModel = CustomCellModel(
                    sourceLanguage: TranslationManager.sourceLanguage,
                    targetLanguage: TranslationManager.targetLanguage,
                    inputText: inputText,
                    translateText: response.translatedText,
                    isFavourite: false
                )
                
                UserDefaults.standard.historyList = [newHistoryModel] + UserDefaults.standard.historyList
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension TranslateViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print(#function)
        if available {
            middleSection.isVoiceInputButtonEnabled(true)
            middleSection.updateVoiceInputButtonImage(availability: available)
        } else {
            middleSection.isVoiceInputButtonEnabled(false)
            middleSection.updateVoiceInputButtonImage(availability: available)
        }
    }
    
    func requestAuthorization() {
        print(#function)
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.middleSection.isVoiceInputButtonEnabled(isButtonEnabled)
            }
        }
    }
    
    func startRecording(_ textView: UITextView) {
        print(#function)
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                
                self.topSection.delegate = self
                self.middleSection.isAllUserEventsEnabled(isEnabled: true)
                self.bottomSection.delegate = self
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.middleSection.isVoiceInputButtonEnabled(true)
                self.middleSection.updateVoiceInputButtonImage(false)
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = ""
        textView.textColor = UIColor.black
        
    }
    
    private func prepareRecognizer(identifier: String) {
        let locale = Locale(identifier: identifier)
        speechRecognizer = SFSpeechRecognizer(locale: locale)!
        print(speechRecognizer.locale)
        speechRecognizer.delegate = self
    }
}

extension TranslateViewController: BottomSectionOfTranslateDelegate {
    func playPronumciationSound(_ resultLabelText: String?) {
        guard let translatedText = resultLabelText else { return }
        AudioManager().getAudioContent(translatedText, TranslationManager.targetLanguage, .target) { [weak self] result, type in
            guard let weakSelf = self else { return }
            guard let type = type else { return }

            switch result {
            case .success(let audioData):
                print(audioData)
                DispatchQueue.main.async {
                    
                    if let isPlaying = weakSelf.audioPlayer?.isPlaying {
                        if isPlaying && type == weakSelf.whatIsPlayingNow {
                            weakSelf.stopAudio()
                            return
                        }
                    }
                    weakSelf.playAudio(data: audioData, type: type)
                    weakSelf.bottomSection.updateTargetLanguagePronunciationPlayButtonImage(isAudioPlaying: true)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    weakSelf.bottomSection.updateTargetLanguagePronunciationPlayButtonImage(isAudioPlaying: false)
                }
            }
            DispatchQueue.main.async {
                weakSelf.middleSection.updateSourceLanguagePronunciationPlayButtonImage(isAudioPlaying: false)
            }
        }
    }
    
    func copyButtonTapped(_ resultLabelText: String?) {
        print("\(resultLabelText)가 복사되었습니다")
        UIPasteboard.general.string = resultLabelText
        view.makeToast("The text has been copied".localized)
    }
    
    func shareButtonTapped() {
        let vc = UIActivityViewController(activityItems: ["Check my app at www.myapp.example.com"], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func favouriteButtonTapped(_ favouriteButton: UIButton) {
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
        
        if favouriteButton.imageView?.image == UIImage(systemName: "star", withConfiguration: imageConfiguration) {
            
            if var firstOfHistoryList = UserDefaults.standard.historyList.first {
                firstOfHistoryList.isFavourite = true
                UserDefaults.standard.historyList[0] = firstOfHistoryList
                
                UserDefaults.standard.favouriteList = [firstOfHistoryList] + UserDefaults.standard.favouriteList
            } else {
                let newFavourite = CustomCellModel(
                    sourceLanguage: TranslationManager.sourceLanguage,
                    targetLanguage: TranslationManager.targetLanguage,
                    inputText: TranslationManager.inputText,
                    translateText: TranslationManager.translatedText,
                    isFavourite: true
                )
                
                UserDefaults.standard.favouriteList = [newFavourite] + UserDefaults.standard.favouriteList
            }
            
            DispatchQueue.main.async {
                favouriteButton.setImage(UIImage(systemName: "star.fill", withConfiguration: imageConfiguration), for: .normal)
            }
        } else {
            
            if var firstOfHistoryList = UserDefaults.standard.historyList.first  {
                firstOfHistoryList.isFavourite = false
                UserDefaults.standard.historyList[0] = firstOfHistoryList
            }
            
            UserDefaults.standard.favouriteList.removeFirst()
            
            DispatchQueue.main.async {
                favouriteButton.setImage(UIImage(systemName: "star", withConfiguration: imageConfiguration), for: .normal)
            }
        }
    }
}


