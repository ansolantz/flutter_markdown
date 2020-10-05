// Copyright 2020 Quiverware LLC. Open source contribution. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../shared/dropdown_menu.dart';
import '../shared/markdown_demo_widget.dart';
import '../shared/markdown_extensions.dart';

const String _notes = """
# Basic Markdown Demo
---
The Basic Markdown Demo shows the effect of the four Markdown extension sets
on formatting basic and extended Markdown tags.

## Overview

The Dart [markdown](https://pub.dev/packages/markdown) package parses Markdown
into HTML. The flutter_markdown package builds on this package using the
abstract syntax tree generated by the parser to make a tree of widgets instead
of HTML elements.

The markdown package supports the basic block and inline Markdown syntax
specified in the original Markdown implementation as well as a few Markdown
extensions. The markdown package uses extension sets to make extension
management easy. There are four pre-defined extension sets; none, Common Mark,
GitHub Flavored, and GitHub Web. The default extension set used by the
flutter_markdown package is GitHub Flavored.

The Basic Markdown Demo shows the effect each of the pre-defined extension sets
has on a test Markdown document with basic and extended Markdown tags. Use the
Extension Set dropdown menu to select an extension set and view the Markdown
widget's output.

## Comments

Since GitHub Flavored is the default extension set, it is the initial setting
for the formatted Markdown view in the demo.
""";

class BasicMarkdownDemo extends StatefulWidget implements MarkdownDemoWidget {
  static const _title = 'Basic Markdown Demo';

  @override
  String get title => BasicMarkdownDemo._title;

  @override
  String get description => 'Shows the effect the four Markdown extension sets '
      'have on basic and extended Markdown tagged elements.';

  @override
  Future<String> get data async =>
      await rootBundle.loadString('assets/markdown_test_page.md');

  @override
  Future<String> get notes => Future<String>.value(_notes);

  @override
  _BasicMarkdownDemoState createState() => _BasicMarkdownDemoState();
}

class _BasicMarkdownDemoState extends State<BasicMarkdownDemo> {
  var _extensionSet = MarkdownExtensionSet.githubFlavored;

  final _menuItems = Map<String, MarkdownExtensionSet>.fromIterables(
    MarkdownExtensionSet.values.map((e) => e.displayTitle),
    MarkdownExtensionSet.values,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              DropdownMenu<MarkdownExtensionSet>(
                items: _menuItems,
                label: 'Extension Set:',
                initialValue: _extensionSet,
                onChanged: (value) {
                  if (value != _extensionSet) {
                    setState(() {
                      _extensionSet = value;
                    });
                  }
                },
              ),
              Expanded(
                child: Markdown(
                  key: Key(_extensionSet.name),
                  data: snapshot.data,
                  imageDirectory: 'https://raw.githubusercontent.com',
                  extensionSet: _extensionSet.value,
                  onTapLink: (text, href) =>
                      linkOnTapHandler(context, text, href),
                ),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  // Handle the link. The [href] in the callback contains information
  // from the link. The url_launcher package or other similar package
  // can be used to execute the link.
  void linkOnTapHandler(BuildContext context, String text, String href) async {
    showDialog(
      context: context,
      builder: (context) => _createDialog(context, text, href),
    );
  }

  Widget _createDialog(BuildContext context, String text, String href) =>
      AlertDialog(
        title: Text('Reference Link'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'See the following link for more information:',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 8),
              Text(
                '$text',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(height: 8),
              Text(
                '$href',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          )
        ],
      );
}
