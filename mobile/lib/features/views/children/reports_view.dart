// lib/features/views/children/reports_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/stock_view_model.dart';
import 'package:mobile/view_model/order_service_view_model.dart';
import 'package:mobile/view_model/user_view_model.dart';

class ReportsView extends ConsumerWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockViewModelProvider);
    final ordersState = ref.watch(orderListProvider);
    final usersState = ref.watch(userListProvider);
    final alertsState = ref.watch(lowStockAlertsProvider);

    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: AppColors.accentWhite,
        foregroundColor: AppColors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(stockViewModelProvider);
              ref.invalidate(orderListProvider);
              ref.invalidate(userListProvider);
              ref.invalidate(lowStockAlertsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(stockViewModelProvider);
          ref.invalidate(orderListProvider);
          ref.invalidate(userListProvider);
          ref.invalidate(lowStockAlertsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção
              const Text(
                'Visão Geral',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Cards de estatísticas
              _buildStatisticsGrid(
                context,
                stockState,
                ordersState,
                usersState,
                alertsState,
              ),
              const SizedBox(height: 24),

              // Ordens por Status
              const Text(
                'Ordens de Serviço por Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              ordersState.when(
                data: (orders) => _buildOrdersByStatus(orders),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => _buildErrorCard('Erro ao carregar ordens'),
              ),
              const SizedBox(height: 24),

              // Alertas de Estoque
              const Text(
                'Alertas de Estoque Baixo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              alertsState.when(
                data: (alerts) => _buildStockAlerts(alerts),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => _buildErrorCard('Erro ao carregar alertas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(
    BuildContext context,
    AsyncValue stockState,
    AsyncValue ordersState,
    AsyncValue usersState,
    AsyncValue alertsState,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        // Total de Ordens
        ordersState.when(
          data: (orders) => _buildStatCard(
            icon: Icons.assignment,
            title: 'Ordens de Serviço',
            value: orders.length.toString(),
            color: AppColors.primaryGreen,
          ),
          loading: () => _buildLoadingCard(),
          error: (e, st) => _buildStatCard(
            icon: Icons.assignment,
            title: 'Ordens de Serviço',
            value: '-',
            color: AppColors.errorRed,
          ),
        ),

        // Total de Peças
        stockState.when(
          data: (stock) => _buildStatCard(
            icon: Icons.inventory_2,
            title: 'Peças em Estoque',
            value: stock.length.toString(),
            color: AppColors.darkGreen,
          ),
          loading: () => _buildLoadingCard(),
          error: (e, st) => _buildStatCard(
            icon: Icons.inventory_2,
            title: 'Peças em Estoque',
            value: '-',
            color: AppColors.errorRed,
          ),
        ),

        // Alertas de Estoque
        alertsState.when(
          data: (alerts) => _buildStatCard(
            icon: Icons.warning,
            title: 'Alertas de Estoque',
            value: alerts.length.toString(),
            color: alerts.isEmpty ? AppColors.successGreen : Colors.orange,
          ),
          loading: () => _buildLoadingCard(),
          error: (e, st) => _buildStatCard(
            icon: Icons.warning,
            title: 'Alertas de Estoque',
            value: '-',
            color: AppColors.errorRed,
          ),
        ),

        // Total de Usuários
        usersState.when(
          data: (users) => _buildStatCard(
            icon: Icons.people,
            title: 'Usuários',
            value: users.length.toString(),
            color: AppColors.accentYellow,
          ),
          loading: () => _buildLoadingCard(),
          error: (e, st) => _buildStatCard(
            icon: Icons.people,
            title: 'Usuários',
            value: '-',
            color: AppColors.errorRed,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      color: AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 3,
      color: AppColors.lightGray,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildOrdersByStatus(List orders) {
    // Contar ordens por status
    final Map<String, int> statusCount = {};
    for (var order in orders) {
      final status = order.status ?? 'Sem status';
      statusCount[status] = (statusCount[status] ?? 0) + 1;
    }

    if (statusCount.isEmpty) {
      return _buildEmptyCard('Nenhuma ordem de serviço cadastrada');
    }

    return Card(
      elevation: 2,
      color: AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: statusCount.entries.map((entry) {
            final percentage = orders.isNotEmpty
                ? (entry.value / orders.length * 100).toStringAsFixed(0)
                : '0';

            Color statusColor;
            switch (entry.key.toLowerCase()) {
              case 'aberta':
              case 'pendente':
                statusColor = Colors.blue;
                break;
              case 'em andamento':
              case 'em progresso':
                statusColor = Colors.orange;
                break;
              case 'concluída':
              case 'finalizada':
                statusColor = AppColors.successGreen;
                break;
              case 'atrasada':
              case 'cancelada':
                statusColor = AppColors.errorRed;
                break;
              default:
                statusColor = Colors.grey;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value} ($percentage%)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStockAlerts(List alerts) {
    if (alerts.isEmpty) {
      return Card(
        elevation: 2,
        color: AppColors.lightGray,
        child: const Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.successGreen,
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  'Nenhum alerta de estoque!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.successGreen,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Todas as peças estão com estoque adequado',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: alerts.take(5).map<Widget>((alert) {
        final currentQty = alert.quantidade ?? 0;
        final minQty = alert.quantidadeMinima ?? 0;
        final deficit = minQty - currentQty;
        final percentage = minQty > 0 ? (currentQty / minQty * 100) : 0;

        Color alertColor;
        if (percentage < 30) {
          alertColor = AppColors.errorRed;
        } else if (percentage < 60) {
          alertColor = Colors.orange;
        } else {
          alertColor = AppColors.accentYellow;
        }

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          color: AppColors.lightGray,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: alertColor,
              child: const Icon(Icons.warning, color: Colors.white),
            ),
            title: Text(
              alert.nome ?? 'Sem nome',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Estoque: $currentQty | Mínimo: $minQty | Déficit: $deficit',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            trailing: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: alertColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      elevation: 2,
      color: AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      elevation: 2,
      color: AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.error, color: AppColors.errorRed, size: 48),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
