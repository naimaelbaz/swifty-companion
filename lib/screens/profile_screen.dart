import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  final Coalition coalition;
  ProfileScreen({required this.user, required this.coalition});

  @override
  Widget build(BuildContext context) {
    final Color coalitionColor = Color(
      int.parse(coalition.color.replaceAll('#', '0xff')),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${user.login} Profile',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff2c2c34),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          Image(
            image: NetworkImage(coalition.imageUrl),
            fit: BoxFit.fill,
            width: double.infinity,
            height: 150,
          ),

          Column(
            children: [
              SizedBox(height: 100),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xff2c2c34),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),

                  child: Column(
                    children: [
                      SizedBox(height: 85),
                      Text(
                        user.login.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),

                      SizedBox(height: 20),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white.withValues(alpha: 0.05),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _infoTile(
                                          Icons.trending_up,
                                          "Level",
                                          user.level.toStringAsFixed(2),
                                          coalitionColor,
                                        ),
                                        _infoTile(
                                          Icons.account_balance_wallet,
                                          "Wallet",
                                          "${user.wallet} ₳",
                                          coalitionColor,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.white10,
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _infoTile(
                                          Icons.location_on,
                                          "Location",
                                          user.location,
                                          coalitionColor,
                                        ),
                                        _infoTile(
                                          Icons.phone,
                                          "Phone",
                                          user.phone,
                                          coalitionColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              Container(
                                width: double.infinity,
                                // height: 350,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 2.5,
                                          decoration: BoxDecoration(
                                            color: coalitionColor,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Skills',
                                          style: TextStyle(
                                            color: coalitionColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: user.skills.map((skill) {
                                          double percentage =
                                              skill['level'] / 20;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: SizedBox(
                                              width: 75,
                                              child: _skillRing(
                                                skill['name'],
                                                skill['level'],
                                                percentage,
                                                coalitionColor,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 2),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 2.5,
                                          decoration: BoxDecoration(
                                            color: coalitionColor,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Projects',
                                          style: TextStyle(
                                            color: coalitionColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      height: 300,
                                      child: SingleChildScrollView(
                                        // scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: user.projects.map((
                                            project,
                                          ) {
                                            final String projectName = project['project']['name'];
                                            final int mark = project['final_mark'] ?? 0;
                                            final bool valid = project['validated?'] ?? false;
                                            final String status = project['status'] ?? '';
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: SizedBox(
                                                child: _projectTile(
                                                  projectName,
                                                  mark,
                                                  valid,
                                                  status,
                                                  coalitionColor,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 5,
                      spreadRadius: 3,
                      offset: Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: const Color(0xff2c2c34), width: 5),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFFFFF), // ← teal border (inner)
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      // color: Colors.white,
                      user.imageUrl,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.person, size: 80, color: Colors.white54),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String label,
    String value,
    Color themeColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: themeColor, size: 20),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _skillRing(String name, double level, double percentage, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: percentage,
                strokeWidth: 4,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              level.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 32,
          width: 70,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

Widget _projectTile(String name, int mark, bool valid, String status, Color themeColor) {
  final Color statusColor = status == 'finished' && valid
      ? Colors.greenAccent
      : status == 'finished' && !valid
          ? Colors.redAccent
          : Colors.orangeAccent;

  final IconData statusIcon = status == 'finished' && valid
      ? Icons.check_circle_outline
      : status == 'finished' && !valid
          ? Icons.cancel_outlined
          : Icons.timelapse;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status == 'finished' ? '$mark / 100' : status.replaceAll('_', ' '),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            border: Border.all(color: statusColor.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            statusIcon,
            color: statusColor,
            size: 18,
          ),
        ),
      ],
    ),
  );
}
}
