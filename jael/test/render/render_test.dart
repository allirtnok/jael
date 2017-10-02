import 'package:code_buffer/code_buffer.dart';
import 'package:jael/jael.dart' as jael;
import 'package:symbol_table/symbol_table.dart';
import 'package:test/test.dart';

main() {
  test('attribute binding', () {
    const template = '''
<html>
  <body>
    <h1>Hello</h1>
    <img src=profile['avatar'] />
  </body>
</html>
''';

    var buf = new CodeBuffer();
    var document = jael.parseDocument(template, sourceUrl: 'test.jl');
    var scope = new SymbolTable(values: {
      'profile': {
        'avatar': 'thosakwe.png',
      }
    });

    const jael.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<html>
  <body>
    <h1>
      Hello
    </h1>
    <img src="thosakwe.png">
  </body>
</html>
    '''
            .trim());
  });

  test('interpolation', () {
    const template = '''
<!doctype HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <body>
    <h1>Pokémon</h1>
    {{ pokemon.name }} - {{ pokemon.type }}
    <img>
  </body>
</html>
''';

    var buf = new CodeBuffer();
    //jael.scan(template, sourceUrl: 'test.jl').tokens.forEach(print);
    var document = jael.parseDocument(template, sourceUrl: 'test.jl');
    var scope = new SymbolTable(values: {
      'pokemon': const _Pokemon('Darkrai', 'Dark'),
    });

    const jael.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<!doctype HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <body>
    <h1>
      Pokémon
    </h1>
    Darkrai - Dark
    <img/>
  </body>
</html>
    '''
            .trim());
  });

  test('for loop', () {
    const template = '''
<html>
  <body>
    <h1>Pokémon</h1>
    <ul>
      <li for-each=starters as="starter">{{ starter.name }} - {{ starter.type }}</li>
    </ul>
  </body>
</html>
''';

    var buf = new CodeBuffer();
    var document = jael.parseDocument(template, sourceUrl: 'test.jl');
    var scope = new SymbolTable(values: {
      'starters': starters,
    });

    const jael.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<html>
  <body>
    <h1>
      Pokémon
    </h1>
    <ul>
      <li>
        Bulbasaur - Grass
      </li>
      <li>
        Charmander - Fire
      </li>
      <li>
        Squirtle - Water
      </li>
    </ul>
  </body>
</html>
    '''
            .trim());
  });

  test('conditional', () {
    const template = '''
<html>
  <body>
    <h1>Conditional</h1>
    <b if=starters.isEmpty>Empty</b>
    <b if=starters.isNotEmpty>Not empty</b>
  </body>
</html>
''';

    var buf = new CodeBuffer();
    var document = jael.parseDocument(template, sourceUrl: 'test.jl');
    var scope = new SymbolTable(values: {
      'starters': starters,
    });

    const jael.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<html>
  <body>
    <h1>
      Conditional
    </h1>
    <b>
      Not empty
    </b>
  </body>
</html>  
    '''
            .trim());
  });

  test('declare', () {
    const template = '''
<div>
 <declare one=1 two=2 three=3>
   <ul>
    <li>{{one}}</li>
    <li>{{two}}</li>
    <li>{{three}}</li>
   </ul>
   <ul>
    <declare three=4>
      <li>{{one}}</li>
      <li>{{two}}</li>
      <li>{{three}}</li>
    </declare>
   </ul>
 </declare>
</div>
''';

    var buf = new CodeBuffer();
    var document = jael.parseDocument(template, sourceUrl: 'test.jl');
    var scope = new SymbolTable();

    const jael.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<div>
  <ul>
    <li>
      1
    </li>
    <li>
      2
    </li>
    <li>
      3
    </li>
  </ul>
  <ul>
    <li>
      1
    </li>
    <li>
      2
    </li>
    <li>
      4
    </li>
  </ul>
</div>
'''
            .trim());
  });

  test('unescaped attr/interp', () {
    const template = '''
<div>
  <img src!="<SCARY XSS>" />
  {{- "<MORE SCARY XSS>" }}
</div>
''';

    var buf = new CodeBuffer();
    var document = jael.parseDocument(template, sourceUrl: 'test.jl');
    var scope = new SymbolTable();

    const jael.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<div>
  <img src="<SCARY XSS>">
  <MORE SCARY XSS>
</div>
'''
            .trim());
  });

  test('quoted attribute name', () {
    const template = '''
<button '(click)'="myEventHandler(\$event)"></button>
''';

    var buf = new CodeBuffer();
    var document = jael.parseDocument(template, sourceUrl: 'test.jl');
    var scope = new SymbolTable();

    const jael.Renderer().render(document, buf, scope);
    print(buf);

    expect(
        buf.toString(),
        '''
<button (click)="myEventHandler(\$event)">
</button>
'''
            .trim());
  });
}

const List<_Pokemon> starters = const [
  const _Pokemon('Bulbasaur', 'Grass'),
  const _Pokemon('Charmander', 'Fire'),
  const _Pokemon('Squirtle', 'Water'),
];

class _Pokemon {
  final String name, type;

  const _Pokemon(this.name, this.type);
}