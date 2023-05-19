import 'package:bloc/bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/favorite/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(const FavoriteState([]));

  onAddFavorite(VendorEntity vendorEntity) {
    final currentVendorEntities = List<VendorEntity>.from(state.vendorEntities);
    currentVendorEntities.add(vendorEntity);
    emit(state.copyWith(vendorEntities: currentVendorEntities));
  }

  onRemoveFavorite(VendorEntity vendorEntity) {
    final currentVendorEntities = List<VendorEntity>.from(state.vendorEntities);
    currentVendorEntities.remove(vendorEntity);
    emit(state.copyWith(vendorEntities: currentVendorEntities));
  }
}
