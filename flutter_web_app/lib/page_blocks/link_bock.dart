import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:url_launcher/url_launcher.dart';

class LinkBlock extends StatelessWidget {

  //DATA MEMBERS
  final value;
  final url;
  final style;

  const LinkBlock({
  super.key, required this.value,required this.url,this.style});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: value,
        style: style,
        recognizer: TapGestureRecognizer()..onTap = () {launchUrl(Uri.parse(url));}
      )
    );
  }
}