import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/profile/bloc.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
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
          location: event.location);
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

  Stream<ProfileState> _mapSubmittedToState(
      {File photo,
      String cusines,
      String mealtype,
      String outlettype,
      String parking,
      String paymentmethod,
      String billingextra,
      String name,
      String rid,
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
          age,
          location);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
