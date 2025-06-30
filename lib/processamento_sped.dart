import 'dart:convert';
import 'dart:io';

class ProcessamentoSped {
  final String filePath;
  final String fileName;
  final bool correcaoC150;
  final bool ajusteUnidadeMedida;

  final List<String> novoSped;

  static const String _codPaisBrasil = '1058';

  final Map<String, String> _unidadesMedida;

  ProcessamentoSped(
      this.filePath, this.fileName, this.correcaoC150, this.ajusteUnidadeMedida)
      : novoSped = <String>[],
        _unidadesMedida = <String, String>{};

  Future<void> lerSped() async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException('Arquivo não encontrado: $filePath');
    }

    final sped = await file.readAsLines(encoding: latin1);
    for (final line in sped) {
      final linha = line.split('|');

      if (linha.isEmpty) continue;

      final registro = linha[1];

      if (correcaoC150 && registro == '0150') {
        if (linha.length < 6) {
          throw FormatException(
              'Linha 0150 inválida: $line. Esperado pelo menos 3 campos.');
        }

        final codPais = linha[4];

        final cnpj = linha[5];
        final cpf = linha[6];

        if (codPais.isEmpty && (cnpj.isEmpty || cpf.isEmpty)) {
          linha[4] = _codPaisBrasil;
          novoSped.add(linha.join('|'));
          continue;
        }
      }

      if (ajusteUnidadeMedida) {
        if (registro == '0200') {
          if (linha.length < 3) {
            throw FormatException(
                'Linha 0200 inválida: $line. Esperado pelo menos 3 campos.');
          }

          final codigo = linha[2];
          final unidadeMedida = linha[6];

          if (codigo.isEmpty || unidadeMedida.isEmpty) {
            throw FormatException(
                'Código ou unidade de medida vazia na linha 0200: $line');
          }

          _unidadesMedida[codigo] = unidadeMedida;
        }

        if (registro == 'C170') {
          if (linha.length < 9) {
            throw FormatException(
                'Linha C170 inválida: $line. Esperado pelo menos 9 campos.');
          }

          final codigoC170 = linha[3];

          final unidadeCorreta = _unidadesMedida[codigoC170];
          if (unidadeCorreta != null) {
            linha[6] = unidadeCorreta;
            novoSped.add(linha.join('|'));
            continue;
          }
        }
      }

      novoSped.add(line);

      if (registro == '9999') {
        break;
      }
    }
  }

  void gerarSped() {
    if (novoSped.isEmpty) {
      throw FormatException('Nenhum dado processado para gerar o SPED.');
    }

    final file = File(filePath);

    // Remove o arquivo antigo
    if (file.existsSync()) {
      file.deleteSync();
    }

    for (final linha in novoSped) {
      file.writeAsBytesSync(
        '$linha\n'.codeUnits,
        mode: FileMode.append,
      );
    }
  }
}
