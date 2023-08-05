class Api {
  static const _host = 'http://192.168.8.105/api_ecommerce';
  // static const _host = 'https://distroapp.epizy.com';
  // static const _host = 'http://sql204.epizy.com';
  static const _hostCart = '$_host/cart';
  static const _hostOrder = '$_host/order';
  static const _hostApparel = '$_host/apparel';
  static const _hostUser = '$_host/user';
  static const _hostWishlist = '$_host/wishlist';
  static const hostImage = '$_host/images/';


  //cart
  static const addCart = '$_hostCart/add.php';
  static const deleteCart = '$_hostCart/delete.php';
  static const getCart = '$_hostCart/get.php';
  static const updateCart = '$_hostCart/update.php';

  //order
  static const addOrder = '$_hostOrder/add.php';
  static const deleteOrder = '$_hostOrder/delete.php';
  static const getHistory = '$_hostOrder/get_history.php';
  static const getOrder = '$_hostOrder/get_order.php';
  static const setArrived = '$_hostOrder/set_arrived.php';

  //apparel
  static const searchApparel = '$_hostApparel/search.php';
  static const getAllApparel = '$_hostApparel/get_all.php';
  static const getPopularApparel = '$_hostApparel/get_popular.php';

  //user
  static const checkEmail = '$_hostUser/check_email.php';
  static const login = '$_hostUser/login.php';
  static const register = '$_hostUser/register.php';

  //wishlist
  static const addWishlist = '$_hostWishlist/add.php';
  static const checkWishlist = '$_hostWishlist/check.php';
  static const deleteWishlist = '$_hostWishlist/delete.php';
  static const getWishlist = '$_hostWishlist/get.php';
}
