import 'package:flutter/material.dart';
import 'package:notas_diarias/helper/anotationHelper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Anotation> _anotations = [];

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  var _db = AnotationHelper();

  @override
  void initState() {
    super.initState();
    _recoveryAnotations();
  }

  _exibirTelaCadastro() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Salvar Anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _title,
                  decoration: const InputDecoration(
                      hintText: "Digite titulo...", labelText: "Titulo"),
                ),
                TextField(
                  controller: _description,
                  decoration: const InputDecoration(
                      hintText: "Digite a descrição...",
                      labelText: "Descrição"),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _saveAndUpdateAnotation();
                  Navigator.pop(context);
                },
                child: const Text("Salvar"),
              ),
              ElevatedButton(
                onPressed: () {
                  _title.clear();
                  _description.clear();
                  Navigator.of(context).pop(context);
                },
                child: const Text("Cancelar"),
              ),
            ],
          );
        });
  }

  _saveAndUpdateAnotation() async {
    String? title = _title.text;
    String? description = _description.text;

    Anotation anotation =
        Anotation(title, description, DateTime.now().toString());

    int result = await _db.saveAnotation(anotation);

    _recoveryAnotations();

    print("Dados salvos: " + result.toString());

    _title.clear();
    _description.clear();
  }

  _recoveryAnotations() async {
    List recoveryAnotations = await _db.recoveryAnotation();

    print("Listagem: " + recoveryAnotations.toString());

    List<Anotation> tempList = [];
    for (var item in recoveryAnotations) {
      Anotation anotation = Anotation.fromMap(item);
      tempList.add(anotation);
    }

    setState(() {
      _anotations = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Minhas Anotações"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _anotations.length,
              itemBuilder: (context, index) {
                final anotation = _anotations[index];
                return Card(
                  child: ListTile(
                    title: Text(anotation.title.toString()),
                    subtitle: Text(
                        "${anotation.description} - ${anotation.date.toString()}"),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirTelaCadastro();
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
