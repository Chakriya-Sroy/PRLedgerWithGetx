class ApiEndPoints{
  static final String baseUrl="http://127.0.0.1:8000/api/";
  static  _AuthEndPoints authEndPoints = _AuthEndPoints();
  static _CustomerEndPoints customerEndPoints=_CustomerEndPoints();
  static _UserEndPoints userEndPoints=_UserEndPoints();
  static _SubscriptionEndPoints subscriptionEndPoints=_SubscriptionEndPoints();
  static _SupplierEndPoints supplierEndPoints=_SupplierEndPoints();
  static _ReceivableEndPoints receivableEndPoints=_ReceivableEndPoints();
  static _PayableEndPoints payableEndPoints=_PayableEndPoints();
  static _InvitationEndPoints invitationEndPoints=_InvitationEndPoints();

  Map<String, String> setHeader() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }
  Map<String, String> setHeaderToken(String token) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

}

class _AuthEndPoints{
  final String registerEmail='register';
  final String login='login';
  final String forgotPassword='forgot-password';
  //final String resetPassword;
}

class _UserEndPoints{
  final String userDetail='user';
  final String upcomingReceivable='user/receivables/upcoming';
  final String overDueReceivables='user/receivables/overdue';
  final String upcomingPayable='user/payables/upcoming';
  final String overDuePayable='user/payables/overdue';
  final String userList='user/list';
  final String invitationRequestReceived='user/show/invitation';
  final String invitationRequest='user/show/request';
  final String assignCustomerReceivableDetail='user/assign/receivables';
  final String assignUpCustomerReceivable='user/assign/upcoming/receivables';
  final String notifications='user/notifications';
}

class _CustomerEndPoints{
  final String customer='customer';
  final String customerAssignList='user/assign/customers';
  final String customerList='customer/list';
  final String customerCreate='customer/create';
  final String customerDelete='customer/delete/';
  final String customerUpdate='customer/update/';
  final String customerView='customer/view/';
  final String customerTransaction='customer/transaction/';
  final String customerAssignToCollector='collector/customer/assign';
  final String customerUnassignToCollector='collector/customer/unassign';
  final String customerThatAlreadyAssignToCollector='customer/get_assign_customer_to_collector';

  String getCustomerViewEndpoint(String id) {
    return '$customerView$id';
  }
  String getCustomerTransacctionEndPoint(String id){
    return '$customerTransaction$id';
  }
  String updateCustomerViewEndPoint(String id){
     return '$customerUpdate$id';
  }
  String deleteCustomerEndPoint(String id){
    return '$customerDelete$id';
  }
}

class _SubscriptionEndPoints{
  final String subscription='subscription';
  final String updateSubscription='subscription/update';
}
 

 class _SupplierEndPoints{
  final String supplier='supplier';
  final String supplierList='supplier/list';
  final String supplierCreate='supplier/create';
  final String supplierDelete='supplier/delete/';
  final String supplierUpdate='supplier/update/';
  final String supplierView='supplier/view/';
  final String supplierTransaction='supplier/transaction/';

  String getSupplierViewEndpoint(String id) {
    return '$supplierView$id';
  }
  String getSupplierTransacctionEndPoint(String id){
    return '$supplierTransaction$id';
  }
  String updateSupplierViewEndPoint(String id){
     return '$supplierUpdate$id';
  }
  String deleteCustomerEndPoint(String id){
    return '$supplierDelete$id';
  }
}
class _ReceivableEndPoints{
  final String receivableList='customer/receivable/list';
  final String receivableCreate='customer/receivable/create';
  final String receivableView='customer/receivable/view/';
  final String receivablePayment='customer/receivable/payment/create';

  String getReceivableViewEndPoint(String id){
    return '$receivableView$id';
  }
}
class _PayableEndPoints{
  final String payableList='supplier/payable/list';
  final String paybleCreate='supplier/payable/create';
  final String payableView='supplier/payable/view/';
  final String payablePayments='supplier/payable/payment/create';
  String getPayableViewEndPoint(String id){
    return '$payableView$id';
  }
}
class _InvitationEndPoints{
  final String sentInvitation='invitations';
  final String invitationResponse='invitations/respond';
  final String cancelInvitation='invitations/cancel';
  final String respondInvitaton='invitations/respond';
}