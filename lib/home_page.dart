import 'dart:async';

import 'package:correcoes_efd_fiscal/processamento_sped.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = 'Correções SPED';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _file;
  bool _correcaoUnidadeMedida = false;
  bool _correcaoCodigoPais = false;

  bool get _habilitaCheckboxCorrecoes {
    return _file != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.insert_drive_file,
                      size: 60, color: Colors.blue.shade700),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(220, 48),
                    ),
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Selecionar arquivo SPED"),
                    onPressed: () async {
                      final path = await _openSpedFile(context);
                      if (path != null) {
                        setState(() {
                          _file = path;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _file == null
                      ? const Text(
                          'Nenhum arquivo selecionado',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )
                      : Text(
                          'Arquivo selecionado: ${_file!.name}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                  const SizedBox(height: 20),
                  if (_file != null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpar seleção'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(180, 40),
                      ),
                      onPressed: () {
                        setState(() {
                          _file = null;
                          _correcaoUnidadeMedida = false;
                          _correcaoCodigoPais = false;
                        });
                      },
                    ),
                  const SizedBox(height: 30),
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            enabled: _habilitaCheckboxCorrecoes,
                            title: const Text('Correção unidade de medida'),
                            subtitle: const Text(
                              'Corrige a unidade de medida do item para o correto',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            value: _correcaoUnidadeMedida,
                            onChanged: (bool? value) {
                              if (value == null) return;
                              setState(() {
                                _correcaoUnidadeMedida = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            enabled: _habilitaCheckboxCorrecoes,
                            title: const Text('Correção 0150 Código País'),
                            subtitle: const Text(
                              'Corrige o código do país no cadastro 0150, caso não esteja preenchido',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            value: _correcaoCodigoPais,
                            onChanged: (bool? value) {
                              if (value == null) return;
                              setState(() {
                                _correcaoCodigoPais = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Processar Arquivo'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(220, 48),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _file == null ||
                            (!_correcaoUnidadeMedida && !_correcaoCodigoPais)
                        ? null
                        : () async {
                            await processarSped(context);
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processarSped(BuildContext context) async {
    try {
      Loader.show(context);

      await Future.delayed(const Duration(milliseconds: 100));

      final processamentoSped = ProcessamentoSped(
        _file!.path,
        _file!.name,
        _correcaoCodigoPais,
        _correcaoUnidadeMedida,
      );

      await processamentoSped.lerSped();

      await processamentoSped.gerarSped();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Arquivo ${_file!.name} processado com sucesso!',
            ),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao processar o arquivo: $e',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 20),
          ),
        );
      }
    } finally {
      Loader.hide();
    }
  }

  Future<XFile?> _openSpedFile(BuildContext context) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'text',
      extensions: <String>['txt'],
    );
    final String? initialDirectory =
        kIsWeb ? null : (await getApplicationDocumentsDirectory()).path;
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
      initialDirectory: initialDirectory,
    );
    if (file == null) {
      return null;
    }

    return file;
  }
}
