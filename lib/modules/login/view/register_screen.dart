import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/modules/login/bloc/register_bloc.dart';
import 'package:kassku_mobile/modules/login/cubit/form_key_cubit.dart';
import 'package:kassku_mobile/modules/login/cubit/form_values_cubit.dart';
import 'package:kassku_mobile/modules/login/cubit/visibility_password_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RegisterBloc(),
          ),
          BlocProvider(
            create: (context) => VisibilityPasswordCubit(),
          ),
          BlocProvider(
            create: (context) => FormKeyCubit(),
          ),
          BlocProvider(
            create: (context) => FormValuesCubit(),
          ),
        ],
        child: const _RegisterBody(),
      ),
    );
  }
}

class _RegisterBody extends StatelessWidget {
  const _RegisterBody({super.key});

  void _submit(BuildContext context) {
    final formKey = context.read<FormKeyCubit>().state;

    if (!formKey.currentState!.validate()) return;

    final values = context.read<FormValuesCubit>().state;

    context.read<RegisterBloc>().add(
          RegisterSubmitEvent(
            email: values.email,
            password: values.password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = context.watch<VisibilityPasswordCubit>().state;

    return Form(
      key: context.read<FormKeyCubit>().state,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Kassku',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'Solusi pencatatan dan pengelolaan kas',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  top: 8,
                ),
                child: const Text(
                  'Username ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              TextFormField(
                initialValue: context.read<FormValuesCubit>().state.email,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Masukan username anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
                onChanged: (email) {
                  context.read<FormValuesCubit>().setEmail(email);
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                initialValue: context.read<FormValuesCubit>().state.password,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  } else if (value!.length < 8) {
                    return 'Password harus lebih dari 8 karakter.';
                  }
                  return null;
                },
                obscureText: !isVisible,
                decoration: InputDecoration(
                  hintText: 'Masukkan password anda...',
                  //counterText: "Lupa Password?",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      context.read<VisibilityPasswordCubit>().toggle();
                    },
                    child: Icon(
                      !isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: !isVisible ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                onChanged: (password) {
                  context.read<FormValuesCubit>().setPassword(password);
                },
                onFieldSubmitted: (value) => _submit(context),
              ),
              const SizedBox(
                height: 26,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  if (state is RegisterLoading) {
                    return const SizedBox(
                      height: 55,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 10,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        primary: ColorName.primary,
                        onPrimary: ColorName.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Center(child: Text('Daftar')),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
