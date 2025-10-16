# Monitor de Bateria 🔋
Aplicação Flutter para monitoramento em tempo real do nível de bateria com alertas inteligentes, Broadcast Receiver nativo e interface moderna em tema escuro.

#

## Sobre o Projeto
Aplicação mobile desenvolvida em Flutter que oferece monitoramento completo da bateria do dispositivo, incluindo:

- Broadcast Receiver nativo em Kotlin para monitoramento em tempo real do nível de bateria.
- Monitoramento contínuo do nível de bateria via eventos nativos do Android.
- Alerta automático quando a bateria cai abaixo de 20%.
- Indicador visual circular animado.
- Detecção de estado de carregamento.
- Interface moderna com tema escuro.
- Link direto para o GitHub via intent implícita.

## 📦 Pacotes Utilizados

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| `battery_plus` | ^6.0.0 | Acesso ao nível e estado da bateria do dispositivo |
| `provider` | ^6.1.1 | Gerenciamento de estado reativo |
| `url_launcher` | ^6.2.5 | Abertura de URLs externas (GitHub) |


## ⚡ Funcionalidades

- Monitoramento Inteligente:
    - Atualização automática a cada 30 segundos.
    - Detecção instantânea de mudanças no estado de carregamento.

- Alertas Visuais:
    - SnackBar vermelho quando a bateria cai abaixo de 20%.
    
- Interface Visual:
    - Círculo animado com cores dinâmicas:
        - 🔴 Vermelho: < 20% (bateria baixa).
        - 🟠 Laranja: 20-49% (bateria média).
        - 🟢 Verde: ≥ 50% (bateria boa).
        - ⚡ Ícone de raio durante carregamento.

- Integração Externa
    - Botão com intent implícita para abrir perfil do GitHub

## 🏗️ Arquitetura
O projeto segue o padrão MVVM (Model-View-ViewModel) para melhor organização e manutenibilidade:

```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── models/
│   └── battery_model.dart             # Modelo de dados da bateria
├── services/
│   └── battery_service.dart           # Serviço de monitoramento de bateria
├── viewmodels/
│   └── battery_viewmodel.dart         # Lógica de negócio e estado
└── views/
    └── battery_monitor_view.dart      # Interface do usuário

```

### Responsabilidades:
- Model: Estrutura de dados da bateria (nível, estado, cores).
- Service: Comunicação com API nativa do dispositivo (Battery Plus).
- ViewModel: Gerenciamento de estado, lógica de alertas e monitoramento.
- View: Renderização da UI com círculo animado e interações.




## 🤝 Contribuindo
Contribuições são bem-vindas! Sinta-se à vontade para:
 - Fazer um fork do projeto
 - Criar uma branch para sua feature (git checkout -b feature/NovaFeature)
 - Commitar suas mudanças (git commit -m 'Nova Funcionalidade')
 - Push para a branch (git push origin feature/NovaFeature)
 - Abrir um Pull Request