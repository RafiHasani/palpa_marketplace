class Endpoints {
  static const String getCategories = '/v1/public/categories';
  static const String getCategoriesBySlug =
      '/v1/public/categories/'; //'/v1/public/categories/{slug}';
  static const String getCompaigns = '/v1/public/campaigns';
  static const String getProductDetailsBySlug =
      '/v1/public/products/'; //v1/public/products/{slug}

  static const String getProduct = '/v1/public/products/';
  static const String createProduct = '/v1/products';
  //'/v1/public/products/{product_slug}/reviews';
  //v1/public/products?sort=sales -> most sold
  //v1/public/products?sort=likes -> most liked

  static const String getOtp = '/auth/otp';
  static const String verifyCode = '/auth/verify';
  static const String updateProfile = '/v1/profile';

  static const String getAuthedUser = '/auth/me';
  // search products
  // /v1/public/products?filter[search]=fresh apple
  static const String searchProducts = '/v1/public/search';

  static const String logout = '/auth/logout';

  static const String addReview =
      '/v1/products/'; //'/v1/products/:product_slug/reviews';
  static const String likeDislikeProduct =
      '/v1/products/'; //'/v1/products/:product_slug/likes';
  static const String favorites = '/v1/likes';

  static const String orders =
      '/v1/orders'; // Get  || 'v1/orders?filter[from]=others' || v1/orders?filter[from]=mine
  static const String placeOrUpdateOrder = '/v1/orders'; //Post

  static const String getMyProductReviews = '/v1/reviews';

  static const String getProvince = '/v1/provinces';
  static const String getUnits = '/v1/units';

  static const String register = '/auth/register';
  static const String loginWithUsernamePassword = '/auth/login';
  static const String getMyProduct = '/v1/products';
  static const String getProducerDashboard = '/v1/dashboard';
  static const String producerUpdateProduct = '/v1/products';
  static const String producerGetProductDetails =
      '/v1/products'; //v1/products/{any_product_slug}

  static const String getSiteSettings = '/v1/public/site-settings';

  static const String changePassword = '/v1/profile/password';
}
