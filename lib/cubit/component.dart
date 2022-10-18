import 'package:flutter_bloc/flutter_bloc.dart';

class Component extends Cubit<int> {
  Component() : super(0);
  void refresher() => emit(state + 1);
}
