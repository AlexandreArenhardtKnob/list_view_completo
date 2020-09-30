import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Cliente {
  String nome;
  int idade;

  Cliente(this.nome, this.idade);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //List<Cliente> clientes = List();
  List<Cliente> clientes = <Cliente> [
      Cliente("Carro",  23),
  ];

  int ordem = 1;
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  bool temFiltro = false;



  TextEditingController busca = TextEditingController();
  String textoBusca="";

  @override
  void initState() {
    super.initState();


    clientes.add(Cliente("Marcelo", 30));
    clientes.add(Cliente("João", 20));
    clientes.add(Cliente("Alexandre", 25));

    clientes.sort((a,b){
      return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
    });

    for (Cliente p in clientes) {
      temFiltro = p.nome.toLowerCase().contains("alexandre");
      print(p.nome + " " + p.idade.toString() + temFiltro.toString());
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text("Teste de Listas - OnTap"),
        actions: <Widget>[
          IconButton(
            icon: Icon(ordem==1 ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: (){
                if (ordem==1){
                  ordenaLista(1);
                  ordem=2;
                } else {
                  ordenaLista(2);
                  ordem=1;
                }

            },

          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                child: Text("Ordenar de A-Z"),
                value: 1,
              ),
              const PopupMenuItem<int>(
                child: Text("Ordenar de Z-A"),
                value: 2,
              ),
            ],
            onSelected: ordenaLista,
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: (){
          setState(() {
            _nomeController.text = "";
            _idadeController.text = "";
          });
          editaDados(context, 0,1);
        },
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(7.0),
        child: Column(
          children: <Widget>[
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: busca,
              decoration: InputDecoration(

                  hintText: "Busca por nome",
                  contentPadding: EdgeInsets.all(5),
                  prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: null),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4),)
              ),

              onChanged: (texto) {
                setState(() {
                  textoBusca = busca.text.toLowerCase();

                });
              },
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(1.0),
              itemCount: clientes.length,
              itemBuilder: (BuildContext context, int index) {
                //return  _montaItem(context, index);
                return  clientes[index].nome.toLowerCase().contains(textoBusca) ? _montaItem(context, index) : Container()  ;
               // return _montaItem(context, index);
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _montaItem(BuildContext context, index) {
    return
      Card( // Lista os clientes

          child: ListTile(
            onTap: () {
              editaDados(context, index,2);
            },

            title: Text(clientes[index].nome, style: TextStyle(fontSize: 25)),
            subtitle: Text(clientes[index].idade.toString(),style: TextStyle(fontSize: 20)),

            trailing:
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  color: Colors.blueAccent,
                  onPressed: (){
                    editaDados(context, index,2); // alteraçao
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  color: Colors.redAccent,
                  onPressed: (){
                    _confirmaExclusao(context, index);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),

          ));
   }

  _alerta() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Atenção !"),
          content: Text(
            "Nome já Cadastrado ! ",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  _confirmaExclusao(BuildContext context, index) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nome : " + clientes[index].nome),
          content:
          Text("Confirma a exclusão do " + clientes[index].nome + " ?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  clientes.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void ordenaLista(int qualOrdem){

    if (qualOrdem==1) {
      clientes.sort((a,b){
        return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
      });
    } else if  (qualOrdem==2){
      clientes.sort((a,b){
        return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
      });
    }
    setState(() {

    });
  }


  void editaDados(BuildContext context, index, int tipo){
    if (tipo==2){
      _nomeController.text  = clientes[index].nome;
      _idadeController.text = clientes[index].idade.toString();
    }
    String titulo = "";

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tipo==1 ? "Inclusão de Dados" : "Alteração de Dados"),
          content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      controller: _nomeController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(labelText: "Nome",),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      controller: _idadeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(labelText: "Idade",),
                    ),
                  )
                ],
              )),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Gravar'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  if (tipo==2){ // é alteração
                    print("alterar");
                    clientes.setAll(index,[Cliente(_nomeController.text,int.parse(_idadeController.text))]);
                  } else { // é inclusão
                    bool jaTem = false;
                    for (Cliente p in clientes) {
                      /// percorre  a lista e verifica se ja tem esse cliente
                      if (p.nome == _nomeController.text) {
                        jaTem = true;
                      }
                    }
                    if (jaTem == false) {
                      clientes.add(Cliente(_nomeController.text,int.parse(_idadeController.text)));
                      ordenaLista(1);
                    } else {
                      _alerta();
                    }
                  }
                  _nomeController.text="";
                  _idadeController.text="";
                });
              },
            ),
          ],
        );
      },
    );

  }

  }
