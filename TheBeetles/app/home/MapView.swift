import SwiftUI
import MapKit
import WebKit

class MapViewModel: ObservableObject {
    @Published var url: URL?
    
    func start() {
        Task { @MainActor in
            let urlString = await FirebaseManager.shared.fetchMap()
            self.url = URL(string: urlString)
        }
    }
}
struct MapView: View {
    @ObservedObject var viewModel = MapViewModel()
    
    @ViewBuilder
    var body: some View {
        VStack {
            if let url = viewModel.url {
                WebView(url: url)
                    .background(Color.appGray)
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .background(Color.appGray)
            }
        }
        .onAppear(perform: viewModel.start)
        .navigationBarHidden(true)
    }
    
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
}

#Preview {
    MapView()
}
