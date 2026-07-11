import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/data/models/producer_product_details_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/editproduct/edit_product_page_one.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/editproduct/edit_product_page_three.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/editproduct/edit_product_page_two.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/general_apis_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/stepper_appbar_widget.dart';

class ProducerEditProduct extends ConsumerStatefulWidget {
  static const String path = '/producereditproduct';
  const ProducerEditProduct({super.key, this.slug});

  final String? slug;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerEditProductState();
}

class _ProducerEditProductState extends ConsumerState<ProducerEditProduct>
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

  final TextEditingController categorySelected = TextEditingController();
  final TextEditingController subCategorySelected = TextEditingController();

  CategoryModel? selectedCategory;
  CategoryModel? selectedSubCategory;

  @override
  void initState() {
    Future.microtask(() async {
      await loadData();
    });

    super.initState();
  }

  Future<void> loadData() async {
    if (widget.slug != null) {
      Future.microtask(() {
        ref
            .read(producerProductProvider.notifier)
            .getProducerProducteDetails(slug: widget.slug ?? '');
      });
    }
  }

  void showSnack({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }

  void loadDetails(ProducerProductDetailsModel? productDetails) {
    final local = ref.read(appLangProvider);
    final createProNotifier = ref.read(createProductProvider.notifier);

    if (productDetails?.name != null) {
      productNamefa.text = productDetails?.name?.fa ?? '';
      productNameps.text = productDetails?.name?.ps ?? '';
      productNameen.text = productDetails?.name?.en ?? '';
    }

    if (productDetails?.category != null) {
      if (productDetails?.category?.parent != null) {
        final categoryPorivder = ref.watch(generalApisProvider);

        final productCategory = productDetails!.category!.parent;

        final selectedCategory = categoryPorivder.categories?.data?.firstWhere(
          (item) => item.slug == productCategory?.slug,
        );

        createProNotifier.setCategorySlug(selectedCategory ?? productCategory);
      }

      createProNotifier.setSubCategorySlug(productDetails!.category);

      categorySelected.text = productDetails.category?.parent?.name ?? '';
      subCategorySelected.text = productDetails.category?.name ?? '';
    }

    productPrice.text = (productDetails?.price ?? '0').toNumber().toLocalNumber(
      local,
    );

    productInStock.text = (productDetails?.stock?.toLocalNumber(local) ?? 0)
        .toString();
    if (productDetails?.hasDiscount ?? false) {
      productDiscount.text = (productDetails?.discountedPrice ?? '0')
          .toNumber()
          .toLocalNumber(local);
    }

    if (productDetails?.unit != null) {
      createProNotifier.setUnitSymbol(productDetails!.unit!);
    }
    if (productDetails?.province != null) {
      createProNotifier.setProvinceSlug(productDetails!.province!);
    }

    if (productDetails?.images != null) {
      createProNotifier.setImages(productDetails?.images ?? []);
    }

    createProNotifier.setActive(productDetails?.isActive ?? false);

    if (productDetails?.about != null) {
      final aboutDocfa = Document.fromJson(
        productDetails?.about?.fa?.ops ?? [],
      );
      specsControllerfa.document = aboutDocfa;

      final aboutDocps = Document.fromJson(
        productDetails?.about?.ps?.ops ?? [],
      );
      specsControllerps.document = aboutDocps;

      final aboutDocen = Document.fromJson(
        productDetails?.about?.en?.ops ?? [],
      );
      specsControlleren.document = aboutDocen;
    }

    if (productDetails?.description != null) {
      final descDoc = Document.fromJson(
        productDetails?.description?.fa?.ops ?? [],
      );
      introControllerfa.document = descDoc;

      final descDocps = Document.fromJson(
        productDetails?.description?.ps?.ops ?? [],
      );
      introControllerps.document = descDocps;

      final descDocen = Document.fromJson(
        productDetails?.description?.en?.ops ?? [],
      );
      introControlleren.document = descDocen;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final createProState = ref.watch(createProductProvider);

    final producerProductState = ref.watch(producerProductProvider);
    ref.listen(producerProductProvider, (previous, next) {
      if (next.producerApiStatus == .gettingMyProductDetailsSuccess) {
        loadDetails(next.producerProductDetailsModel);
      }
    });

    ref.listen((producerProductProvider), (prev, next) {
      if (next.producerApiStatus == .updatingMyProductSuccess) {
        navigateToProducerDashboard();
      }
      if (next.producerApiStatus == .updatingMyProductFailed) {
        showSnack(msg: next.errorMessage?.error);
      }
    });

    return LoadingWidget(
      isLoading:
          (producerProductState.producerApiStatus == .gettingMyProductDetails ||
          producerProductState.producerApiStatus == .updatingMyProduct),
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
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,

              children: [
                EditProductPageOne(
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
                  categoryController: categorySelected,
                  subCategoryController: subCategorySelected,
                ),
                EditProductPageTwo(
                  formKey: pageTwoFormKey,
                  priceController: productPrice,
                  inStockController: productInStock,
                  discountController: productDiscount,
                ),
                EditProductPageThree(),
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
                        ? context.local.save_changes
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

    await productProvider.updateProduct(state, widget.slug ?? '');
  }

  void navigateToProducerDashboard() {
    ref.read(createProductProvider.notifier).reset();
    context.pop();
  }

  @override
  bool get wantKeepAlive => true;
}
