# Plano de Execução: Velox Delivery (Enatega Clone)

## Fase 1: Estrutura e Modelos (Monorepo)
- [x] Criar estrutura de pastas (Monorepo)
- [x] Definir Blueprint do Firebase e Security Rules
- [x] Implementar Modelos Compartilhados (User, Restaurant, Food, Order)
- [x] Configurar Cloud Functions básicas (Taxa, Notificação, Validação)

## Fase 2: Serviços Compartilhados (shared_core)
- [x] Implementar `AuthService` (Firebase Auth)
- [x] Implementar `DatabaseService` (Firestore Queries/Writes)
- [x] Implementar `StorageService` (Upload de Imagens)
- [x] Implementar `LocationService` (Geolocalização e Geohash)

## Fase 3: App Cliente (customer_app)
- [x] Tema e Estilização Base
- [x] Fluxo de Login/Cadastro (UI)
- [x] Home Screen: Lista de Restaurantes (UI)
- [x] Tela de Menu do Restaurante (Categorias e Pratos)
- [x] Detalhe do Produto (Variações e Adicionais)
- [x] Gerenciamento de Carrinho (State Management - Riverpod)
- [x] Checkout e Finalização de Pedido
- [x] Acompanhamento Real-time (Mapa e Status)

## Fase 4: App Restaurante (restaurant_app)
- [x] UI Base e Login
- [x] Dashboard de Pedidos (Real-time UI)
- [x] Integração com Comanda Digital (Mesas)
- [ ] Gestão de Status do Pedido
- [ ] Gerenciador de Cardápio (CRUD de Produtos)

## Fase 5: App Entregador (rider_app)
- [x] UI Base e Login
- [x] Modo Online/Offline
- [x] Fluxo de Aceite de Entrega (UI)
- [ ] Roteamento com Google Maps

## Fase 8: App Garçom (waitress_app)
- [x] Dashboard de Notificações
- [x] Gerenciamento de Mesas (UI)
- [ ] Chamado de Garçom (Push para App Garçom)
- [ ] Lançamento Manual de Pedidos na Mesa

---

### Pendências Técnicas Atuais (Refinamento Necessário)
1.  **State Management:** Finalizar migração de todos os apps para Riverpod (atualmente misto).
2.  **Navigation:** Padronizar `onGenerateRoute` ou usar `GoRouter` para links profundos (QR Codes).
3.  **Real-time:** Conectar as UI de notificações aos streams reais do Firestore `notifications`.
4.  **Security:** Revisar `firestore.rules` especificamente para as coleções `tables` e `notifications`.
5.  **Dine-in:** Implementar lógica de "Fechar Conta" que bloqueia a mesa até o pagamento.
6.  **Admin:** Implementar gerador de QR Codes por mesa no Dashboard Web.

## Fase 6: Admin Web Dashboard
- [x] Dashboard de Métricas (UI)
- [ ] Gestão de Aprovações (Restaurantes/Entregadores)
- [ ] Configurações Globais do Sistema

## Fase 7: Integrações Finais
- [ ] Chat Real-time
- [ ] Push Notifications (FCM)
- [ ] Refinamento de UX e Testes de Fluxo Completo
