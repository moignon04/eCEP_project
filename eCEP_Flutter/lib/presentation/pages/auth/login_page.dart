import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/domain/entities/user.dart';
import 'package:client/presentation/pages/auth/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:client/presentation/controllers/auth/auth_controller.dart';
import 'package:client/presentation/widgets/toast.dart';

import '../../../app/extension/color.dart';
import '../../../app/services/local_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find<AuthController>();
  final ToastService toastService = Get.find<ToastService>();
  final LocalStorageService store = Get.find<LocalStorageService>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController contactController;
  late ScrollController scrollController;
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool isUsingEmail = true;
  String selectedCountryCode = "+226";

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    contactController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    contactController.dispose();
    scrollController.dispose();
    super.dispose();
  }


  // Fonction pour se connecter en tant qu'enseignant de test
  void _loginAsTestTeacher() {
    try {
      // Créer un utilisateur enseignant fictif
      final testTeacher = User.fromJson({
        'id': 999,
        'firstName': 'Adama',
        'lastName': 'BARRO',
        'email': 'adama.barro@ecep.bf',
        'avatar': 'assets/avatars/teacher1.png',
        'role': 'teacher'
      });

      store.token = 'fake-token-for-testing';
      store.user = testTeacher;

      // Afficher un message de succès
      toastService.showToast(
          title: 'Connexion réussie',
          message: 'Vous êtes connecté en tant que M. BARRO (enseignant test)',
          type: ToastType.success
      );

      // Naviguer vers la page du tableau de bord enseignant
      Get.toNamed('/dashboard');
    } catch (e) {
      print('Erreur lors de la connexion test: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Heureux de vous", style: TextStyle(color: AppColors.textDark, fontSize: 40, fontWeight: FontWeight.bold)),
                  Text("revoir", style: TextStyle(color: AppColors.textDark, fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Connectez pour continuer", style: TextStyle(color: AppColors.textDark, fontSize: 20)),
                  SizedBox(height: 20),

                  // Champ Contact ou Email
                  if (!isUsingEmail)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // Picker des indicatifs pays
                          CountryCodePicker(
                            onChanged: (countryCode) {
                              setState(() {
                                selectedCountryCode = countryCode.dialCode!;
                              });
                            },
                            initialSelection: "BF",
                            favorite: ['BF', 'CI', 'ML', 'SN'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: contactController,
                              decoration: InputDecoration(
                                hintText: "Numéro de téléphone",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: true,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer un numéro de contact valide";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          fillColor: Colors.transparent,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer une adresse email";
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return "Veuillez entrer une adresse email valide";
                          }
                          return null;
                        },
                      ),
                    ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isUsingEmail = !isUsingEmail;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(isUsingEmail ? "Utiliser un numéro de contact" : "Utiliser un email", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                      )
                  ),
                  SizedBox(height: 20),

                  // Champ Mot de passe
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: "Mot de passe",
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
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer un mot de passe";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 15),

                  // Mot de passe oublié et Test M. BARRO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton Test M. BARRO - Mis en évidence avec Animation
                      InkWell(
                        onTap: _loginAsTestTeacher,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColors.secondary),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.school, size: 18, color: AppColors.secondary),
                              SizedBox(width: 6),
                              Text(
                                "Test M. BARRO",
                                style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Mot de passe oublié
                      GestureDetector(
                        onTap: (){
                          Get.to(() => ForgotPasswordPage());
                        },
                        child: Text(
                            "Mot de passe oublié?",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),

                  // Bouton Connexion
                  Obx(() => GestureDetector(
                    onTap: authController.isLoading.value
                        ? null
                        : () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          bool success = false;
                          if (isUsingEmail) {
                            // Connexion avec email
                            success = await authController.login(
                                emailController.text.trim(),
                                passwordController.text.trim()
                            );
                          } else {
                            // La méthode de connexion par téléphone n'est pas directement prise en charge
                            // dans notre modèle actuel, mais on pourrait l'adapter
                            toastService.showToast(
                                title: 'Information',
                                message: 'La connexion par téléphone n\'est pas disponible pour le moment.',
                                type: ToastType.info
                            );
                          }

                          if (success) {
                            Get.offAllNamed('/home');
                          }
                        } on AppException catch (e) {
                          toastService.showToast(
                              title: 'Erreur',
                              message: e.message ?? 'Une erreur est survenue lors de la connexion.',
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
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: authController.isLoading.value
                            ? Colors.grey
                            : AppColors.primary,
                      ),
                      child: Center(
                        child: authController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Connexion",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: 20),

                  // S'inscrire
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Vous n'avez pas de compte?", style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/signUp");
                        },
                        child: Text(
                          "S'inscrire",
                          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}