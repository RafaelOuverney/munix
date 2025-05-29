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

class AplicativoCadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey();
    final padding = MediaQuery.of(context).size.width/7;
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Container(
        padding: EdgeInsets.only(left: padding, right: padding),
        child: Form(
          
          child: ListView(
            children: [
              campos_formulario("Nome",Icon(Icons.person_add_alt_1), context),
              campos_formulario("Item",Icon(Icons.remove), context)
            ],
            
          )
          ), 
              key: _formKey),
    );
  }
}
