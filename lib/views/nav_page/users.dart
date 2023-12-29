import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),
        ),
        body: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('PV: 300'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.yellow.shade900,
                    ),
                  ),
                  const Text('PV: 265'),
                ],
              ),
            ),
            const Text('2313514'),
            const Text('Praset'),
            Container(
              height: 10,
              width: 2,
              decoration: const BoxDecoration(
                  border: Border(
                left: BorderSide(color: Colors.black, width: 2),
              )),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black, width: 2),
                      left: BorderSide(color: Colors.black, width: 2),
                      right: BorderSide(color: Colors.black, width: 2))),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.89,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'PV: 700',
                        style: TextStyle(fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.yellow.shade900,
                        ),
                      ),
                      const Text(
                        'PV: 500',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'PV: 600',
                        style: TextStyle(fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.yellow.shade900,
                        ),
                      ),
                      const Text(
                        'PV: 350',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        const Text('2313514'),
                        const Text('Wanna'),
                        Container(
                          height: 10,
                          width: 2,
                          decoration: const BoxDecoration(
                              border: Border(
                            left: BorderSide(color: Colors.black, width: 2),
                          )),
                        ),
                        Container(
                          height: 15,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: const BoxDecoration(
                              border: Border(
                                  top:
                                      BorderSide(color: Colors.black, width: 2),
                                  left:
                                      BorderSide(color: Colors.black, width: 2),
                                  right: BorderSide(
                                      color: Colors.black, width: 2))),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.yellow.shade900,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.yellow.shade900,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        const Text('2313514'),
                        const Text('Navaphon'),
                        Container(
                          height: 10,
                          width: 2,
                          decoration: const BoxDecoration(
                              border: Border(
                            left: BorderSide(color: Colors.black, width: 2),
                          )),
                        ),
                        Container(
                          height: 15,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: const BoxDecoration(
                              border: Border(
                                  top:
                                      BorderSide(color: Colors.black, width: 2),
                                  left:
                                      BorderSide(color: Colors.black, width: 2),
                                  right: BorderSide(
                                      color: Colors.black, width: 2))),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.yellow.shade900,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.yellow.shade900,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 29),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: SizedBox(
                              child: Column(
                                children: [
                                  const Text('2313514',
                                      style: TextStyle(fontSize: 12)),
                                  const Text('Thaksin',
                                      style: TextStyle(fontSize: 12)),
                                  Container(
                                    height: 7,
                                    width: 2,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                          color: Colors.black, width: 2),
                                    )),
                                  ),
                                  Container(
                                    height: 10,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.black, width: 2),
                                            left: BorderSide(
                                                color: Colors.black, width: 2),
                                            right: BorderSide(
                                                color: Colors.black,
                                                width: 2))),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.yellow.shade900,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.yellow.shade900,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              children: [
                                const Text('2313514',
                                    style: TextStyle(fontSize: 12)),
                                const Text('xxxxx',
                                    style: TextStyle(fontSize: 12)),
                                Container(
                                  height: 7,
                                  width: 2,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                        color: Colors.black, width: 2),
                                  )),
                                ),
                                Container(
                                  height: 10,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.black, width: 2),
                                          left: BorderSide(
                                              color: Colors.black, width: 2),
                                          right: BorderSide(
                                              color: Colors.black, width: 2))),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                Colors.yellow.shade900,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                Colors.yellow.shade900,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 29),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: SizedBox(
                              child: Column(
                                children: [
                                  const Text('2313514',
                                      style: TextStyle(fontSize: 12)),
                                  const Text('Thaksin',
                                      style: TextStyle(fontSize: 12)),
                                  Container(
                                    height: 7,
                                    width: 2,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                          color: Colors.black, width: 2),
                                    )),
                                  ),
                                  Container(
                                    height: 10,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.black, width: 2),
                                            left: BorderSide(
                                                color: Colors.black, width: 2),
                                            right: BorderSide(
                                                color: Colors.black,
                                                width: 2))),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.yellow.shade900,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.yellow.shade900,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              children: [
                                const Text('2313514',
                                    style: TextStyle(fontSize: 12)),
                                const Text('xxxxx',
                                    style: TextStyle(fontSize: 12)),
                                Container(
                                  height: 7,
                                  width: 2,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                        color: Colors.black, width: 2),
                                  )),
                                ),
                                Container(
                                  height: 10,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.black, width: 2),
                                          left: BorderSide(
                                              color: Colors.black, width: 2),
                                          right: BorderSide(
                                              color: Colors.black, width: 2))),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                Colors.yellow.shade900,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                Colors.yellow.shade900,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )
          ],
        ));
  }
}
