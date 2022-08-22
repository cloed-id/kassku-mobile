part of 'form_values_cubit.dart';

class FormValuesState extends Equatable {
  const FormValuesState(this.email, this.password);

  factory FormValuesState.initial() => const FormValuesState(
        kDebugMode ? 'test1' : '',
        kDebugMode ? '12345678' : '',
      );

  final String email;
  final String password;

  FormValuesState copyWith({
    String? email,
    String? password,
  }) =>
      FormValuesState(
        email ?? this.email,
        password ?? this.password,
      );

  @override
  List<Object?> get props => [email, password];
}
