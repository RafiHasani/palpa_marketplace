import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/createproduct/create_product_page_one.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/createproduct/create_product_page_three.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/createproduct/create_product_page_two.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/general_apis_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/stepper_appbar_widget.dart';

class ProducerAddProductPage extends ConsumerStatefulWidget {
  static const String path = '/produceraddproductpage';
  const ProducerAddProductPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerAddProductPage();
}

class _ProducerAddProductPage extends ConsumerState<ProducerAddProductPage>
    with AutomaticKeepAliveClientMixin {
  final pageController = PageController(initialPage: 0);
  final pageOneFormKey = GlobalKey<FormState>();
  final pageTwoFormKey = GlobalKey<FormState>();

  final QuillController specsControllerfa = QuillController.basic();
  final QuillController specsControllerps = QuillController.basic();
  final QuillController specsControlleren = QuillController.basic();

  final QuillController introControllerfa = QuillController.basic();
  final QuillController introControllerps = QuillController.basic();
  final QuillController introControlleren = QuillController.basic();

  final TextEditingController productNamefa = TextEditingController();
  final TextEditingController productNameps = TextEditingController();
  final TextEditingController productNameen = TextEditingController();

  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productInStock = TextEditingController();
  final TextEditingController productDiscount = TextEditingController();

  void showSnack({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final createProState = ref.watch(createProductProvider);

    final producerProductState = ref.watch(producerProductProvider);
    final generalApi = ref.watch(generalApisProvider);

    ref.listen((producerProductProvider), (prev, next) {
      if (next.producerApiStatus == .creatingMyProductSuccess) {
        ref.read(createProductProvider.notifier).reset();
        context.pop();
      }
      if (next.producerApiStatus == .creatingMyProductFailed) {
        showSnack(msg: next.errorMessage?.error);
      }
    });

    return LoadingWidget(
      isLoading:
          (producerProductState.producerApiStatus == .gettingMyProductDetails ||
              producerProductState.producerApiStatus == .creatingMyProduct) ||
          (generalApi.apiCallStatus == .loading),
      child: Scaffold(
        appBar: StepperAppbarWidget(
          stepClicked: (int value) {
            pageController.jumpToPage(value - 1);
          },
          onBackPressed: () {
            if (createProState.currentStep == 1) {
              ref.read(createProductProvider.notifier).reset();
              context.pop();
            } else if (createProState.currentStep > 1) {
              int step = createProState.currentStep;
              int newStep = step - 1;
              ref.read(createProductProvider.notifier).setCurrentStep(newStep);
              pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            }
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: .symmetric(horizontal: 16.w),
            child: PageView(
              key: const PageStorageKey<String>('myScrollPositionKey'),
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                CreateProductPageOne(
                  pageOneFormKey: pageOneFormKey,
                  specsControllerfa: specsControllerfa,
                  specsControllerps: specsControllerps,
                  specsControlleren: specsControlleren,
                  introControllerfa: introControllerfa,
                  introControllerps: introControllerps,
                  introControllerEn: introControlleren,
                  productNamefa: productNamefa,
                  productNameps: productNameps,
                  productNameen: productNameen,
                ),
                CreateProductPageTwo(
                  formKey: pageTwoFormKey,
                  priceController: productPrice,
                  inStockController: productInStock,
                  discountController: productDiscount,
                ),
                CreateProductPageThree(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Column(
            mainAxisSize: .min,
            children: [
              Padding(
                padding: .symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: .maxFinite,
                  child: CustomElevatedButton(
                    title: (createProState.currentStep == 3)
                        ? context.local.publish
                        : context.local.continue_next,
                    onPressed: () {
                      if (mounted && createProState.currentStep == 3) {
                        submit();
                      } else {
                        if (createProState.currentStep == 1) {
                          submitPageOne();
                        } else if (createProState.currentStep == 2) {
                          submitPageTwo();
                        }
                      }
                    },
                  ),
                ),
              ),

              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();

    specsControllerfa.dispose();
    specsControllerps.dispose();
    specsControlleren.dispose();

    introControllerfa.dispose();
    introControllerps.dispose();
    introControlleren.dispose();

    productNamefa.dispose();
    productNameps.dispose();
    productNameen.dispose();

    productInStock.dispose();
    productPrice.dispose();
    productDiscount.dispose();

    super.dispose();
  }

  void submitPageOne() {
    if (!(pageOneFormKey.currentState?.validate() ?? false)) {
      return;
    }

    pageOneFormKey.currentState?.save();

    final jsonDescfa = specsControllerfa.document.toDelta().toJson();
    final String decsJsonfa = jsonEncode(jsonDescfa);

    final jsonDescps = specsControllerps.document.toDelta().toJson();
    final String decsJsonps = jsonEncode(jsonDescps);

    final jsonDescen = specsControlleren.document.toDelta().toJson();
    final String decsJsonen = jsonEncode(jsonDescen);

    final jsonAboutfa = introControllerfa.document.toDelta().toJson();
    final String aboutJsonfa = jsonEncode(jsonAboutfa);

    final jsonAboutps = introControllerps.document.toDelta().toJson();
    final String aboutJsonps = jsonEncode(jsonAboutps);

    final jsonAbouten = introControlleren.document.toDelta().toJson();
    final String aboutJsonen = jsonEncode(jsonAbouten);

    final createProductNotifier = ref.read(createProductProvider.notifier);

    createProductNotifier.setAboutfa(aboutJsonfa);
    createProductNotifier.setAboutps(aboutJsonps);
    createProductNotifier.setAbouten(aboutJsonen);

    createProductNotifier.setDescriptionfa(decsJsonfa);
    createProductNotifier.setDescriptionps(decsJsonps);
    createProductNotifier.setDescriptionen(decsJsonen);

    createProductNotifier.setCurrentStep(2);

    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void submitPageTwo() {
    final isValid = pageTwoFormKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    pageTwoFormKey.currentState?.save();

    final createProductState = ref.watch(createProductProvider);
    if ((createProductState.images ?? []).isEmpty) {
      context.showMySnackBar(content: context.local.product_image_required);
      return;
    }

    final createProductNotifier = ref.read(createProductProvider.notifier);

    createProductNotifier.setCurrentStep(3);

    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  Future<void> submit() async {
    final state = ref.read(createProductProvider);

    final productProvider = ref.read(producerProductProvider.notifier);

    await productProvider.createProduct(state);
  }

  @override
  bool get wantKeepAlive => true;
}
