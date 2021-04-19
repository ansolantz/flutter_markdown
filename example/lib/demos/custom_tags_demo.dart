// Copyright 2020 Quiverware LLC. Open source contribution. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import '../shared/markdown_demo_widget.dart';

// Markdown source data showing the use of adding custom tags.
const String _data = """
## Custom tags syntaxes

s1 This is a subtitle1 text

s1 This is an _italic_ subtitle1

s2 This is a subtitle2

b2 This is a body2

b2 This is an _italic_ body2 and **bold** text and some more text and some more text

with some extra paragraph text below
""";

const String _notes = """
# Custom tag Demo
---

## Overview

s1 This is a subtitle1
s2 This is a subtitle2
b2 This is a bodyText2


""";

/// The custom tags demo provides an example of creating custom block tags.
class CustomTagsDemo extends StatelessWidget implements MarkdownDemoWidget {
  static const _title = 'Custom tags Demo';

  @override
  String get title => CustomTagsDemo._title;

  @override
  String get description => 'An example of how to create custom block tags.';

  @override
  Future<String> get data => Future<String>.value(_data);

  @override
  Future<String> get notes => Future<String>.value(_notes);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Markdown(
            styleSheet: MarkdownStyleSheet(
              textAlign: WrapAlignment.center,
              h2: TextStyle(
                fontSize: 24,
                fontFamily: 'GTAmerica',
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              s1: TextStyle(
                fontSize: 20,
                fontFamily: 'GTAmerica',
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              s2: TextStyle(
                fontSize: 18,
                fontFamily: 'GTAmerica',
                color: Colors.green,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              b2: TextStyle(
                fontSize: 16,
                fontFamily: 'GTAmerica',
                color: Colors.pink,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            data: snapshot.data,
            builders: {},
            extensionSet: md.ExtensionSet([
              Subtitle1BlockSyntax(),
              Subtitle2BlockSyntax(),
              Body2BlockSyntax(),
            ], []),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class Subtitle1BlockSyntax extends md.BlockSyntax {
  const Subtitle1BlockSyntax() : super();

  @override
  RegExp get pattern => RegExp(r'^ {0,3}s1[ ](.*)$');

  @override
  md.Node parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current);
    parser.advance();
    var contents = md.UnparsedContent(match[1]);
    return md.Element('s1', [contents]);
  }
}

class Subtitle2BlockSyntax extends md.BlockSyntax {
  const Subtitle2BlockSyntax() : super();

  @override
  RegExp get pattern => RegExp(r'^ {0,3}s2[ ](.*)$');

  @override
  md.Node parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current);
    parser.advance();
    var contents = md.UnparsedContent(match[1]);
    return md.Element('s2', [contents]);
  }
}

class Body2BlockSyntax extends md.BlockSyntax {
  const Body2BlockSyntax() : super();

  @override
  RegExp get pattern => RegExp(r'^[ ]{0,3}b2[ ]?(.*)$');

  @override
  md.Node parse(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current);
    parser.advance();
    final contents = md.UnparsedContent(match[1]);
    return md.Element('b2', [contents]);
  }
}
