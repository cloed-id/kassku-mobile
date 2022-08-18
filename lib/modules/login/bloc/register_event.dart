part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {}



class RegisterSubmitEvent extends RegisterEvent {
  RegisterSubmitEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
