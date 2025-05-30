import 'package:flutter/material.dart';
import 'package:munix/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>{
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: CupertinoTextFormFieldRow(
                    autofocus: true,
                    controller: emailController,
                    validator: (value) => value!.isEmpty || !value.contains('@') ? 'E-mail inválido' : null,
                    prefix: const Icon(CupertinoIcons.mail, color: CupertinoColors.inactiveGray),
                    placeholder: 'E-mail',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: const Text(
                  'Um link de recuperação será enviado para o e-mail informado.',
                  style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 25, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  CupertinoButton.filled(
                    onPressed: () {
                      if (!emailController.text.contains('@') || emailController.text.isEmpty) {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: const Text('Erro'),
                            content: const Text('E-mail inválido.'),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      try {
                        AuthService().resetPassword(email: emailController.text);
                      } catch (e) {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: const Text('Erro'),
                            content: const Text('Erro ao enviar o e-mail de recuperação.'),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: const Text('Recuperar Senha'),
                          content: const Text('Um link de recuperação foi enviado para o e-mail informado.'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}