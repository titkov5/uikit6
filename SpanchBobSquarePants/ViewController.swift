import UIKit

class ViewController: UIViewController {
    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    let animatibleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(animatibleView)
        animatibleView.center = view.center
        animatibleView.backgroundColor = .blue
        animatibleView.layer.cornerRadius = 10.0

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGR.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGR)
    }

    @objc
    func handleTap(tapGR:UITapGestureRecognizer) {
        if tapGR.state == .ended {
            let touchPoint = tapGR.location(in: self.view)
            let center = view.center

            let p1 = animatibleView.center
            let p2 = touchPoint
            let v1 = CGVector(dx: p1.x - center.x, dy: p1.y - center.y)
            let v2 = CGVector(dx: p2.x - center.x, dy: p2.y - center.y)

            let distanceCoff = CGFloat(hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))) / self.view.frame.height
            let angle = ((atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx))).truncatingRemainder(dividingBy: 1.5708) * distanceCoff

            animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
            animator.addAnimations {
                let rotationTransform = CGAffineTransform(rotationAngle: -angle)
                self.animatibleView.transform = rotationTransform
            }

            animator.addAnimations {
                self.animatibleView.center = CGPointMake(touchPoint.x, touchPoint.y)
            }

            animator.addCompletion {_ in 
                self.startAnimation(duration: 0.3)
            }

            animator.startAnimation()
        }
    }

    func startAnimation(duration: TimeInterval) {
        if animator.state  == .active {
            animator.stopAnimation(true)
        }

        animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) { [weak self] in
            guard let self else { return }

            self.animatibleView.transform = .identity
        }

        animator.startAnimation()
    }

}
