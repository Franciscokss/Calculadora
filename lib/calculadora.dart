import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'Limpar';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else if (valor == 'sen' ||
          valor == 'cos' ||
          valor == 'tan' ||
          valor == '^') {
        _expressao += valor;
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Calculo inválido';
    }
  }

  double _avaliarExpressao(String expressao) {
    // Substituir operadores personalizados
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');

    // Verificar e calcular potências
    if (expressao.contains('^')) {
      List<String> partes = expressao.split('^');
      double base = double.parse(partes[0]);
      double expoente = double.parse(partes[1]);
      return pow(base, expoente).toDouble();
    }

    // Verificar e calcular funções trigonométricas
    if (expressao.startsWith('sen')) {
      double valor = double.parse(expressao.substring(3));
      return sin(valor * (pi / 180)); // Converte graus para radianos
    } else if (expressao.startsWith('cos')) {
      double valor = double.parse(expressao.substring(3));
      return cos(valor * (pi / 180));
    } else if (expressao.startsWith('tan')) {
      double valor = double.parse(expressao.substring(3));
      return tan(valor * (pi / 180));
    }

    // Avaliar expressões matemáticas padrão
    ExpressionEvaluator avaliador = const ExpressionEvaluator();
    return avaliador.eval(Expression.parse(expressao), {});
  }

  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('x'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao('.'),
              _botao('^'),
              _botao('+'),
              _botao('sen '),
              _botao('cos '),
              _botao('tan '),
              _botao('='),
            ],
          ),
        ),
        Expanded(
          child: _botao(_limpar),
        )
      ],
    );
  }
}
