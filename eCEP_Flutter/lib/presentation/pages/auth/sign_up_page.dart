import 'package:client/app/extension/color.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/presentation/controllers/auth/auth_controller.dart';
import 'package:client/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String selectedRole = 'student';
  CountryCode selectedCountryCode = CountryCode.fromCountryCode('BF');
  final AuthController authController = Get.find<AuthController>();
  final ToastService toastService = Get.find<ToastService>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool _obscureText = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Titre
                  Text(
                    "Créer un compte",
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Champ Prénom
                  _buildTextField("Prénom", firstNameController, TextInputType.text),
                  SizedBox(height: 20),

                  // Champ Nom de famille
                  _buildTextField("Nom de famille", lastNameController, TextInputType.text),
                  SizedBox(height: 20),

                  // Champ Téléphone
                  _buildPhoneField(),
                  SizedBox(height: 20),

                  // Champ Email
                  _buildTextField("Email", emailController, TextInputType.emailAddress),
                  SizedBox(height: 20),

                  // Champ Mot de passe
                  _buildPasswordField("Mot de passe", passwordController),
                  SizedBox(height: 20),

                  // Champ Confirmer le mot de passe
                  _buildPasswordField("Confirmer le mot de passe", confirmPasswordController),
                  SizedBox(height: 30),

                  // Bouton S'inscrire
                  Obx(() => GestureDetector(
                    onTap: authController.isLoading.value
                        ? null
                        : () async {
                      if (formKey.currentState!.validate()) {
                        if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
                          toastService.showToast(
                            title: 'Erreur',
                            message: 'Les mots de passe ne correspondent pas.',
                            type: ToastType.error,
                          );
                        } else {
                          try {
                            final success = await authController.signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                role: selectedRole // Utiliser le rôle sélectionné
                            );

                            if (success) {
                              Get.offAllNamed('/home');
                            }
                          } on AppException catch (e) {
                            toastService.showToast(
                                title: 'Erreur',
                                message: e.message ?? 'Une erreur est survenue lors de l\'inscription.',
                                type: ToastType.error
                            );
                          } catch (e) {
                            toastService.showToast(
                                title: 'Erreur',
                                message: 'Une erreur inattendue est survenue. Veuillez réessayer.',
                                type: ToastType.error
                            );
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: authController.isLoading.value ? Colors.grey : AppColors.primary,
                      ),
                      child: Center(
                        child: authController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "S'inscrire",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Vous avez déjà un compte?",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/login");
                        },
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedRole,
                        items: [
                          DropdownMenuItem(value: 'student', child: Text('Élève')),
                          DropdownMenuItem(value: 'teacher', child: Text('Enseignant')),
                          DropdownMenuItem(value: 'parent', child: Text('Parent')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

        ),
      ),

    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, TextInputType inputType) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black26),
            border: InputBorder.none,
            prefixIcon: Icon(
              hintText.contains("Email") ? Icons.email :
              hintText.contains("Prénom") || hintText.contains("Nom") ? Icons.person :
              Icons.text_fields,
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20)
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez entrer votre $hintText";
          }
          if (hintText.contains("Email") && !GetUtils.isEmail(value)) {
            return "Veuillez entrer un email valide";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Liste déroulante pour sélectionner le pays
          CountryCodePicker(
            onChanged: (country) {
              setState(() {
                selectedCountryCode = country;
              });
            },
            initialSelection: selectedCountryCode.code,
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            showFlag: true,
            alignLeft: false,
            favorite: ['BF', 'CI', 'ML', 'SN'],
          ),
          Expanded(
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Numéro de téléphone",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez entrer votre numéro de téléphone.";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black26),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.lock, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20)
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez entrer un $hintText";
          }
          if (value.length < 6) {
            return "Le mot de passe doit contenir au moins 6 caractères";
          }
          return null;
        },
      ),
    );
  }
}