# VerticalButton

VerticalButton is a small Swift package that provides a UIButton subclass which lays out the button's image and title vertically (image above or below the title). It's lightweight and dependency-free — suitable for UIKit projects that need a simple vertical image+title button.

Features
- Image above or below the title (configurable via `imageOnTop`).
- Spacing control between image and title.
- Optional fixed image size (`fixedImageSize`).
- `intrinsicContentSize` & `sizeThatFits` implemented for Auto Layout.
- Supports configurable number of title lines.

Requirements
- iOS 11+
- Swift 5.5+

Installation

Swift Package Manager

- In Xcode: File > Add Packages... and enter this repository URL.

Usage

```swift
import VerticalButton

let btn = VerticalButton(type: .custom)
btn.setImage(UIImage(systemName: "camera"), for: .normal)
btn.setTitle("拍照", for: .normal)
btn.spacing = 8
btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
btn.titleNumberOfLines = 1
btn.fixedImageSize = CGSize(width: 40, height: 40) // optional
view.addSubview(btn)
btn.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    btn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])
```

Interface Builder

You can add a UIButton in a storyboard/xib and change its class to `VerticalButton`. Configure title/image/spacing in code (IBInspectable can be added in a follow-up if you want Interface Builder visual editing).

Notes
- If your minimum deployment target is iOS 15+, consider using `UIButton.Configuration` with `imagePlacement = .top` which offers similar layout with system-level optimizations.

Contributing

Contributions are welcome. Open an issue or a PR; keep changes focused and add tests where appropriate.

License

This project is released under the MIT License. See LICENSE for details.
