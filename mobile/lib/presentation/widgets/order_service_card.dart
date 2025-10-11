// lib/presentation/widgets/order_service_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/domain/models/order_service_model.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/order_service_view_model.dart';

class OrderServiceCard extends ConsumerWidget {
  final OrderServiceModel order;

  const OrderServiceCard({super.key, required this.order});

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'atrasada':
        return Colors.red.shade700;
      case 'concluída':
        return AppColors.primaryGreen;
      default:
        return Colors.yellow.shade700;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: AppColors.lightGray,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.equipamento?.peca ?? 'N/A',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    order.status ?? 'N/A',
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              'Solicitante: ${order.solicitante?.nome ?? 'N/A'}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 5.h),
            Text(
              'Tipo: ${order.tipo ?? 'N/A'}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            Text(
              'Setor: ${order.setor ?? 'N/A'}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            Text(
              'Recorrência: ${order.recorrencia ?? 'N/A'}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            Text(
              'Detalhes: ${order.detalhes ?? 'N/A'}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    _showEditDialog(context, ref);
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: BorderSide(color: AppColors.primaryGreen),
                  ),
                ),
                SizedBox(width: 8.w),
                OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(context, ref);
                  },
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Excluir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final statusOptions = ['Aberta', 'Em andamento', 'Concluída', 'Atrasada'];
    String selectedStatus = order.status ?? 'Aberta';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Atualizar Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ordem: ${order.equipamento?.peca ?? 'N/A'}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              const Text('Novo Status:'),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: statusOptions.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await ref
                    .read(orderServiceNotifierProvider.notifier)
                    .updateOrder(id: order.id, status: selectedStatus);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Status atualizado com sucesso!'
                            : 'Erro ao atualizar status',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Deseja realmente excluir a ordem de serviço "${order.equipamento?.peca ?? 'N/A'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref
                  .read(orderServiceNotifierProvider.notifier)
                  .deleteOrder(order.id);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Ordem excluída com sucesso!'
                          : 'Erro ao excluir ordem',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
