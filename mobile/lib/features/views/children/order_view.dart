import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Imports de Providers e Modelos
import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/order_service_view_model.dart';

// O widget principal agora estende ConsumerStatefulWidget
class NewOrderView extends ConsumerStatefulWidget {
  const NewOrderView({super.key});

  @override
  ConsumerState<NewOrderView> createState() => _NewOrderViewState();
}

class _NewOrderViewState extends ConsumerState<NewOrderView> {
  // Controllers
  final TextEditingController obsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  ); // NOVO

  // Estado do formulário
  String? _selectedTipoServico;
  String? _selectedSetor;
  String? _selectedSolicitanteName;
  String? _selectedEquipamentoName;
  String? _selectedRecorrencia;
  String? _selectedStatus; // NOVO
  DateTime? _selectedDate;

  // Mensagem de erro local do formulário
  String? _formErrorMessage;

  // --- Listas de opções fixas (Baseadas na UI Web) ---
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
    // NOVO: De acordo com o ManutencaoModal
    'Aberta',
    'Em andamento',
    'Concluída',
    'Atrasada',
  ];

  @override
  void initState() {
    super.initState();
    // Define o status padrão e a data atual ao iniciar o formulário
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

  // --- Função para selecionar a data ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.black,
              surface: AppColors.black,
              onSurface: AppColors.lightGray,
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

  // --- Função de criação da Ordem de Serviço ---
  Future<void> _handleCreateOrder(
    List<UserModel> users,
    List<StockModel> parts,
  ) async {
    setState(() => _formErrorMessage = null);

    final currentUser = ref.read(sessionProvider);

    // 1. Obter Solicitante ID (requerido)
    final UserModel solicitante = users.firstWhere(
      (u) => u.nome == _selectedSolicitanteName,
      orElse: () => currentUser as UserModel,
    );
    final solicitanteId = solicitante.id;

    // 2. Obter Equipamento ID e Quantidade (opcional)
    int? equipamentoId;
    int? quantidade;

    if (_selectedEquipamentoName != null) {
      final selectedPart = parts.firstWhere(
        (p) => p.peca == _selectedEquipamentoName,
        orElse: () =>
            StockModel(id: -1, peca: '', categoria: '', qtd: 0, qtdMin: 0),
      );

      equipamentoId = selectedPart.id;

      // Tenta fazer o parse da quantidade
      quantidade = int.tryParse(quantityController.text);

      // Validação de quantidade se um equipamento for selecionado
      if (equipamentoId != -1 && (quantidade == null || quantidade <= 0)) {
        setState(() {
          _formErrorMessage =
              'Selecione um equipamento e forneça uma quantidade válida maior que zero.';
        });
        return;
      }
      if (equipamentoId == -1) equipamentoId = null;
    }

    // 3. Validação Mínima de Campos OBRIGATÓRIOS
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

    // 4. Chamada à ViewModel
    await ref
        .read(orderServiceNotifierProvider.notifier)
        .createOrder(
          tipo: _selectedTipoServico!,
          setor: _selectedSetor!,
          detalhes: obsController.text.isEmpty
              ? 'Nenhum detalhe fornecido.'
              : obsController.text,
          status: _selectedStatus!, // NOVO
          solicitanteId: solicitanteId,
          recorrencia: _selectedRecorrencia!,
          data: _selectedDate!,
          equipamentoId: equipamentoId,
          quantidade: quantidade, // NOVO
        );
  }

  @override
  Widget build(BuildContext context) {
    // Observa os provedores para pegar os dados da API
    final usersAsyncValue = ref.watch(userListProvider);
    final partsAsyncValue = ref.watch(partListProvider);
    final createOrderState = ref.watch(orderServiceNotifierProvider);
    final isSaving = createOrderState.isLoading;

    // Lógica para lidar com o estado de criação da OS (sucesso, erro, loading)
    ref.listen(orderServiceNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (order) {
          if (order != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Ordem de Serviço ${order.id} criada com sucesso!',
                ),
              ),
            );
            context.pop(); // Volta para a tela anterior
          }
        },
        error: (e, st) {
          setState(() {
            _formErrorMessage = e.toString().contains('Exception:')
                ? e.toString().replaceAll('Exception: ', '')
                : 'Erro de conexão ou validação no servidor.';
          });
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.lightGray),
                  onPressed: () => context.pop(),
                ),
                Text(
                  'Voltar ao Início',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightGray,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // --- Dropdown de Solicitante ---
            usersAsyncValue.when(
              data: (users) {
                return _buildDropdown(
                  'Solicitante',
                  users.map((u) => u.nome).toList(),
                  _selectedSolicitanteName,
                  (val) {
                    setState(() {
                      _selectedSolicitanteName = val;
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text(
                'Erro ao carregar solicitantes: $e',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ),
            SizedBox(height: 12.h),

            // --- Dropdown de Tipo de Serviço ---
            _buildDropdown(
              'Tipo de Serviço',
              tiposServico,
              _selectedTipoServico,
              (val) => setState(() => _selectedTipoServico = val),
            ),
            SizedBox(height: 12.h),

            // --- Dropdown de Setor ---
            _buildDropdown(
              'Setor',
              setores,
              _selectedSetor,
              (val) => setState(() => _selectedSetor = val),
            ),
            SizedBox(height: 12.h),

            // --- Dropdown de Recorrência ---
            _buildDropdown(
              'Recorrência',
              recorrencias,
              _selectedRecorrencia,
              (val) => setState(() => _selectedRecorrencia = val),
            ),
            SizedBox(height: 12.h),

            // --- Dropdown de Status (NOVO) ---
            _buildDropdown(
              'Status',
              statusOptions,
              _selectedStatus,
              (val) => setState(() => _selectedStatus = val),
            ),
            SizedBox(height: 12.h),

            // --- Campo de Data ---
            _buildDateField('Data', dateController),
            SizedBox(height: 12.h),

            // --- Dropdown de Equipamento/Peça & Quantidade (NOVO LAYOUT) ---
            partsAsyncValue.when(
              data: (parts) {
                final partNames = parts
                    .where((p) => p.peca.isNotEmpty)
                    .map((p) => p.peca)
                    .toList();
                return Row(
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
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text(
                'Erro ao carregar peças: $e',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ),
            SizedBox(height: 12.h),

            // --- Campo de Observações ---
            _buildTextField('Detalhes/Observações', obsController, maxLines: 5),
            SizedBox(height: 24.h),

            // --- Mensagem de Erro do Formulário ---
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

            // --- Botão de Criação da OS ---
            ElevatedButton(
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
                            color: AppColors.black,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(Icons.send, color: AppColors.black),
                  SizedBox(width: 8.w),
                  Text(
                    isSaving ? 'Enviando...' : 'Criar Ordem de Serviço',
                    style: TextStyle(fontSize: 16.sp, color: AppColors.black),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Funções Auxiliares de Widgets ---

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.lightGray),
      keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.lightGray),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.accentWhite.withOpacity(0.1),
        filled: true,
      ),
    );
  }

  Widget _buildQuantityField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: AppColors.lightGray),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.lightGray),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.accentWhite.withOpacity(0.1),
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
      style: TextStyle(color: AppColors.lightGray, fontSize: 16.sp),
      dropdownColor: AppColors.black.withOpacity(0.9),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.lightGray),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.accentWhite.withOpacity(0.1),
        filled: true,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(color: AppColors.lightGray)),
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
      style: TextStyle(color: AppColors.lightGray),
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.lightGray),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        fillColor: AppColors.accentWhite.withOpacity(0.1),
        filled: true,
        suffixIcon: Icon(Icons.calendar_today, color: AppColors.lightGray),
      ),
    );
  }
}
