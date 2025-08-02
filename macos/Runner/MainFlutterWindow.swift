import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    
    // Postavljamo veće dimenzije prozora za bolji UX
    let windowFrame = NSRect(x: 0, y: 0, width: 1200, height: 800)
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    // Centriramo prozor na ekranu
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
