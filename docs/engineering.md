# Engenharia e plano para 1.0

## Verificações automatizadas
O workflow `.github/workflows/quality.yml` usa Node.js e Python (biblioteca padrão) para testar sintaxe JavaScript inline, integridade de links locais, exemplos JSON/CSV e as dez questões da prova.

**Não cobre:** interações reais de navegador, comportamento de APIs externas, segurança de PowerShell, conformidade, renderização de PDF, acessibilidade integral ou testes em Active Directory.

## Critérios para release 1.0
- [ ] Testes de browser em desktop e celular, incluindo navegação por teclado.
- [ ] Fixtures de entrada válida, vazia, malformada e grande.
- [ ] Revisão do modelo de ameaça (XSS, CSV formula injection, links externos e privacidade).
- [ ] Verificação de origem e confiança em cada resultado e recomendação.
- [ ] Revisão independente do código e funcionamento dos coletores, quando existentes.
- [ ] Documentação do ambiente testado, evidências sanitizadas e resultados reproduzíveis.
- [ ] Tag/release somente após checks aprovados e revisão manual.

## Fluxo de contribuição
Crie uma branch para cada alteração, abra pull request, aguarde o check `Static quality checks`, faça revisão e teste manual antes de mesclar. Não exponha dados reais em testes ou issues.
