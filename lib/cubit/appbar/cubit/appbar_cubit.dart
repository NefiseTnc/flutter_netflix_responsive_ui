import 'package:flutter_bloc/flutter_bloc.dart';

class AppbarCubit extends Cubit<double> {
  AppbarCubit() : super(0);

  void setOffset(double offset) => emit(offset);
}
