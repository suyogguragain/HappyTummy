import 'package:meta/meta.dart';

@immutable
class ProfileState {
  final bool isPhotoEmpty;
  final bool isNameEmpty;
  final bool isAgeEmpty;
  final bool isCusinesEmpty;
  final bool isMealTypeEmpty;
  final bool isOutletTypeEmpty;
  final bool isParkingEmpty;
  final bool isPaymentMethodEmpty;
  final bool isBillingExtraEmpty;
  final bool isLocationEmpty;

  final bool isPhoneEmpty;
  final bool isLongitudeEmpty;
  final bool isLatitudeEmpty;
  final bool isSunEmpty;
  final bool isMonEmpty;
  final bool isTueEmpty;
  final bool isThruEmpty;
  final bool isFriEmpty;
  final bool isSatEmpty;
  final bool isWedEmpty;

  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;

  bool get isFormValid =>
      isPhotoEmpty &&
      isNameEmpty &&
      isCusinesEmpty &&
      isMealTypeEmpty &&
      isOutletTypeEmpty &&
      isParkingEmpty &&
      isPaymentMethodEmpty &&
      isBillingExtraEmpty &&
      isLocationEmpty &&
      isPhoneEmpty &&
      isLongitudeEmpty &&
      isLatitudeEmpty &&
      isSunEmpty &&
      isMonEmpty &&
      isTueEmpty &&
      isThruEmpty &&
      isFriEmpty &&
      isSatEmpty &&
      isWedEmpty &&
      isAgeEmpty;

