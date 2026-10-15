# 🔐 GG // Identity Security Auditor

[![STATUS MVP](https://img.shields.io/badge/STATUS_MVP-8B5CF6?style=for-the-badge&logoColor=white)](https://github.com/geovanniandrade/gg-identity-security-auditor) [![ABRIR INTERFACE](https://img.shields.io/badge/ABRIR_INTERFACE-8B5CF6?style=for-the-badge&logo=googlechrome&logoColor=white)](https://geovanniandrade.github.io/gg-identity-security-auditor/) [![REPOSITÓRIO](https://img.shields.io/badge/REPOSIT%C3%93RIO-8B5CF6?style=for-the-badge&logo=github&logoColor=white)](https://github.com/geovanniandrade/gg-identity-security-auditor)

Auditoria inicial de identidades com registros exportados de forma autorizada.

## 🎯 O que faz?

Contagem de contas, sinalização de contas ativas sem logon há mais de 90 dias e revisão de administradores.

## 🚀 Como utilizar

1. Prepare um CSV com `User,Enabled,LastLogonDays,IsAdmin`.
2. Importe o arquivo na interface web.
3. Revise contas com logon antigo e contas marcadas como administrativas; gere o resumo em PDF.

## 🧪 Exemplo prático

Uma conta administrativa fictícia permanece ativa sem logon recente e é indicada para revisão, não para desativação automática.

> **Status:** versão MVP educacional, com processamento local no navegador e sem backend próprio. Não homologada para produção. Não envie dados corporativos confidenciais nem considere a saída como diagnóstico definitivo.

## 📌 Próximas melhorias

Adicionar verificações de grupos e permissões, com coleta AD somente leitura e testes controlados.

---

**GG // Security Applications** · Segurança acessível, investigação responsável e resultados verificáveis.
