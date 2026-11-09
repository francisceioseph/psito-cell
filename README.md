# Psito Cell

Paciência no estilo FreeCell com calopsitas, para Windows, Linux e macOS.
Sem telemetria, sem anúncios, sem conta. Só joguinho e felicidade.

Faz parte da ideia do **Psito Games**, uma suíte de jogos casuais em Flutter.

![A mesa do Psito Cell](docs/screenshot.png)

## Como jogar

Leve todas as cartas para os quatro ninhos, do Ás ao Rei, por naipe.

- Nas colunas, a carta vai sobre outra um número acima, de cor diferente.
- Cada poleiro guarda uma carta por vez.
- Clique em uma carta e depois no destino, ou arraste.
- Duplo clique manda a carta para o melhor lugar.

| Atalho | Ação |
|---|---|
| `Ctrl+Z` | Desfazer |
| `Ctrl+R` | Recomeçar este jogo |
| `Ctrl+N` | Novo jogo |

## Desenvolvimento

```bash
flutter run -d linux
flutter analyze
flutter test
```

- `lib/src/game/`: as regras, em Dart sem interface.
- `lib/src/ui/`: a mesa, as cartas e as animações.
- `lib/l10n/`: os textos em inglês e português.
- `tools/prepare_art.py`: transforma as ilustrações originais em `assets/`.

Ainda faltam as ilustrações dos ases de Copas e Ouros, e a mesa, os poleiros e
os ninhos definitivos. Até lá, eles são desenhados em código.

## Licença

O código segue a [Apache 2.0](LICENSE), e a arte, a [CC0](assets/LICENSE.md).