  ProfileState({
    @required this.isCusinesEmpty,
    @required this.isMealTypeEmpty,
    @required this.isOutletTypeEmpty,
    @required this.isParkingEmpty,
    @required this.isPaymentMethodEmpty,
    @required this.isBillingExtraEmpty,
    @required this.isPhotoEmpty,
    @required this.isNameEmpty,
    @required this.isAgeEmpty,
    @required this.isLocationEmpty,
    @required this.isPhoneEmpty,
    @required this.isLongitudeEmpty,
    @required this.isLatitudeEmpty,
    @required this.isSunEmpty,
    @required this.isMonEmpty,
    @required this.isTueEmpty,
    @required this.isWedEmpty,
    @required this.isThruEmpty,
    @required this.isFriEmpty,
    @required this.isSatEmpty,
    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  factory ProfileState.empty() {
    return ProfileState(
      isPhotoEmpty: false,
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
      isPhoneEmpty: false,
      isLongitudeEmpty: false,
      isLatitudeEmpty: false,
      isSunEmpty: false,
      isMonEmpty: false,
      isTueEmpty: false,
      isWedEmpty: false,
      isThruEmpty: false,
      isFriEmpty: false,
      isSatEmpty: false,
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
      isPhotoEmpty: false,
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
      isPhoneEmpty: false,
      isLongitudeEmpty: false,
      isLatitudeEmpty: false,
      isSunEmpty: false,
      isMonEmpty: false,
      isTueEmpty: false,
      isWedEmpty: false,
      isThruEmpty: false,
      isFriEmpty: false,
      isSatEmpty: false,
    );
  }

  factory ProfileState.failure() {
    return ProfileState(
      isPhotoEmpty: false,
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
      isPhoneEmpty: false,
      isLongitudeEmpty: false,
      isLatitudeEmpty: false,
      isSunEmpty: false,
      isMonEmpty: false,
      isTueEmpty: false,
      isWedEmpty: false,
      isThruEmpty: false,
      isFriEmpty: false,
      isSatEmpty: false,
    );
  }

  factory ProfileState.success() {
    return ProfileState(
      isPhotoEmpty: false,
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
      isPhoneEmpty: false,
      isLongitudeEmpty: false,
      isLatitudeEmpty: false,
      isSunEmpty: false,
      isMonEmpty: false,
      isTueEmpty: false,
      isWedEmpty: false,
      isThruEmpty: false,
      isFriEmpty: false,
      isSatEmpty: false,
    );
  }

  ProfileState update(
      {bool isPhotoEmpty,
      bool isNameEmpty,
      bool isAgeEmpty,
      bool isLocationEmpty,
      bool isCusinesEmpty,
      bool isMealTypeEmpty,
      bool isOutletTypeEmpty,
      bool isParkingEmpty,
      bool isPaymentMethodEmpty,
      bool isBillingExtraEmpty,
      bool isPhoneEmpty,
      bool isLongitudeEmpty,
      bool isLatitudeEmpty,
      bool isSunEmpty,
      bool isMonEmpty,
      bool isTueEmpty,
      bool isThruEmpty,
      bool isFriEmpty,
      bool isSatEmpty,
      bool isWedEmpty}) {
    return copyWith(
        isFailure: false,
        isSuccess: false,
        isSubmitting: false,
        isPhotoEmpty: isPhotoEmpty,
        isNameEmpty: isNameEmpty,
        isAgeEmpty: isAgeEmpty,
        isLocationEmpty: isLocationEmpty,
        isBillingExtraEmpty: isBillingExtraEmpty,
        isMealTypeEmpty: isMealTypeEmpty,
        isCusinesEmpty: isCusinesEmpty,
        isParkingEmpty: isParkingEmpty,
        isPaymentMethodEmpty: isPaymentMethodEmpty,
        isOutletTypeEmpty: isOutletTypeEmpty,
        isPhoneEmpty: isPhoneEmpty,
        isLongitudeEmpty: isLongitudeEmpty,
        isLatitudeEmpty: isLatitudeEmpty,
        isSunEmpty: isSunEmpty,
        isMonEmpty: isMonEmpty,
        isTueEmpty: isTueEmpty,
        isThruEmpty: isThruEmpty,
        isFriEmpty: isFriEmpty,
        isSatEmpty: isSatEmpty,
        isWedEmpty: isWedEmpty);
  }

  ProfileState copyWith({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isLocationEmpty,
    bool isCusinesEmpty,
    bool isMealTypeEmpty,
    bool isOutletTypeEmpty,
    bool isParkingEmpty,
    bool isPaymentMethodEmpty,
    bool isBillingExtraEmpty,
    bool isPhoneEmpty,
    bool isLongitudeEmpty,
    bool isLatitudeEmpty,
    bool isSunEmpty,
    bool isMonEmpty,
    bool isTueEmpty,
    bool isThruEmpty,
    bool isFriEmpty,
    bool isSatEmpty,
    bool isWedEmpty,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ProfileState(
      isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      isCusinesEmpty: isCusinesEmpty ?? this.isCusinesEmpty,
      isMealTypeEmpty: isMealTypeEmpty ?? this.isMealTypeEmpty,
      isOutletTypeEmpty: isOutletTypeEmpty ?? this.isOutletTypeEmpty,
      isParkingEmpty: isParkingEmpty ?? this.isParkingEmpty,
      isPaymentMethodEmpty: isPaymentMethodEmpty ?? this.isPaymentMethodEmpty,
      isBillingExtraEmpty: isBillingExtraEmpty ?? this.isBillingExtraEmpty,
      isAgeEmpty: isAgeEmpty ?? this.isAgeEmpty,
      isPhoneEmpty: isPhoneEmpty ?? this.isPhoneEmpty,
      isLongitudeEmpty: isLongitudeEmpty ?? this.isLongitudeEmpty,
      isLatitudeEmpty: isLatitudeEmpty ?? this.isLatitudeEmpty,
      isSunEmpty: isSunEmpty ?? this.isSunEmpty,
      isMonEmpty: isMonEmpty ?? this.isMonEmpty,
      isTueEmpty: isTueEmpty ?? this.isTueEmpty,
      isThruEmpty: isThruEmpty ?? this.isThruEmpty,
      isFriEmpty: isFriEmpty ?? this.isFriEmpty,
      isSatEmpty: isSatEmpty ?? this.isSatEmpty,
      isWedEmpty: isWedEmpty ?? this.isWedEmpty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
