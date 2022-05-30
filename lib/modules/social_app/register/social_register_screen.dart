import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/layouts/social_layout/social_layout.dart';
import 'package:flutter_app/modules/social_app/login/cubit/cubit.dart';
import 'package:flutter_app/modules/social_app/login/cubit/states.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_app/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialRegisterErrorState)
            showToast(
              message: state.error,
              state: ToastStates.ERROR,
            );

          if (state is SocialCreateUserSuccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              uId = state.uId;
              navigateAndFinish(
                context,
                SocialLayout(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Register'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Register now to communicate with friends',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          label: 'Username',
                          prefix: Icons.person,
                          type: TextInputType.name,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please, enter your name';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please, enter your email address';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          label: 'Phone',
                          prefix: Icons.phone,
                          type: TextInputType.phone,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please, enter your phone';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          label: 'Password',
                          prefix: Icons.visibility_outlined,
                          type: TextInputType.visiblePassword,
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          suffix: SocialLoginCubit.get(context).suffix,
                          suffixPressed: () {
                            SocialLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'please, enter your password';
                            }
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState.validate()) {
                                SocialLoginCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
