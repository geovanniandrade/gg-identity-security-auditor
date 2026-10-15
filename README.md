# 🔐 GG // Identity Security Auditor

[![STATUS MVP](https://img.shields.io/badge/STATUS_MVP-8B5CF6?style=for-the-badge&logoColor=white)](https://github.com/geovanniandrade/gg-identity-security-auditor) [![ABRIR INTERFACE](https://img.shields.io/badge/ABRIR_INTERFACE-8B5CF6?style=for-the-badge&logo=googlechrome&logoColor=white)](https://geovanniandrade.github.io/gg-identity-security-auditor/) [![REPOSITÓRIO](https://img.shields.io/badge/REPOSIT%C3%93RIO-8B5CF6?style=for-the-badge&logo=github&logoColor=white)](https://github.com/geovanniandrade/gg-identity-security-auditor)

Auditoria inicial de identidades com registros exportados de forma autorizada.

## 🎯 O que faz?

Contagem de contas, sinalização de contas ativas sem logon há mais de 90 dias e revisão de administradores.

## 🧪 Demonstração e uso corporativo

- **Demonstração:** clique em **Carregar exemplo fictício** ou baixe o CSV de demonstração na interface.
- **Uso corporativo autorizado:** o [coletor PowerShell somente leitura](collector/Export-IdentityAudit.ps1) exporta o formato esperado a partir do AD, mas exige módulo ActiveDirectory, permissão de consulta, revisão e aprovação da equipe. Não contorne políticas de execução.
- **Atenção:** `LastLogonDate` pode não ser preciso; `IsAdmin` verifica apenas associação direta a um conjunto limitado de grupos, não privilégios efetivos.

## 🚀 Como utilizar

1. Prepare um CSV com `User,Enabled,LastLogonDays,IsAdmin`.
2. Importe o arquivo na interface web.
3. Revise contas com logon antigo e contas marcadas como administrativas; abra o relatório em tela separada e salve como PDF.

## 🧪 Exemplo prático

Uma conta administrativa fictícia permanece ativa sem logon recente e é indicada para revisão, não para desativação automática.

> **Status:** versão MVP educacional, com processamento local no navegador e sem backend próprio. Não homologada para produção. Não envie dados corporativos confidenciais nem considere a saída como diagnóstico definitivo.

## 🔍 Interpretação do relatório

Ao clicar nos indicadores de contas, o relatório mostra os usuários correspondentes do CSV, com filtros de contas e logon antigo. As verificações de políticas de senha, lockout, MFA, grupos aninhados e privilégios efetivos ainda aparecem como **não avaliadas**: o coletor atual não disponibiliza evidências suficientes para confirmá-las. Não publique o CSV ou PDF com usuários corporativos em repositórios públicos.

## 🧩 Coletor v2 (escopo autorizado)

O [Export-IdentityAudit-v2.ps1](collector/Export-IdentityAudit-v2.ps1) permite restringir o escopo pela OU com o parâmetro `-SearchBase`. Gera:

- `gg-identity-audit-v2.csv`: usuários, conta habilitada, logon aproximado, flags de senha, bloqueio, criação, idade da senha e associação a alguns grupos privilegiados.
- `gg-domain-policy.json`: resumo da política de senha padrão do domínio, para revisão **separada**. Não avalia FGPP/GPO efetiva.

O aplicativo web interpreta as novas colunas do CSV. Dados de AD devem permanecer em fluxo corporativo autorizado. O script continua não assinado; não contorne políticas de execução.

## 📌 Próximas melhorias

Adicionar verificações de grupos e permissões, com coleta AD somente leitura e testes controlados.

---

**GG // Security Applications** · Segurança acessível, investigação responsável e resultados verificáveis.


---
## 🧭 Navegação e demonstração

- [🌐 Interface web](https://geovanniandrade.github.io/gg-identity-security-auditor/)
- [📋 Checklist de qualidade, testes e limitações](QUALITY.md)
- [🧪 Exemplo fictício para demonstração](examples/gg-identity-demo.csv)

**Identidade visual:** Roxo. **Versão:** MVP 0.2 (identificador documental; não significa homologação).

**Fluxo recomendado:** usar o exemplo fictício → revisar os resultados → abrir relatório → salvar PDF apenas após conferir o conteúdo. Em ambientes reais, verificar autorização, origem dos dados e precisão das conclusões. Nunca incluir inventário, nomes reais de usuários ou dados sensíveis em issues e repositórios públicos.

**Limites:** ferramentas de triagem, não substituem avaliação profissional nem comprovam conformidade. As validações executadas e pendentes estão em [QUALITY.md](QUALITY.md).
