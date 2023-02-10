import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/presentation/blocs/vendor/vendor_cubit.dart';

class VendorMainView extends StatefulWidget {
  final String uid;
  const VendorMainView({super.key, required this.uid});

  @override
  State<VendorMainView> createState() => _VendorMainViewState();
}

class _VendorMainViewState extends State<VendorMainView> {
  @override
  void initState() {
    BlocProvider.of<VendorCubit>(context).getSingleVendor(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Vendor Side"),
      ),
    );
  }
}
