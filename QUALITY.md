# GG // Quality & Validation

**Status:** MVP 0.2 — protótipo em evolução, **não homologado para produção**.

## Matriz de revisão

| Área | O que conferir | Situação |
|---|---|---|
| Interface | Cabeçalho, links, botões e responsividade | Revisão estrutural aplicada; teste visual pendente |
| Demonstração | Exemplo fictício em `examples/gg-identity-demo.csv` | Disponibilizado; teste de ponta a ponta pendente |
| Coleta | Revisar código, parâmetros, permissões e formato de saída | Revisão manual e teste autorizado pendentes |
| Importação | Colunas, encoding, vazios, aspas, valores inválidos e grande volume | Testes de regressão pendentes |
| Relatório | Conferir fonte, contagens, filtros, sugestões e impressão/PDF | Teste funcional/visual pendente |
| Privacidade | Confirmar processamento local ou chamadas externas, e não registrar dados sensíveis | Revisão de segurança formal pendente |
| Navegação | Conferir abertura de páginas e caminhos GitHub Pages | Publicação e teste no navegador pendentes |

## Limitações específicas

Coleta AD autorizada; LastLogonDate aproximado, IsAdmin limitado a grupos selecionados, pontuação heurística não homologada.

## Checklist de aceitação

- [ ] Abrir GitHub Pages atualizado com recarga forçada.
- [ ] Carregar exemplo fictício e conferir contagens.
- [ ] Exercitar botões, filtros e mensagens de erro.
- [ ] Abrir relatório em aba nova, quando existir, e imprimir em PDF.
- [ ] Testar arquivo ausente, vazio, incorreto e grande.
- [ ] Validar coletores em laboratório/autorização, sem modificar controles corporativos.
- [ ] Revisar riscos de exposição de dados e o README.
- [ ] Confirmar que controles não coletados estão **não avaliados**, não zero/conforme.

## Política de divulgação

Utilize **somente dados sintéticos** em issues, commits, prints e exemplos públicos. Não faça upload de dados corporativos, nomes de usuários, arquivos recuperados de EDR, chaves ou inventários reais. Em ambientes empresariais, faça revisão, aprovação e homologação antes da adoção.

## Histórico

- **MVP 0.2 (2026-10-15):** padrão de navegação/documentação, exemplos sintéticos e checklist de validação.
