import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (context) => TopPage(),
        '/webview': (context) => WebViewPage(url: 'https://www.google.com'),
        '/second': (context) => SecondPage(),
      },
      initialRoute: '/',
    );
  }
}

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('1. This is first page. Tap button to go to WebView page.'),
          Center(
            child: RaisedButton(
              onPressed: () => Navigator.pushNamed(context, '/webview'),
              child: Text('WebView'),
            ),
          ),
        ],
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/second');
            },
            child: Text('2. Go to next page'),
          )
        ],
      ),
      body: WebView(initialUrl: widget.url),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool appLaunched = false;
  String message = '3. Press me to launch other app.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('second'),
      ),
      body: Center(
        child: appLaunched
            ? Text(message)
            : RaisedButton(
                onPressed: () async {
                  setState(() {
                    appLaunched = true;
                    message = '4. After app launched, back to this app.';
                  });

                  await Future.delayed(Duration(seconds: 1));

                  await launch(
                    'https://www.google.com/maps/@42.585444,13.007813,6z',
                    forceSafariVC: false,
                  );

                  setState(() {
                    message = '''
                    5. Go back.
                    6. You will see old rendering result on WebView page but actually navigated to WebView page. 
                    6. Leave app (press home button).
                    7. Return to this app (from history or home icon).
                    8. Now WebView page is rendered correctly.
                    ''';
                  });
                },
                child: Text(message),
              ),
      ),
    );
  }
}
