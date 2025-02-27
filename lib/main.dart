import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
     apiKey: "AIzaSyAm9QTWkDNhUdLpyjSY2zI2w32CAE4JDD0",
      appId: "1:655140052537:android:46d4a4e50e1e45239ef7e8",
      messagingSenderId: "655140052537",
      projectId: "devmobileflutter-f86e4",
      databaseURL: "https://devmobileflutter-f86e4-default-rtdb.firebaseio.com/",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _codigo;
  String? _descricao;
  String? _valor;
  TextEditingController _codigoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProdutoInf();
  }

  // Função para pegar a versão do Firebase
  Future<void> _getProdutoInf() async {
    final event = await _database.child('codigo').once();
    final event2 = await _database.child('descricao').once();
    final event3 = await _database.child('valor').once();
    setState(() {
      _codigo = event.snapshot.value?.toString();
      _descricao = event2.snapshot.value?.toString();
      _valor = event3.snapshot.value?.toString();
    });
  }

  // Função para atualizar a versão no Firebase
  Future<void> _atualizarProduto() async {
    if (_codigoController.text.isNotEmpty && _descricaoController.text.isNotEmpty && _valorController.text.isNotEmpty) {
      await _database.child('codigo').set(_codigoController.text);
      await _database.child('descricao').set(_descricaoController.text);
      await _database.child('valor').set(_valorController.text);
      _getProdutoInf(); 
      _codigoController.clear(); 
      _descricaoController.clear(); 
      _valorController.clear(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("produto do Firebase")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _codigo == null
                  ? CircularProgressIndicator()
                  : Column(children: [Text("Codigo no Firebase: $_codigo") , Text("Descricao no Firebase: $_descricao"), Text("valor no Firebase: $_valor")],) ,
              SizedBox(height: 20),
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: "Novo codigo",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Nova descricao",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: "Novo valor",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarProduto,
                child: Text("Atualizar produto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
