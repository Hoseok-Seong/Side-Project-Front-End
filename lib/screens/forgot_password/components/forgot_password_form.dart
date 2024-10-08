import 'package:flutter/material.dart';
import 'package:puppicasso/apis/password_reset_api.dart';
import 'package:puppicasso/models/user_reset_password_req.dart';
import 'package:puppicasso/screens/sign_in/sign_in_screen.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/no_account_text.dart';
import '../../../constants.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;

  final PasswordResetAPI passwordResetAPI = PasswordResetAPI();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "이메일을 입력해주세요",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 8),
          FormError(errors: errors),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                bool resetPasswordSuccess = false;

                resetPasswordSuccess = await passwordResetAPI.passwordReset(
                    UserResetPasswordReq(username: email!));
                if (resetPasswordSuccess) {
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("'비밀번호 찾기'가 실패하였습니다")),
                  );
                }
              }
            },
            child: const Text("비밀번호 찾기"),
          ),
          const SizedBox(height: 16),
          const NoAccountText(),
        ],
      ),
    );
  }
}
