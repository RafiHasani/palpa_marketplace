enum OrderStatus { pending, approve, cancel, reject, complet }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.approve:
        return 'Approved';
      case OrderStatus.cancel:
        return 'Cancelled';
      case OrderStatus.reject:
        return 'Rejected';
      case OrderStatus.complet:
        return 'Completed';
    }
  }
}

enum ImageState { added, deleted }

extension ImageStateX on ImageState {
  String get label {
    switch (this) {
      case ImageState.added:
        return 'added';
      case ImageState.deleted:
        return 'deleted';
    }
  }
}
