import 'package:flutter/material.dart';
import '../models/schedule.dart';
import 'states_screen.dart'; // Import the States screen
import 'schedule_details_screen.dart'; // Import a screen to show schedule details (you'll create this)

class SchedulesScreen extends StatelessWidget {
  final List<Schedule> schedules = [
    Schedule(
      title: 'First Schedule',
      details: ['States', 'Union Territories'],
    ),
    Schedule(
      title: 'Second Schedule',
      details: ['Provisions relating to the President and Governors', 'Salaries of MPs'],
    ),
    Schedule(
      title: 'Third Schedule',
      details: ['Forms of Oaths and Affirmations for Constitutional Posts'],
    ),
    Schedule(
      title: 'Fourth Schedule',
      details: ['Allocation of Seats in the Rajya Sabha (Council of States)'],
    ),
    Schedule(
      title: 'Fifth Schedule',
      details: ['Provisions for the Administration and Control of Scheduled Areas and Scheduled Tribes'],
    ),
    Schedule(
      title: 'Sixth Schedule',
      details: ['Provisions for the Administration of Tribal Areas in the states of Assam, Meghalaya, Tripura, and Mizoram'],
    ),
    Schedule(
      title: 'Seventh Schedule',
      details: ['Division of Powers between Union and State - Union List, State List, and Concurrent List'],
    ),
    Schedule(
      title: 'Eighth Schedule',
      details: ['Official Languages recognized by the Constitution'],
    ),
    Schedule(
      title: 'Ninth Schedule',
      details: ['Validation of certain Acts and Regulations, including land reform laws, despite judicial review'],
    ),
    Schedule(
      title: 'Tenth Schedule',
      details: ['Provisions relating to Disqualification of Members on Ground of Defection (Anti-Defection Law)'],
    ),
    Schedule(
      title: 'Eleventh Schedule',
      details: ['Powers, Authority, and Responsibilities of Panchayats'],
    ),
    Schedule(
      title: 'Twelfth Schedule',
      details: ['Powers, Authority, and Responsibilities of Municipalities'],
    ),
    Schedule(
      title: 'Thirteenth Schedule',
      details: ['Provisions related to certain Union Territories and Special Regions'],
    ),
    Schedule(
      title: 'Fourteenth Schedule',
      details: ['Miscellaneous Provisions for Special Governance in certain Regions'],
    ),
    Schedule(
      title: 'Fifteenth Schedule',
      details: ['Amendments to Provisions of the Constitution and Transitional Provisions'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules of the Constitution'),
        backgroundColor: Color(0xFFF3F7EC),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                if (schedule.title == 'First Schedule') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatesScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleDetailsScreen(schedule: schedule),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF006989),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      schedule.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}