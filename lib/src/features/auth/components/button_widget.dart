import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tweet_app/src/features/auth/login/login_screen.dart';
class ButtonWidget extends StatelessWidget {
  ButtonWidget({Key? key, required text, required onPressed}) : super(key: key);
  late VoidCallback onPressed;
  late String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          height: size.height / 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              width: 1.0,
              color: const Color(0xFF21899C),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF21899C),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
Widget inputField({
  Size? size,
  required String labelText,
  required IconData icon,
  bool obscureText = false,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
  required String? Function(String?)? validator,
  required void Function(String) onChanged,
  required TextEditingController controller,

}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: SizedBox(
      height: size!.height,
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.inter(
          fontSize: 18.0,
          color: const Color(0xFF151624),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        cursorColor: const Color(0xFF151624),
        decoration: InputDecoration(

          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: labelText,
          labelStyle: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF090A2C).withOpacity(0.7),
          ),
          filled: true,
          fillColor: controller.text.isEmpty
              ? const Color.fromRGBO(248, 247, 251, 1)
              : Colors.transparent,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:   BorderSide(
              color: controller.text.isEmpty
                  ? const Color.fromRGBO(96, 96, 96, 0.4745098039215686)
                  : const Color.fromRGBO(44, 185, 176, 1),
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const  BorderSide(
              color:  Color.fromRGBO(44, 185, 176, 1),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:   BorderSide(
              color: controller.text.isEmpty
                  ? const Color.fromRGBO(96, 96, 96, 0.5294117647058826)
                  : const Color.fromRGBO(44, 185, 176, 1),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const  BorderSide(
              color:  Color.fromRGBO(244, 67, 54, 0.7),
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),

            borderSide: const  BorderSide(
              color:  Color.fromRGBO(244, 67, 54, 0.4),
              width: 2,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const  BorderSide(
              color:  Color.fromRGBO(44, 185, 176, 1),
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            icon,
            color: controller.text.isEmpty
                ? const Color(0xFF151624).withOpacity(0.45)
                : const Color.fromRGBO(44, 185, 176, 1),
            size: 20,
          ),
          suffix: Container(
            alignment: Alignment.center,
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: const Color.fromRGBO(44, 185, 176, 1),
            ),
            child: controller.text.isEmpty
                ? const Center()
                : const Icon(
              Icons.check,
              color: Colors.white,
              size: 13,
            ),
          ),
        ),

        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
      ),
    ),
  );
}
/*class inputField1 extends LoginScreen {
  Widget inputField({
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
    required void Function(String) onChanged,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 9.5,
        child: TextFormField(
          controller: controller,
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(

            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: labelText,
            labelStyle: GoogleFonts.inter(
              fontSize: 18.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: controller.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide:   BorderSide(
                color: controller.text.isEmpty
                    ? const Color.fromRGBO(96, 96, 96, 0.4745098039215686)
                    : const Color.fromRGBO(44, 185, 176, 1),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide:   BorderSide(
                color: controller.text.isEmpty
                    ? const Color.fromRGBO(96, 96, 96, 0.35294117647058826)
                    : const Color.fromRGBO(44, 185, 176, 1),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const  BorderSide(
                color:  Color.fromRGBO(244, 67, 54, 0.7),
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),

              borderSide: const  BorderSide(
                color:  Color.fromRGBO(244, 67, 54, 0.4),
                width: 2,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const  BorderSide(
                color:  Color.fromRGBO(44, 185, 176, 1),
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: controller.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.45)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 20,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: controller.text.isEmpty
                  ? const Center()
                  : const Icon(
                Icons.check,
                color: Colors.white,
                size: 13,
              ),
            ),
          ),

          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}*/