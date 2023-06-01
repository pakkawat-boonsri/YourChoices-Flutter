// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:uuid/uuid.dart';
import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/presentation/blocs/admin_bloc/admin_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/customer/customer_cubit.dart';
import 'package:your_choices/src/presentation/views/admin_side/admin_main_view/admin_main_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/height_container.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';

class QrCodeResultView extends StatefulWidget {
  final String customerData;
  const QrCodeResultView({
    Key? key,
    required this.customerData,
  }) : super(key: key);

  @override
  State<QrCodeResultView> createState() => _QrCodeResultViewState();
}

class _QrCodeResultViewState extends State<QrCodeResultView> {
  late final CustomerEntity customerEntity;
  late final TextEditingController username;
  late final TextEditingController email;
  late final TextEditingController depositAmount;
  late final TextEditingController withdrawAmount;
  @override
  void initState() {
    super.initState();
    customerEntity = CustomerEntity.fromJson(widget.customerData);
    username = TextEditingController(text: customerEntity.username);
    email = TextEditingController(text: customerEntity.email);
    depositAmount = TextEditingController(text: customerEntity.depositAmount);
    withdrawAmount = TextEditingController(text: customerEntity.withdrawAmount);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "คิวอาร์โคดของ - ${username.text}",
          fontSize: 18,
          color: Colors.black,
        ),
        centerTitle: true,
        leading: TouchableOpacity(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: "B44121".toColor(),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 22,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: CachedNetworkImage(
                      imageUrl: customerEntity.profileUrl ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Image.asset(
                        "assets/images/image_picker.png",
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/image_picker.png",
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  const HeightContainer(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "ชื่อลูกค้า",
                          color: Colors.white,
                        ),
                        const HeightContainer(height: 8),
                        TextField(
                          readOnly: true,
                          enabled: false,
                          controller: username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ),
                        ),
                        const HeightContainer(height: 20),
                        const CustomText(
                          text: "อีเมล",
                          color: Colors.white,
                        ),
                        const HeightContainer(height: 8),
                        TextField(
                          readOnly: true,
                          enabled: false,
                          controller: email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ),
                        ),
                        const HeightContainer(height: 20),
                        if (customerEntity.depositAmount != null && customerEntity.withdrawAmount == null) ...[
                          const CustomText(
                            text: "จำนวนเงินที่ต้องการเติม",
                            color: Colors.white,
                          ),
                          const HeightContainer(height: 8),
                          TextField(
                            readOnly: true,
                            enabled: false,
                            controller: depositAmount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ),
                          ),
                        ] else if (customerEntity.withdrawAmount != null && customerEntity.depositAmount == null) ...[
                          const CustomText(
                            text: "จำนวนเงินที่ต้องการถอนออก",
                            color: Colors.white,
                          ),
                          const HeightContainer(height: 8),
                          TextField(
                            readOnly: true,
                            enabled: false,
                            controller: withdrawAmount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TouchableOpacity(
                    onTap: () async {
                      final uid = await di.sl<GetCurrentUidUseCase>().call();
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminMainView(uid: uid),
                            ));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const CustomText(
                        text: "ยกเลิกการเติมเงิน",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TouchableOpacity(
                    onTap: () async {
                      loadingDialog(context);
                      await context.read<AdminCubit>().approveCustomerDepositWithdraw(customerEntity);
                      final newAdminTransaction = AdminTransactionEntity(
                        id: const Uuid().v4(),
                        customerName: customerEntity.username,
                        date: Timestamp.now(),
                        transactionType: customerEntity.depositAmount != null ? "deposit" : "withdraw",
                        deposit:
                            customerEntity.depositAmount != null ? num.parse(customerEntity.depositAmount ?? "0") : null,
                        withdraw:
                            customerEntity.withdrawAmount != null ? num.parse(customerEntity.withdrawAmount ?? "0") : null,
                      );
                      if (context.mounted) {
                        await context.read<AdminCubit>().createAdminTransaction(newAdminTransaction);
                      }

                      if (customerEntity.depositAmount != null && customerEntity.withdrawAmount == null) {
                        final newDepositTransaction = TransactionEntity(
                          id: const Uuid().v4(),
                          date: Timestamp.now(),
                          deposit: num.parse(customerEntity.depositAmount ?? "0"),
                          name: "เติมเงินเข้าบัญชี",
                          type: "deposit",
                        );
                        if (context.mounted) {
                          await context.read<CustomerCubit>().createTransaction(newDepositTransaction);
                        }
                      } else if (customerEntity.depositAmount == null && customerEntity.withdrawAmount != null) {
                        final newWithdrawTransaction = TransactionEntity(
                          id: const Uuid().v4(),
                          date: Timestamp.now(),
                          withdraw: num.parse(customerEntity.withdrawAmount ?? "0"),
                          name: "ถอนเงินออกจากบัญชี",
                          type: "withdraw",
                        );
                        if (context.mounted) {
                          await context.read<CustomerCubit>().createTransaction(newWithdrawTransaction);
                        }
                      }

                      await Future.delayed(const Duration(seconds: 1)).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade900,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomText(
                        text: "ยืนยันการ${customerEntity.depositAmount != null ? "เติมเงิน" : "ถอนเงิน"}",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
