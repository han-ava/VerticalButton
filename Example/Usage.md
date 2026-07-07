# Example / Usage

See README for basic usage. Quick example:

```swift
import VerticalButton

let btn = VerticalButton(type: .custom)
btn.setImage(UIImage(systemName: "camera"), for: .normal)
btn.setTitle("拍照", for: .normal)
btn.spacing = 8
btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
btn.titleNumberOfLines = 1
btn.fixedImageSize = CGSize(width: 40, height: 40)
```
