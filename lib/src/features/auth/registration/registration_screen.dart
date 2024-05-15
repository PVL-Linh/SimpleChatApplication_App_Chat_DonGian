import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:tweet_app/src/features/auth/components/auth_button.dart';
import 'package:tweet_app/src/features/auth/components/auth_error_snackbar.dart';
import 'package:tweet_app/src/features/auth/components/auth_header.dart';
import 'package:validatorless/validatorless.dart';
import 'package:tweet_app/src/features/auth/registration/store/registration_store.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tweet_app/src/features/auth/components/button_widget.dart';
import '../../../core/utils/validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailCTL = TextEditingController();
  TextEditingController passCTL = TextEditingController();
  TextEditingController identiferCTL = TextEditingController();
  TextEditingController confirmpassCTL = TextEditingController();
  late final RegistrationStore registrationStore;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    registrationStore = Modular.get<RegistrationStore>();
    autorun((_) {
      if (registrationStore.screenState == RegistrationState.error) {
        showAuthErrorSnackBar(
            context: context, message: registrationStore.errorMessage!);
      }
    });
    when((_) => registrationStore.screenState == RegistrationState.success, () {
      registrationStore.setScreenState(newState: RegistrationState.idle);
      Modular.to.navigate('/auth/');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(

        backgroundColor: const Color(0xFF21899C),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                //bg design, we use 3 svg img
                Positioned(
                  left: -446,
                  bottom: 01.0,
                  child: SvgPicture.string(
                    '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 151.92,
                    height: 151.92,
                  ),
                ),
                Positioned(
                  left: -26,
                  top: 1.0,
                  child: SvgPicture.string(
                    '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 191.92,
                    height: 191.92,
                  ),
                ),
                Positioned(
                  left: 256,
                  bottom: 51.0,
                  child: SvgPicture.string(
                    '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 191.92,
                    height: 191.92,
                  ),
                ),
                Positioned(
                  left: 256,
                  bottom: 300.0,
                  child: SvgPicture.string(
                    '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 191.92,
                    height: 191.92,
                  ),
                ),
                Positioned(
                  right: 63.0,
                  bottom: -43,
                  child: SvgPicture.string(
                    '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 208.27,
                    height: 208.27,
                  ),
                ),
                Positioned(
                  right: 43.0,
                  top: -103,
                  child: SvgPicture.string(
                    '<svg viewBox="63.0 -103.0 268.27 268.27" ><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 63.0, 67.08)" d="M 147.2896423339844 0 L 196.3861999511719 98.19309997558594 L 147.2896423339844 196.3861999511719 L 49.09654235839844 196.3861999511719 L 0 98.19309234619141 L 49.09656143188477 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 113.73, 79.36)" d="M 0 0 L 83.46413421630859 33.38565444946289 L 166.9282684326172 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 184.38, 23.77)" d="M 0 111.9401321411133 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 268.27,
                    height: 268.27,
                  ),
                ),

                Positioned(
                  right: -19,
                  top: 31.0,
                  child: SvgPicture.string(
                    '<svg viewBox="329.0 31.0 65.0 65.0" ><path transform="translate(329.0, 31.0)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(333.88, 47.58)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(361.5, 58.63)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 65.0,
                    height: 65.0,
                  ),
                ),
                //card and footer ui
                Positioned(
                  bottom: 20.0,
                  child: Column(
                    children: <Widget>[
                      buildCard(size),
                      buildFooter(size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo & text
          SizedBox(
            height: size.height * 0.01,
          ),
          logo(size.height / 8, size.height / 8),
          SizedBox(
            height: size.height * 0.03,
          ),
          richText(24),
          SizedBox(
            height: size.height * 0.04,
          ),
          //email & password textField
          inputField(
            size: size/9.3,
            labelText: "Enail",
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            controller: emailCTL ,
            validator: Validatorless.multiple([

              Validatorless.required('The field is obrigatory.'),
              Validatorless.email('The field requires an email address'),
            ]),
            onChanged: (value) {
              registrationStore.changeModel(registrationStore
                  .registrationModel
                  .copyWith(email: value));
            },
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          // Email field
          inputField(
            size: size/9.3,
            controller: identiferCTL,
            labelText: "Tên người dùng",
            icon: Icons.person_outline_sharp,

            // cái này để ẩn mk
            validator: Validatorless.multiple([
              Validatorless.required('The field is obrigatory.'),
            ]),
            onChanged: (value) {
              registrationStore.changeModel(registrationStore
                  .registrationModel
                  .copyWith(identifier: value));
            },
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          // Email field
          inputField(
            size: size/9.3,
            controller: passCTL,
            labelText: "mật khẩu",
            icon: Icons.lock_outline_sharp,

            // cái này để ẩn mk
            validator: Validatorless.multiple([
              Validatorless.required('The field is obrigatory.'),
              Validatorless.between(
                  6, 15, 'Minimum 6 and maximum 15 characters.'),
            ]),
            obscureText: true,
            onChanged: (value) {
              registrationStore.changeModel(registrationStore
                  .registrationModel
                  .copyWith(password: value));
            },
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          // Email field
          inputField(
            size: size/9.3,
            controller: confirmpassCTL,
            labelText: "Xác nhận mật khẩu",
            icon: Icons.verified_user_sharp,
            // cái này để ẩn mk
            validator: Validatorless.multiple([
              Validatorless.required('The field is obrigatory.'),
              Validators.compareString(
                  input: registrationStore.registrationModel.password,
                  message:
                  'This field needs to be the same as the Password field'),
            ]),
            obscureText: true,
            onChanged: (value) {
              registrationStore.changeModel(registrationStore
                  .registrationModel
                  .copyWith(confirmPassword: value));
            },
          ),

          //remember & forget text

          SizedBox(
            height: size.height * 0.02,
          ),

          //sign in button
          signUpButton(size),
        ],
      ),
    );
  }

  Widget buildFooter(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[


        SizedBox(
          height: size.height * 0.02,
        ),
        Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: 15.0,
              color: Colors.white,
            ),
            children: [
              const TextSpan(
                text: "Have an account?",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: ' Login',
                style: const TextStyle(
                  color: Color(0xFF26E80A), fontWeight: FontWeight.w700,),

                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Modular.to.navigate('./');
                  },
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      'assets/logo.svg',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'LINH',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'XEOM',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpButton(Size size) {
    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: AuthButton(
            labelButton: registrationStore.screenState ==
                RegistrationState.loading
                ? 'Loading'
                : 'Tạo tài khoản',
            onTap: () {
              if (registrationStore.screenState !=
                  RegistrationState.loading &&
                  registrationStore.screenState !=
                      RegistrationState.success) {
                if (_formKey.currentState!.validate()) {
                  registrationStore.registrationAction();
                }
              }
            }),
      ),
    );
  }




}
