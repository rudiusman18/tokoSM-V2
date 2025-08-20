import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokosm_v2/cubit/auth_cubit.dart';
import 'package:tokosm_v2/shared/themes.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // NOTE: ALAMAT
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                "Alamat Pengiriman",
                style: TextStyle(
                  fontWeight: bold,
                ),
              ),
              _CheckoutPageExtension().addressItemView(context),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutPageExtension {
  Widget addressItemView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        const Icon(
          SolarIconsOutline.mapPoint,
          size: 14,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${context.read<AuthCubit>().state.loginModel.data?.namaPelanggan}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text:
                        " | ${context.read<AuthCubit>().state.loginModel.data?.telpPelanggan}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              context.read<AuthCubit>().state.loginModel.data?.alamatPelanggan,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
