// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/gen/assets.gen.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/modules/login/bloc/login_bloc.dart';
import 'package:kassku_mobile/modules/login/cubit/form_key_cubit.dart';
import 'package:kassku_mobile/modules/login/cubit/form_values_cubit.dart';
import 'package:kassku_mobile/modules/login/cubit/visibility_password_cubit.dart';
import 'package:kassku_mobile/modules/login/view/register_screen.dart';
import 'package:kassku_mobile/utils/extensions/widget_extension.dart';
import 'package:kassku_mobile/utils/screen_size.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                alignment: ScreenSize.isBelowExtraLargeScreen(context)
                    ? Alignment.center
                    : Alignment.topLeft,
                child: Assets.images.bannerKassku.image(width: 180),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: ScreenSize.isBelowExtraLargeScreen(context)
                      ? double.infinity
                      : MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                  ),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => VisibilityPasswordCubit(),
                      ),
                      BlocProvider(
                        create: (context) => FormKeyCubit(),
                      ),
                      BlocProvider(
                        create: (context) => LoginBloc(),
                      ),
                      BlocProvider(
                        create: (context) => FormValuesCubit(),
                      ),
                    ],
                    child: const _FormBodyWidget(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: ColorName.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          height: 48,
          child: Text(
            '© 2020-${DateTime.now().year}. Cloed Indonesia. All rights reserved',
            style: const TextStyle(color: ColorName.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _FormBodyWidget extends StatelessWidget {
  const _FormBodyWidget();

  void _submit(BuildContext context) {
    final formKey = context.read<FormKeyCubit>().state;

    if (!formKey.currentState!.validate()) return;

    final values = context.read<FormValuesCubit>().state;

    context.read<LoginBloc>().add(
          LoginSubmitEvent(
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
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Login Kassku',
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
                    initialValue:
                        context.read<FormValuesCubit>().state.password,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Password tidak boleh kosong';
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      child: const Text('Daftar'),
                      onPressed: () {
                        const RegisterScreen().showSheet<void>(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is LoginLoading) {
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
                            child: Center(child: Text('Login')),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
