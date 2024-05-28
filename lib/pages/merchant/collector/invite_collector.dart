import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/collector.dart';
import 'package:laravelsingup/model/collector.dart';
// import 'package:laravelsingup/pages/merchant/collector/collector_page.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';

class FindCollectorPage extends StatefulWidget {
  const FindCollectorPage({super.key});

  @override
  State<FindCollectorPage> createState() => _FindCollectorPageState();
}

class _FindCollectorPageState extends State<FindCollectorPage> {
  final collectorController = Get.put(CollectorController());

  @override
  void initState() {
    super.initState();
    collectorController.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find User"),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              CupertinoSearchTextField(
                controller: collectorController.search,
                backgroundColor: Colors.grey.shade100,
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 15, right: 15),
                onChanged: (value) {
                  collectorController.searchTerm.value = value.toLowerCase();
                  collectorController.filterUsers();
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: collectorController.filterUsers().length,
                    itemBuilder: (context, index) {
                      CollectorModel filteredUser =
                          collectorController.filterUsers()[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                  "lib/images/profileIcon.png"), // Use Image.asset for local images
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredUser.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(filteredUser.email),
                                  const SizedBox(height: 10),
                                  Obx(() => !filteredUser
                                          .hasCollectorRequest.value
                                      ? InputButton(
                                          label: "Send Collector Request",
                                          onPress: () async {
                                            await collectorController
                                                .sentInvitation(
                                                    filteredUser.id);
                                           
                                            if (collectorController
                                                .isSuccess.value) {
                                              filteredUser.hasCollectorRequest.value=true;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Obx(
                                                    () => Text(
                                                        collectorController
                                                            .message
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                                
                                              );
                                           
                                            }
                                            else  {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Obx(
                                                    () => Text(
                                                        collectorController
                                                            .errorMessage
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                                
                                              );
                                            
                                            }
                                          },
                                          backgroundColor: Colors.green,
                                          color: Colors.white,
                                        )
                                      : InputButton(
                                          label: "Cancel Collector Request",
                                          onPress: () async {
                                            await collectorController
                                                .cancelInvitation(
                                                    filteredUser.id);
                                            if(collectorController.isSuccess.value){
                                              filteredUser.hasCollectorRequest.value=false;
                                                ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Obx(
                                                    () => Text(
                                                        collectorController
                                                            .message
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                                
                                              );
                                           
                                            }
                                          },
                                          backgroundColor: Colors.grey,
                                          color: Colors.white,
                                        ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
