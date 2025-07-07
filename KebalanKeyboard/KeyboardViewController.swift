//  KeyboardViewController.swift
//  KebalanKeyboard

import UIKit

class KeyboardViewController: UIInputViewController {

    let kebalanLetters: [[String]] = [
        ["q", "w", "e", "R", "t", "y", "u", "i", "p"],
        ["a", "s", "d", "g", "ng", "h", "k", "l"],
        ["wny", "z", "b", "n", "m", "⌫"],
        ["kua", "patanq", "matiw"]
    ]

    var isDarkModeEnabled: Bool = false // 手動控制黑暗模式

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    func setupKeyboard() {
        let keyboardStack = UIStackView()
        keyboardStack.axis = .vertical
        keyboardStack.spacing = 12 // 縮小按鈕之間的垂直間距
        keyboardStack.alignment = .fill
        keyboardStack.distribution = .fillEqually
        keyboardStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardStack)

        NSLayoutConstraint.activate([
            keyboardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            keyboardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            keyboardStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            keyboardStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])

        let isDarkMode = isDarkModeEnabled || traitCollection.userInterfaceStyle == .dark

        view.subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }

        if isDarkMode {
            let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = view.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(blurView, at: 0)
        } else {
            view.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1.0)
        }

        let keyBackground = isDarkMode ? UIColor(white: 1.0, alpha: 0.1) : UIColor.white
        let specialKeyBackground = isDarkMode ? UIColor(white: 1.0, alpha: 0.15) : UIColor(red: 0.67, green: 0.69, blue: 0.73, alpha: 1.0)
        let deleteKeyBackground = specialKeyBackground
        let keyTextColor = isDarkMode ? UIColor.white : UIColor.black
        let specialKeyTextColor = isDarkMode ? UIColor.white : UIColor.darkGray

        for (rowIndex, row) in kebalanLetters.enumerated() {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 5.5 // 縮小按鈕之間的水平間距
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.translatesAutoresizingMaskIntoConstraints = false

            keyboardStack.addArrangedSubview(rowStack)

            for key in row {
                let button = UIButton(type: .system)
                configureButton(button, withKey: key, isDarkMode: isDarkMode, keyBackground: keyBackground, specialKeyBackground: specialKeyBackground, deleteKeyBackground: deleteKeyBackground, keyTextColor: keyTextColor, specialKeyTextColor: specialKeyTextColor)

                // 增加按鈕高度到原來的 1.2 倍
                button.heightAnchor.constraint(equalToConstant: button.intrinsicContentSize.height * 1.2).isActive = true

                button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.subviews.forEach { $0.removeFromSuperview() }
        setupKeyboard()
    }

    @objc func keyTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else {
            print("Button title is nil")
            return
        }

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()

        print("Tapped key: \(title)") // 確認按鈕文字

        switch title {
        case "⌫":
            textDocumentProxy.deleteBackward()
        case "patanq":
            textDocumentProxy.insertText(" ")
        case "matiw": // 等同於 Go 或 Return 按鈕
            textDocumentProxy.insertText("\n") // 插入換行符
        case "wny":
            textDocumentProxy.insertText("wanay")
        case "kua":
            textDocumentProxy.insertText("kua")
        default:
            textDocumentProxy.insertText(title)
        }
    }

    @objc func toggleDarkMode() {
        isDarkModeEnabled.toggle() // 切換黑暗模式
        view.subviews.forEach { $0.removeFromSuperview() }
        setupKeyboard()
    }

    private func configureButton(_ button: UIButton, withKey key: String, isDarkMode: Bool, keyBackground: UIColor, specialKeyBackground: UIColor, deleteKeyBackground: UIColor, keyTextColor: UIColor, specialKeyTextColor: UIColor) {
        button.setTitle(key, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.lineBreakMode = .byClipping
        button.layer.cornerRadius = 8

        let isLetter = key.count == 1 || key == "ng"
        let isDelete = key == "⌫"
        let isSpace = key == "patanq"
        let isSpecialGrayKey = key == "wny" || key == "kua" || key == "matiw"

        // 統一陰影效果
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 0
        button.layer.masksToBounds = false

        // 設定背景顏色
        button.backgroundColor = isSpace ? keyBackground : (isDelete ? deleteKeyBackground : (isLetter ? keyBackground : specialKeyBackground))

        // 設定文字顏色
        button.setTitleColor(isSpecialGrayKey ? UIColor.black : (isDelete || (!isLetter && !isSpace) ? specialKeyTextColor : keyTextColor), for: .normal)
    }
}
