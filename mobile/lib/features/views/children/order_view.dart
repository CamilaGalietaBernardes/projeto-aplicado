// lib/features/views/new_order_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/order_service_view_model.dart';

class NewOrderView extends ConsumerStatefulWidget {
  const NewOrderView({super.key});

  @override
  ConsumerState<NewOrderView> createState() => _NewOrderViewState();
}

class _NewOrderViewState extends ConsumerState<NewOrderView> {
  final TextEditingController obsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  );

  String? _selectedTipoServico;
  String? _selectedSetor;
  String? _selectedSolicitanteName;
  String? _selectedEquipamentoName;
  String? _selectedRecorrencia;
  String? _selectedStatus;
  DateTime? _selectedDate;

  String? _formErrorMessage;

  final List<String> tiposServico = [
    'Manutenção Preventiva',
    'Manutenção Corretiva',
    'Reforma',
    'Instalação',
  ];
  final List<String> setores = [
    'Manutenção',
    'TI',
    'Recursos Humanos',
    'Produção',
    'Administração',
  ];
  final List<String> recorrencias = ['Única', 'Diária', 'Semanal', 'Mensal'];
  final List<String> statusOptions = [
    'Aberta',
    'Em andamento',
    'Concluída',
    'Atrasada',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = statusOptions.first;
    _selectedDate = DateTime.now();
    dateController.text =
        "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
  }

  @override
  void dispose() {
    obsController.dispose();
    dateController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void _resetFormFields() {
    obsController.clear();
    quantityController.text = '1';
    setState(() {
      _selectedTipoServico = null;
      _selectedSetor = null;
      _selectedSolicitanteName = null;
      _selectedEquipamentoName = null;
      _selectedRecorrencia = null;
      _selectedStatus = statusOptions.first;
      _selectedDate = DateTime.now();
      dateController.text =
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      _formErrorMessage = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.accentWhite,
              surface: AppColors.accentWhite,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _handleCreateOrder(
    List<UserModel> users,
    List<StockModel> parts,
  ) async {
    setState(() => _formErrorMessage = null);
    final currentUser = ref.read(sessionProvider);
    final UserModel solicitante = users.firstWhere(
      (u) => u.nome == _selectedSolicitanteName,
      orElse: () => currentUser as UserModel,
    );
    final solicitanteId = solicitante.id;
    int? equipamentoId;
    int? quantidade;
    if (_selectedEquipamentoName != null) {
      final selectedPart = parts.firstWhere(
        (p) => p.peca == _selectedEquipamentoName,
        orElse: () =>
            StockModel(id: -1, peca: '', categoria: '', qtd: 0, qtdMin: 0),
      );
      equipamentoId = selectedPart.id;
      quantidade = int.tryParse(quantityController.text);
      if (equipamentoId != -1 && (quantidade == null || quantidade <= 0)) {
        setState(() {
          _formErrorMessage =
              'Selecione um equipamento e forneça uma quantidade válida maior que zero.';
        });
        return;
      }
      if (equipamentoId == -1) equipamentoId = null;
    }
    if (_selectedTipoServico == null ||
        _selectedSetor == null ||
        _selectedSolicitanteName == null ||
        _selectedRecorrencia == null ||
        _selectedStatus == null ||
        _selectedDate == null) {
      setState(() {
        _formErrorMessage = 'Por favor, preencha todos os campos obrigatórios.';
      });
      return;
    }
    await ref
        .read(orderServiceNotifierProvider.notifier)
        .createOrder(
          tipo: _selectedTipoServico!,
          setor: _selectedSetor!,
          detalhes: obsController.text.isEmpty
              ? 'Nenhum detalhe fornecido.'
              : obsController.text,
          status: _selectedStatus!,
          solicitanteId: solicitanteId,
          recorrencia: _selectedRecorrencia!,
          data: _selectedDate!,
          equipamentoId: equipamentoId,
          quantidade: quantidade,
        );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsyncValue = ref.watch(userListProvider);
    final partsAsyncValue = ref.watch(partListProvider);
    final createOrderState = ref.watch(orderServiceNotifierProvider);
    final isSaving = createOrderState.isLoading;

    ref.listen(orderServiceNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (order) {
          if (order != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Ordem de Serviço ${order.id} criada com sucesso!',
                ),
                backgroundColor: AppColors.primaryGreen,
              ),
            );
            _resetFormFields();
            context.go('/home');
          }
        },
        error: (e, st) {
          setState(() {
            _formErrorMessage = e.toString().contains('Exception:')
                ? e.toString().replaceAll('Exception: ', '')
                : 'Erro de conexão ou validação no servidor.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_formErrorMessage!),
                backgroundColor: AppColors.errorRed,
              ),
            );
          });
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.black),
                  onPressed: () => context.pop(),
                ),
                Text(
                  'Voltar ao Início',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            usersAsyncValue.when(
              data: (users) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildDropdown(
                    'Solicitante',
                    users.map((u) => u.nome).toList(),
                    _selectedSolicitanteName,
                    (val) {
                      setState(() {
                        _selectedSolicitanteName = val;
                      });
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text(
                'Erro ao carregar solicitantes: $e',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildChipRow(
                'Tipo de Serviço',
                tiposServico,
                _selectedTipoServico,
                (val) => setState(() => _selectedTipoServico = val),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDropdown(
                'Setor',
                setores,
                _selectedSetor,
                (val) => setState(() => _selectedSetor = val),
              ),
            ),
            SizedBox(height: 12.h),
            _buildChipRow(
              'Recorrência',
              recorrencias,
              _selectedRecorrencia,
              (val) => setState(() => _selectedRecorrencia = val),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildChipRow(
                'Status',
                statusOptions,
                _selectedStatus,
                (val) => setState(() => _selectedStatus = val),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDateField('Data', dateController),
            ),
            SizedBox(height: 12.h),
            partsAsyncValue.when(
              data: (parts) {
                final partNames = parts
                    .where((p) => p.peca.isNotEmpty)
                    .map((p) => p.peca)
                    .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          'Equipamento/Peça (Opcional)',
                          partNames,
                          _selectedEquipamentoName,
                          (val) {
                            setState(() {
                              _selectedEquipamentoName = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SizedBox(
                        width: 80.w,
                        child: _buildQuantityField('Qtd', quantityController),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text(
                'Erro ao carregar peças: $e',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTextField(
                'Detalhes/Observações',
                obsController,
                maxLines: 2,
              ),
            ),
            SizedBox(height: 24.h),
            if (_formErrorMessage != null)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  _formErrorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.errorRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () => _handleCreateOrder(
                        usersAsyncValue.value ?? [],
                        partsAsyncValue.value ?? [],
                      ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isSaving
                        ? Container(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              color: AppColors.accentWhite,
                              strokeWidth: 3,
                            ),
                          )
                        : Icon(Icons.send, color: AppColors.accentWhite),
                    SizedBox(width: 8.w),
                    Text(
                      isSaving ? 'Enviando...' : 'Criar Ordem de Serviço',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.accentWhite,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.black),
      keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.metallicGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.lightGray,
        filled: true,
      ),
    );
  }

  Widget _buildQuantityField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: AppColors.black),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.lightGray,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      style: TextStyle(color: AppColors.black, fontSize: 16.sp),
      dropdownColor: AppColors.accentWhite,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.metallicGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.lightGray,
        filled: true,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(color: AppColors.black)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: TextStyle(color: AppColors.black),
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.metallicGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.lightGray,
        filled: true,
        suffixIcon: Icon(Icons.calendar_today, color: AppColors.black),
      ),
    );
  }

  // NOVO: Método para construir uma linha de Chips
  Widget _buildChipRow(
    String label,
    List<String> options,
    String? selectedValue,
    ValueChanged<String?> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = option == selectedValue;
              return Padding(
                padding: EdgeInsets.only(right: 7.w),
                child: FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    onSelected(selected ? option : null);
                  },
                  selectedColor: AppColors.primaryGreen,
                  checkmarkColor: AppColors.accentWhite,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.accentWhite : AppColors.black,
                    fontSize: 13.sp,
                  ),
                  backgroundColor: AppColors.lightGray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.metallicGray,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
