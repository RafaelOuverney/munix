import 'package:flutter/material.dart';
import 'package:munix/services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>{
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Recuperar Senha',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              child: TextFormField(
                controller: emailController,
                validator: (value) => value!.isEmpty ? 'E-mail inválido' : null,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Um link de recuperação será enviado para o e-mail informado.',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 75),
          Row(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton.icon(onPressed: (){
                if (emailController.text.isEmpty) {
                  showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                    title: const Text('Erro'),
                    content: const Text('E-mail inválido.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
                  return;
                }
                try {
                  AuthService().resetPassword(email: emailController.text);
                } catch (e) {
                  showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                    title: const Text('Erro'),
                    content: const Text('Erro ao enviar o e-mail de recuperação.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
                  return;
                }
                showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                  title: const Text('Recuperar Senha'),
                  content: const Text('Um link de recuperação foi enviado para o e-mail informado.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
                Navigator.pop(context);
              }, 
              label: Text('Enviar'), icon: Icon(Icons.send), style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                iconColor: Colors.white,
                foregroundColor: Colors.white
              ),),
            ],
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}