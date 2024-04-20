import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController controlador = TextEditingController();
  Tarefa? _tarefaSelecionada;
  bool _modoNoturno = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _modoNoturno ? _buildDarkTheme() : _buildLightTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Minhas Tarefas',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 24.0,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(_modoNoturno ? Icons.wb_sunny : Icons.nightlight_round),
                onPressed: () {
                  setState(() {
                    _modoNoturno = !_modoNoturno;
                  });
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_tarefas[index].descricao),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      setState(() {
                        _tarefas.removeAt(index);
                      });
                    },
                    child: ListTile(
                      title: Text(
                        _tarefas[index].descricao,
                        style: TextStyle(
                          decoration: _tarefas[index].status
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                controlador.text = _tarefas[index].descricao;
                                _tarefaSelecionada = _tarefas[index];
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _tarefas.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _tarefas[index].status = !_tarefas[index].status;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controlador,
                decoration: InputDecoration(
                  hintText: 'Descrição',
                  border: OutlineInputBorder(),
                  suffixIcon: _tarefaSelecionada == null
                      ? null
                      : IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              controlador.clear();
                              _tarefaSelecionada = null;
                            });
                          },
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_tarefaSelecionada == null) {
                        _tarefas.add(
                          Tarefa(
                            descricao: controlador.text,
                            status: false,
                          ),
                        );
                      } else {
                        _tarefaSelecionada!.descricao = controlador.text;
                        _tarefaSelecionada = null;
                      }
                      controlador.clear();
                    });
                  },
                  child: Text(_tarefaSelecionada == null ? 'Adicionar Tarefa' : 'Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primaryColor: Colors.purpleAccent,
      fontFamily: 'Roboto',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.purpleAccent,
      fontFamily: 'Roboto',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
