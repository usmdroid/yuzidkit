import UIKit
import YuzIDKit

final class ViewController: UIViewController {
    private let languages: [(title: String, value: YuzIDLanguage)] = [
        ("UZ", .uz), ("ЎЗ", .uzCyrillic), ("RU", .ru), ("EN", .en)
    ]
    private let languageControl = UISegmentedControl(items: ["UZ", "ЎЗ", "RU", "EN"])
    private let startButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private let imageView = UIImageView()

    /// Example ilovaning o'z matnlari (YuzIDKit matnlari alohida, kutubxona ichida).
    private let texts: [(start: String, hint: String, cancelled: String)] = [
        ("YuzID ni boshlash", "Tilni tanlang va tugmani bosing", "Bekor qilindi"),
        ("YuzID ни бошлаш", "Тилни танланг ва тугмани босинг", "Бекор қилинди"),
        ("Запустить YuzID", "Выберите язык и нажмите кнопку", "Отменено"),
        ("Start YuzID", "Choose a language and tap the button", "Cancelled"),
    ]
    private var textIndex: Int { languageControl.selectedSegmentIndex }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        languageControl.selectedSegmentIndex = 0
        languageControl.addTarget(self, action: #selector(languageChanged), for: .valueChanged)

        var config = UIButton.Configuration.filled()
        config.title = texts[0].start
        startButton.configuration = config
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        statusLabel.text = texts[0].hint
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.textColor = .secondaryLabel

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [languageControl, startButton, statusLabel, imageView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    @objc private func languageChanged() {
        startButton.configuration?.title = texts[textIndex].start
        if imageView.image == nil { statusLabel.text = texts[textIndex].hint }
    }

    @objc private func startTapped() {
        let language = languages[languageControl.selectedSegmentIndex].value
        startButton.isEnabled = false

        // Butun integratsiya shu bitta chaqiruv.
        YuzID.present(language: language) { [weak self] result in
            guard let self = self else { return }
            self.startButton.isEnabled = true
            switch result {
            case .success(let image):
                self.imageView.image = image
                let kb = (result.base64JPEG?.count ?? 0) / 1024
                self.statusLabel.text = "Muvaffaqiyatli: \(Int(image.size.width))x\(Int(image.size.height)), base64 ~\(kb) KB"
            case .cancelled:
                self.statusLabel.text = self.texts[self.textIndex].cancelled
            case .failure(let error):
                self.statusLabel.text = "Xato: \(error)"
            }
        }
    }
}
