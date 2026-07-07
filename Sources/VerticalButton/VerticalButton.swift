import UIKit

/// VerticalButton: UIButton subclass that lays out the image and title vertically (image above or below title).
/// - Supports spacing, contentEdgeInsets, optional fixed image size, configurable title lines, and intrinsicContentSize.
public final class VerticalButton: UIButton {

    /// Spacing between image and title
    public var spacing: CGFloat = 6 {
        didSet { setNeedsLayout(); invalidateIntrinsicContentSize() }
    }

    /// If true: image on top, title below. If false: title on top, image below.
    public var imageOnTop: Bool = true {
        didSet { setNeedsLayout() }
    }

    /// Optionally force image to a fixed size. If nil, image's natural size is used (scaled by imageView.contentMode).
    public var fixedImageSize: CGSize? {
        didSet { setNeedsLayout(); invalidateIntrinsicContentSize() }
    }

    /// Number of lines for title (default 1)
    public var titleNumberOfLines: Int = 1 {
        didSet {
            titleLabel?.numberOfLines = titleNumberOfLines
            setNeedsLayout(); invalidateIntrinsicContentSize()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // sensible defaults
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = titleNumberOfLines
        imageView?.contentMode = .scaleAspectFit
        adjustsImageWhenHighlighted = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        // Ensure titleLabel has correct wrapping width for sizeThatFits
        titleLabel.numberOfLines = titleNumberOfLines

        // available content rect considering contentEdgeInsets
        let rect = bounds.inset(by: contentEdgeInsets)
        guard rect.width > 0 && rect.height > 0 else {
            imageView.frame = .zero
            titleLabel.frame = .zero
            return
        }

        // Determine image size
        var imageSize = fixedImageSize ?? imageView.image?.size ?? .zero
        if imageSize == .zero && imageView.image != nil {
            // fallback to imageView's current bounds if set by system
            imageSize = imageView.bounds.size
        }

        // Limit image width to available width
        if imageSize.width > rect.width {
            let scale = rect.width / imageSize.width
            imageSize.width = rect.width
            imageSize.height = max(0, imageSize.height * scale)
        }

        // Determine title size by allowing wrapping within available width
        let maxTitleWidth = rect.width
        let titleSize = titleLabel.sizeThatFits(CGSize(width: maxTitleWidth, height: CGFloat.greatestFiniteMagnitude))

        // whether we actually have content
        let hasImage = (imageView.image != nil) && (imageSize.height > 0.0)
        let hasTitle = ((titleLabel.text?.isEmpty == false) || (titleLabel.attributedText != nil)) && titleSize.height > 0.0
        let usedSpacing: CGFloat = (hasImage && hasTitle) ? spacing : 0

        // total content height
        let totalHeight = (hasImage ? imageSize.height : 0) + usedSpacing + (hasTitle ? titleSize.height : 0)

        // start Y to vertically center content in rect
        var imageY = rect.midY - totalHeight / 2
        var titleY = imageY + (hasImage ? imageSize.height : 0) + usedSpacing

        if !imageOnTop {
            // swap: title first
            titleY = rect.midY - totalHeight / 2
            imageY = titleY + (hasTitle ? titleSize.height : 0) + usedSpacing
        }

        // center X
        let centerX = rect.midX

        // Set frames
        if hasImage {
            let imageX = centerX - imageSize.width / 2
            imageView.frame = CGRect(x: imageX.rounded(.down), y: imageY.rounded(.down), width: imageSize.width.rounded(.down), height: imageSize.height.rounded(.down))
        } else {
            imageView.frame = .zero
        }

        if hasTitle {
            let finalTitleWidth = min(titleSize.width, maxTitleWidth)
            let titleX = centerX - finalTitleWidth / 2
            titleLabel.frame = CGRect(x: titleX.rounded(.down), y: titleY.rounded(.down), width: finalTitleWidth.rounded(.down), height: titleSize.height.rounded(.down))
        } else {
            titleLabel.frame = .zero
        }
    }

    public override var intrinsicContentSize: CGSize {
        // Compute intrinsic size based on image + title + spacing + contentEdgeInsets
        let imageSize = fixedImageSize ?? imageView?.image?.size ?? .zero

        var titleSize = CGSize.zero
        if let label = titleLabel, let text = label.text, !text.isEmpty {
            // give a reasonable max width; intrinsic width should be max of image/title
            let maxWidth: CGFloat = max(imageSize.width, 44) // prefer at least some width
            titleSize = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        }

        let usedSpacing: CGFloat = ((imageSize.height > 0) && (titleSize.height > 0)) ? spacing : 0

        let width = max(imageSize.width, titleSize.width) + contentEdgeInsets.left + contentEdgeInsets.right
        let height = imageSize.height + usedSpacing + titleSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom

        return CGSize(width: ceil(width), height: ceil(height))
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Respect suggested max width
        let maxWidth = size.width > 0 ? size.width : CGFloat.greatestFiniteMagnitude
        let imageSize = fixedImageSize ?? imageView?.image?.size ?? .zero

        var titleSize = CGSize.zero
        if let label = titleLabel, let text = label.text, !text.isEmpty {
            let constrainedWidth = maxWidth - contentEdgeInsets.left - contentEdgeInsets.right
            titleSize = label.sizeThatFits(CGSize(width: max(0, constrainedWidth), height: CGFloat.greatestFiniteMagnitude))
        }

        let usedSpacing: CGFloat = ((imageSize.height > 0) && (titleSize.height > 0)) ? spacing : 0

        let width = min(max(imageSize.width, titleSize.width) + contentEdgeInsets.left + contentEdgeInsets.right, maxWidth)
        let height = imageSize.height + usedSpacing + titleSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom

        return CGSize(width: ceil(width), height: ceil(height))
    }

    // Update layout when content changes
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        setNeedsLayout(); invalidateIntrinsicContentSize()
    }

    public override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        super.setAttributedTitle(title, for: state)
        setNeedsLayout(); invalidateIntrinsicContentSize()
    }

    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        setNeedsLayout(); invalidateIntrinsicContentSize()
    }
}
