import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../consts/consts.dart';

class SalesPageEnd extends StatefulWidget {
  final String imag;
  final String txt;
  final String code;
  final String description;

  const SalesPageEnd({
    super.key,
    required this.imag,
    required this.txt,
    required this.code,
    required this.description,
  });

  @override
  State<SalesPageEnd> createState() => _SalesPageEndState();
}

class _SalesPageEndState extends State<SalesPageEnd> {
  String text = 'Zrealizuj';

  void _changeText() {
    setState(() {
      text = widget.code;
    });
  }

  List<TextSpan> _buildFormattedText(String txt) {
    List<TextSpan> spans = [];
    List<String> lines = txt.split('\\n');

    //print(lines.length);

    for (String line in lines) {
      if (line.startsWith('-')) {
        line = line.substring(1, line.length);
        spans.add(
          TextSpan(
            text: '\t\t • \t$line\n',
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$line\n',
          ),
        );
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: BuildTopNav(context),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.04, bottom: screenHeight * 0.02),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Croissant One',
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minHeight: screenHeight * 0.65),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(35),
                  bottom: Radius.circular(10),
                ),
              ),
              width: screenWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(35),
                          bottom: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 5),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Image.network(widget.imag),
                          ),
                          Visibility.maintain(
                            visible: widget.code.isNotEmpty,
                            child: ElevatedButton(
                              onPressed: _changeText,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.zero,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: IntrinsicWidth(
                                child: Container(
                                  constraints: BoxConstraints(
                                      minWidth: screenWidth * 0.4,
                                      maxWidth: screenWidth * 0.7),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: COLOR_BACKGROUND_DARKER,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    text,
                                    style: const TextStyle(
                                      fontFamily: 'Asap',
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Asap',
                          fontStyle: FontStyle.italic,
                        ),
                        children: _buildFormattedText(widget.txt),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BuildBackButton(context),
    );
  }

  PreferredSizeWidget BuildTopNav(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: COLOR_BACKGROUND_DARKER,
          borderRadius: BorderRadius.vertical(
            bottom: BORDER_RADIUS,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Center(child: Image.asset('./images/sale.png')),
      ),
    );
  }

  BottomAppBar BuildBackButton(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BottomAppBar(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: const BoxDecoration(
          color: COLOR_BACKGROUND_DARKER,
          borderRadius: BorderRadius.vertical(top: BORDER_RADIUS),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset(
                '././images/back_icon.png',
                height: screenHeight * 0.06,
              ),
            )
          ],
        ),
      ),
    );
  }
}
