import 'dart:async';
import 'dart:io';
import 'package:admin/src/config.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';


import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


class WebViewPage extends StatefulWidget {
  final String url;
  final String? title;
  const WebViewPage({Key? key, required this.url, this.title}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoadingPage = true;
  final config = Config();
  final cookieManager = WebviewCookieManager();
  bool injectCookies = false;

  late WebViewController _wvController;


  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _seCookies();


    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {

          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller = controller;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title!) : Container(),
        bottom: _isLoadingPage ? PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>
                (Theme.of(context).primaryColorDark),
            )
        ) : null,
      ),
      body: injectCookies ? WebViewWidget(controller: _controller)/*WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController wvc) {
          _wvController = wvc;
        },
        onPageFinished: (value) async {
          _wvController.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none';");
          _wvController.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none';");
          _wvController.evaluateJavascript("document.getElementById('header').style.display='none';");
          _wvController.evaluateJavascript("document.getElementById('footer').style.display='none';");
          setState(() {
            _isLoadingPage = false;
          });
        },
      )*/ : Container(),
    );
  }

  _seCookies() async {
    Uri uri = Uri.parse(config.url);
    String domain = uri.host;
    ApiProvider apiProvider = ApiProvider();
    List<Cookie> cookies = apiProvider.generateCookies();
    apiProvider.cookieList.forEach((element) async {
      await cookieManager.setCookies([
        Cookie(element.name, element.value)
          ..domain = domain
        //..expires = DateTime.now().add(Duration(days: 10))
        //..httpOnly = true
      ]);
    });
    setState(() {
      injectCookies = true;
    });
  }

}