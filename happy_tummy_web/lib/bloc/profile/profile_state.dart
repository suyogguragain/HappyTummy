import 'package:meta/meta.dart';

@immutable
class ProfileState {
 // final bool isPhotoEmpty;
  final bool isNameEmpty;
  final bool isAgeEmpty;
  final bool isCusinesEmpty;
  final bool isMealTypeEmpty;
  final bool isOutletTypeEmpty;
  final bool isParkingEmpty;
  final bool isPaymentMethodEmpty;
  final bool isBillingExtraEmpty;
  final bool isLocationEmpty;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;

  bool get isFormValid =>
      //isPhotoEmpty &&
      isNameEmpty &&
      isCusinesEmpty &&
      isMealTypeEmpty &&
      isOutletTypeEmpty &&
      isParkingEmpty &&
      isPaymentMethodEmpty &&
      isBillingExtraEmpty &&
      isLocationEmpty &&
      isAgeEmpty;

  ProfileState({
    @required this.isCusinesEmpty,
    @required this.isMealTypeEmpty,
    @required this.isOutletTypeEmpty,
    @required this.isParkingEmpty,
    @required this.isPaymentMethodEmpty,
    @required this.isBillingExtraEmpty,
    //@required this.isPhotoEmpty,
    @required this.isNameEmpty,
    @required this.isAgeEmpty,
    @required this.isLocationEmpty,
    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  factory ProfileState.empty() {
    return ProfileState(
     // isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isLocationEmpty: false,
      isBillingExtraEmpty: false,
      isMealTypeEmpty: false,
      isCusinesEmpty: false,
      isParkingEmpty: false,
      isPaymentMethodEmpty: false,
      isOutletTypeEmpty: false,
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
     // isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: true,
      isNameEmpty: false,
      isAgeEmpty: false,
      isLocationEmpty: false,
      isBillingExtraEmpty: false,
      isMealTypeEmpty: false,
      isCusinesEmpty: false,
      isParkingEmpty: false,
      isPaymentMethodEmpty: false,
      isOutletTypeEmpty: false,
    );
  }

  factory ProfileState.failure() {
    return ProfileState(
      //isPhotoEmpty: false,
      isFailure: true,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isBillingExtraEmpty: false,
      isMealTypeEmpty: false,
      isCusinesEmpty: false,
      isParkingEmpty: false,
      isPaymentMethodEmpty: false,
      isOutletTypeEmpty: false,
      isLocationEmpty: false,
    );
  }

  factory ProfileState.success() {
    return ProfileState(
      //isPhotoEmpty: false,
      isFailure: false,
      isSuccess: true,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isBillingExtraEmpty: false,
      isMealTypeEmpty: false,
      isCusinesEmpty: false,
      isParkingEmpty: false,
      isPaymentMethodEmpty: false,
      isOutletTypeEmpty: false,
      isLocationEmpty: false,
    );
  }

  ProfileState update({
    //bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isLocationEmpty,
    bool isCusinesEmpty,
    bool isMealTypeEmpty,
    bool isOutletTypeEmpty,
    bool isParkingEmpty,
    bool isPaymentMethodEmpty,
    bool isBillingExtraEmpty,
  }) {
    return copyWith(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
     // isPhotoEmpty: isPhotoEmpty,
      isNameEmpty: isNameEmpty,
      isAgeEmpty: isAgeEmpty,
      isLocationEmpty: isLocationEmpty,
      isBillingExtraEmpty: isBillingExtraEmpty,
      isMealTypeEmpty: isMealTypeEmpty,
      isCusinesEmpty: isCusinesEmpty,
      isParkingEmpty: isParkingEmpty,
      isPaymentMethodEmpty: isPaymentMethodEmpty,
      isOutletTypeEmpty: isOutletTypeEmpty,
    );
  }

  ProfileState copyWith({
    //bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isLocationEmpty,
    bool isCusinesEmpty,
    bool isMealTypeEmpty,
    bool isOutletTypeEmpty,
    bool isParkingEmpty,
    bool isPaymentMethodEmpty,
    bool isBillingExtraEmpty,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ProfileState(
      //isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      isCusinesEmpty: isCusinesEmpty ?? this.isCusinesEmpty,
      isMealTypeEmpty: isMealTypeEmpty ?? this.isMealTypeEmpty,
      isOutletTypeEmpty: isOutletTypeEmpty ?? this.isOutletTypeEmpty,
      isParkingEmpty: isParkingEmpty ?? this.isParkingEmpty,
      isPaymentMethodEmpty: isPaymentMethodEmpty ?? this.isPaymentMethodEmpty,
      isBillingExtraEmpty: isBillingExtraEmpty ?? this.isBillingExtraEmpty,
      isAgeEmpty: isAgeEmpty ?? this.isAgeEmpty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
