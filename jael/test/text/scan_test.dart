import 'package:jael/src/ast/token.dart';
import 'package:jael/src/text/scanner.dart';
import 'package:test/test.dart';
import 'common.dart';

main() {
  test('plain html', () {
    var tokens = scan('<img src="foo.png" />', sourceUrl: 'test.jl').tokens;
    tokens.forEach(print);

    expect(tokens, hasLength(7));
    expect(tokens[0], isToken(TokenType.lt));
    expect(tokens[1], isToken(TokenType.id, 'img'));
    expect(tokens[2], isToken(TokenType.id, 'src'));
    expect(tokens[3], isToken(TokenType.equals));
    expect(tokens[4], isToken(TokenType.string, '"foo.png"'));
    expect(tokens[5], isToken(TokenType.slash));
    expect(tokens[6], isToken(TokenType.gt));
  });

  test('text node', () {
    var tokens = scan('<p>Hello\nworld</p>', sourceUrl: 'test.jl').tokens;
    tokens.forEach(print);

    expect(tokens, hasLength(8));
    expect(tokens[0], isToken(TokenType.lt));
    expect(tokens[1], isToken(TokenType.id, 'p'));
    expect(tokens[2], isToken(TokenType.gt));
    expect(tokens[3], isToken(TokenType.text, 'Hello\nworld'));
    expect(tokens[4], isToken(TokenType.lt));
    expect(tokens[5], isToken(TokenType.slash));
    expect(tokens[6], isToken(TokenType.id, 'p'));
    expect(tokens[7], isToken(TokenType.gt));
  });

  test('mixed', () {
    var tokens = scan('<ul number=1 + 2>three{{four > five.six}}</ul>', sourceUrl: 'test.jl').tokens;
    tokens.forEach(print);

    expect(tokens, hasLength(20));
    expect(tokens[0], isToken(TokenType.lt));
    expect(tokens[1], isToken(TokenType.id, 'ul'));
    expect(tokens[2], isToken(TokenType.id, 'number'));
    expect(tokens[3], isToken(TokenType.equals));
    expect(tokens[4], isToken(TokenType.number, '1'));
    expect(tokens[5], isToken(TokenType.plus));
    expect(tokens[6], isToken(TokenType.number, '2'));
    expect(tokens[7], isToken(TokenType.gt));
    expect(tokens[8], isToken(TokenType.text, 'three'));
    expect(tokens[9], isToken(TokenType.doubleCurlyL));
    expect(tokens[10], isToken(TokenType.id, 'four'));
    expect(tokens[11], isToken(TokenType.gt));
    expect(tokens[12], isToken(TokenType.id, 'five'));
    expect(tokens[13], isToken(TokenType.dot));
    expect(tokens[14], isToken(TokenType.id, 'six'));
    expect(tokens[15], isToken(TokenType.doubleCurlyR));
    expect(tokens[16], isToken(TokenType.lt));
    expect(tokens[17], isToken(TokenType.slash));
    expect(tokens[18], isToken(TokenType.id, 'ul'));
    expect(tokens[19], isToken(TokenType.gt));
  });
}