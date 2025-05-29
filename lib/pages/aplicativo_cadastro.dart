import 'package:flutter/material.dart';

Widget campos_formulario(labelText,suffixIcon, context){
  
  return SizedBox(
    // width: MediaQuery.of(context).size.width/2.5,
    child: TextFormField(
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        label: Text(labelText),
      ),
    ),
  );
}

Widget campo_opcoes(labelText, context, itens) {
  return SizedBox(
    // width: MediaQuery.of(context).size.width/2.5,
    child: DropdownButtonFormField(
      decoration: InputDecoration(
        label: Text(labelText),
      ),
      items: itens,
      onChanged: (value) {},
    ),
  );
}

class AplicativoCadastro extends StatelessWidget {
  const AplicativoCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey();
    final padding = MediaQuery.of(context).size.width/7;
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Container(
        padding: EdgeInsets.only(left: padding, right: padding), 
              key: formKey,
        child: Form(
          
          child: ListView(
            children: [
              campos_formulario("Nome",Icon(Icons.person_add_alt_1), context),
              campos_formulario("Item",Icon(Icons.remove), context),
              campos_formulario("Quantidade",Icon(Icons.add), context),
              campo_opcoes('cidades', context, [
                DropdownMenuItem(value: 'ND', child: Text('Selecionar Valor')),
                DropdownMenuItem(value: 'SP', child: Text('São Paulo')),
                DropdownMenuItem(value: 'RJ', child: Text('Rio de Janeiro')),
                DropdownMenuItem(value: 'MG', child: Text('Minas Gerais')),
              ]),
            ],
            
          )
          )),
    );
  }
}
