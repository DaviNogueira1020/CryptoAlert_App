// alerts_service.dart
// Regras de negócio do domínio de alertas.

import '../models/alert_model.dart';
import '../repositories/alerts_repository.dart';
import '../repositories/alerts_dtos.dart';

class AlertsService {
  final AlertsRepository _repository;

  AlertsService(this._repository);

  // ─── Criar ─────────────────────────────────────────────────────────────────

  Future<AlertModel> criarAlerta(String userId, CreateAlertDTO dto) async {
    if (dto.symbol.trim().isEmpty) {
      throw ArgumentError('symbol não pode ser vazio');
    }

    if (dto.target <= 0) {
      throw ArgumentError('target deve ser maior que zero');
    }

    return _repository.create(dto, userId);
  }

  // ─── Listar ────────────────────────────────────────────────────────────────

  Future<PaginatedAlerts> listarAlertas(
    String userId, [
    ListAlertsOptions options = const ListAlertsOptions(),
  ]) async {
    return _repository.findByUser(userId, options);
  }

  // ─── Atualizar ─────────────────────────────────────────────────────────────

  Future<AlertModel> atualizarAlerta(
    String userId,
    String id,
    UpdateAlertDTO dto,
  ) async {
    final alert = await _repository.findById(id);
    if (alert == null || alert.userId != userId) {
      throw StateError('Alerta não encontrado ou não pertence ao usuário');
    }

    if (dto.target != null && dto.target! <= 0) {
      throw ArgumentError('target deve ser maior que zero');
    }

    return _repository.update(id, dto);
  }

  // ─── Deletar ───────────────────────────────────────────────────────────────

  Future<void> deletarAlerta(String userId, String id) async {
    final alert = await _repository.findById(id);
    if (alert == null || alert.userId != userId) {
      throw StateError('Alerta não encontrado ou não pertence ao usuário');
    }

    await _repository.delete(id);
  }
}
