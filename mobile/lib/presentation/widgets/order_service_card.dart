// lib/presentation/widgets/order_service_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/domain/models/order_service_model.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class OrderServiceCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.accentWhite,
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
                    color: _getStatusColor(order.status).withOpacity(0.2),
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
            // Adicione botões de ação se necessário (Editar, Excluir)
            // Lembre-se de passar callbacks para o widget pai ou usar um provedor Riverpod para as ações.
          ],
        ),
      ),
    );
  }
}
