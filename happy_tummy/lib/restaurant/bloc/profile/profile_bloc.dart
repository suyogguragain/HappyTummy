import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/profile/bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:meta/meta.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  RestaurantRepository _restaurantRepository;

  ProfileBloc({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  ProfileState get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is CusinesChanged) {
      yield* _mapCusinesChangedToState(event.cusines);
    } else if (event is MealTypeChanged) {
      yield* _mapMealTypeChangedToState(event.mealtype);
    } else if (event is OutletTypeChanged) {
      yield* _mapOutletTypeChangedToState(event.outlettype);
    } else if (event is ParkingChanged) {
      yield* _mapParkingChangedToState(event.parking);
    } else if (event is PaymentMethodChanged) {
      yield* _mapPaymentMethodChangedToState(event.paymentmethod);
    } else if (event is BilingExtraChanged) {
      yield* _mapBillingExtraChangedToState(event.billingextra);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhoneChanged) {
      yield* _mapPhoneChangedToState(event.phone);
    } else if (event is LongitudeChanged) {
      yield* _mapLongitudeChangedToState(event.long);
    } else if (event is LatitudeChanged) {
      yield* _mapLatitudeChangedToState(event.lat);
    } else if (event is SundayChanged) {
      yield* _mapSundayChangedToState(event.sun);
    } else if (event is MondayChanged) {
      yield* _mapMondayChangedToState(event.mon);
    } else if (event is TuesdayChanged) {
      yield* _mapTuesdayChangedToState(event.tue);
    } else if (event is WednesdayChanged) {
      yield* _mapWednesdayChangedToState(event.wed);
    } else if (event is ThrusdayChanged) {
      yield* _mapThrusdayChangedToState(event.thrus);
    } else if (event is FridayChanged) {
      yield* _mapFridayChangedToState(event.fri);
    } else if (event is SaturdayChanged) {
      yield* _mapSaturdayChangedToState(event.sat);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _restaurantRepository.getUser();
      yield* _mapSubmittedToState(
        photo: event.photo,
        name: event.name,
        cusines: event.cusines,
        mealtype: event.mealtype,
        outlettype: event.outlettype,
        parking: event.parking,
        paymentmethod: event.paymentmethod,
        billingextra: event.billingextra,
        rid: uid,
        age: event.age,
        location: event.location,
        phone: event.phone,
        latitude: event.latitude,
        longitude: event.longitude,
        sunday: event.sunday,
        monday: event.monday,
        tuesday: event.tuesday,
        wednesday: event.wednesday,
        thrusday: event.thrusday,
        friday: event.friday,
        saturday: event.saturday,
      );
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileState> _mapAgeChangedToState(DateTime age) async* {
    yield state.update(
      isAgeEmpty: age == null,
    );
  }

  Stream<ProfileState> _mapCusinesChangedToState(String cusines) async* {
    yield state.update(
      isCusinesEmpty: cusines == null,
    );
  }

  Stream<ProfileState> _mapMealTypeChangedToState(String mealtype) async* {
    yield state.update(
      isMealTypeEmpty: mealtype == null,
    );
  }

  Stream<ProfileState> _mapOutletTypeChangedToState(String outlettype) async* {
    yield state.update(
      isOutletTypeEmpty: outlettype == null,
    );
  }

  Stream<ProfileState> _mapParkingChangedToState(String parking) async* {
    yield state.update(
      isParkingEmpty: parking == null,
    );
  }

  Stream<ProfileState> _mapPaymentMethodChangedToState(
      String paymentmethod) async* {
    yield state.update(
      isPaymentMethodEmpty: paymentmethod == null,
    );
  }

  Stream<ProfileState> _mapBillingExtraChangedToState(
      String billingextra) async* {
    yield state.update(
      isBillingExtraEmpty: billingextra == null,
    );
  }

  Stream<ProfileState> _mapLocationChangedToState(String location) async* {
    yield state.update(
      isLocationEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapPhoneChangedToState(String phone) async* {
    yield state.update(
      isPhoneEmpty: phone == null,
    );
  }

  Stream<ProfileState> _mapLongitudeChangedToState(String long) async* {
    yield state.update(
      isLongitudeEmpty: long == null,
    );
  }

  Stream<ProfileState> _mapLatitudeChangedToState(String lat) async* {
    yield state.update(
      isLatitudeEmpty: lat == null,
    );
  }

  Stream<ProfileState> _mapSundayChangedToState(String sun) async* {
    yield state.update(
      isSunEmpty: sun == null,
    );
  }

  Stream<ProfileState> _mapMondayChangedToState(String mon) async* {
    yield state.update(
      isMonEmpty: mon == null,
    );
  }

  Stream<ProfileState> _mapTuesdayChangedToState(String location) async* {
    yield state.update(
      isTueEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapWednesdayChangedToState(String location) async* {
    yield state.update(
      isWedEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapThrusdayChangedToState(String location) async* {
    yield state.update(
      isThruEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapFridayChangedToState(String location) async* {
    yield state.update(
      isFriEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapSaturdayChangedToState(String location) async* {
    yield state.update(
      isSatEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapSubmittedToState(
      {File photo,
      String rid,
      String name,
      String cusines,
      String mealtype,
      String outlettype,
      String parking,
      String paymentmethod,
      String billingextra,
      String phone,
      String longitude,
      String latitude,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thrusday,
      String friday,
      String saturday,
      DateTime age,
      String location}) async* {
    yield ProfileState.loading();
    try {
      await _restaurantRepository.profileSetup(
        photo,
        rid,
        name,
        cusines,
        mealtype,
        outlettype,
        parking,
        paymentmethod,
        billingextra,
        phone,
        longitude,
        latitude,
        sunday,
        monday,
        tuesday,
        wednesday,
        thrusday,
        friday,
        saturday,
        age,
        location,
      );
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
