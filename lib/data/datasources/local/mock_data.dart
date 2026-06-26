import 'dart:convert';
import 'sqlite_helper.dart';



class MockDataSource {
  
  
  

  static List<Map<String, dynamic>> getMockUsers() {
    return [
      {
        'id': 'tech-001',
        'full_name': 'Alex Rodriguez',
        'email': 'alex@servicesync.com',
        'phone': '+1-555-0101',
        'role': 'technician',
        'profile_image': '',
        'created_at': '2025-01-15T08:00:00.000Z',
        'assigned_jobs': 12,
        'completed_jobs': 8,
        'completion_rate': 0.67,
      },
      {
        'id': 'tech-002',
        'full_name': 'Sarah Chen',
        'email': 'sarah@servicesync.com',
        'phone': '+1-555-0102',
        'role': 'technician',
        'profile_image': '',
        'created_at': '2025-02-10T09:00:00.000Z',
        'assigned_jobs': 15,
        'completed_jobs': 13,
        'completion_rate': 0.87,
      },
      {
        'id': 'admin-001',
        'full_name': 'Marcus Johnson',
        'email': 'admin@servicesync.com',
        'phone': '+1-555-0100',
        'role': 'admin',
        'profile_image': '',
        'created_at': '2024-11-01T07:00:00.000Z',
        'assigned_jobs': 0,
        'completed_jobs': 0,
        'completion_rate': 1.0,
      },
    ];
  }

  
  
  

  static List<Map<String, dynamic>> getMockCustomers() {
    return [
      {
        'customer_id': 'cust-001',
        'name': 'Ethan Williams',
        'email': 'ethan.williams@email.com',
        'phone': '+1-555-2001',
        'address': '142 Maple Avenue, Austin, TX 78701',
        'latitude': 30.2672,
        'longitude': -97.7431,
        'service_history': jsonEncode(['req-001', 'req-006']),
      },
      {
        'customer_id': 'cust-002',
        'name': 'Priya Patel',
        'email': 'priya.patel@email.com',
        'phone': '+1-555-2002',
        'address': '87 Oak Street, Austin, TX 78702',
        'latitude': 30.2580,
        'longitude': -97.7200,
        'service_history': jsonEncode(['req-002']),
      },
      {
        'customer_id': 'cust-003',
        'name': 'David Kim',
        'email': 'david.kim@email.com',
        'phone': '+1-555-2003',
        'address': '310 Pine Road, Austin, TX 78703',
        'latitude': 30.2849,
        'longitude': -97.7341,
        'service_history': jsonEncode(['req-003', 'req-007']),
      },
      {
        'customer_id': 'cust-004',
        'name': 'Linda Foster',
        'email': 'linda.foster@email.com',
        'phone': '+1-555-2004',
        'address': '55 Cedar Boulevard, Austin, TX 78704',
        'latitude': 30.2440,
        'longitude': -97.7590,
        'service_history': jsonEncode(['req-004', 'req-008']),
      },
      {
        'customer_id': 'cust-005',
        'name': 'Robert Nguyen',
        'email': 'robert.nguyen@email.com',
        'phone': '+1-555-2005',
        'address': '203 Elm Court, Austin, TX 78705',
        'latitude': 30.2930,
        'longitude': -97.7480,
        'service_history': jsonEncode(['req-005', 'req-009', 'req-010']),
      },
    ];
  }

  
  
  

  static List<Map<String, dynamic>> getMockServiceRequests() {
    return [
      
      {
        'requestId': 'req-001',
        'customerName': 'Ethan Williams',
        'customerId': 'cust-001',
        'serviceType': 'HVAC Repair',
        'issueDescription':
            'Central air conditioning unit not cooling below 80°F. '
                'Thermostat reads correct but compressor sounds unusual.',
        'status': 'pending',
        'assignedTechnician': 'tech-001',
        'serviceDate': '2026-06-28T10:00:00.000Z',
        'priority': 'high',
        'address': '142 Maple Avenue, Austin, TX 78701',
        'latitude': 30.2672,
        'longitude': -97.7431,
        'createdAt': '2026-06-26T07:30:00.000Z',
        'qrCode': 'SS-REQ-001',
      },
      {
        'requestId': 'req-002',
        'customerName': 'Priya Patel',
        'customerId': 'cust-002',
        'serviceType': 'Electrical Fault',
        'issueDescription':
            'Kitchen circuit breaker trips repeatedly when using '
                'microwave and dishwasher simultaneously.',
        'status': 'pending',
        'assignedTechnician': 'tech-002',
        'serviceDate': '2026-06-29T09:00:00.000Z',
        'priority': 'medium',
        'address': '87 Oak Street, Austin, TX 78702',
        'latitude': 30.2580,
        'longitude': -97.7200,
        'createdAt': '2026-06-26T08:15:00.000Z',
        'qrCode': 'SS-REQ-002',
      },

      
      {
        'requestId': 'req-003',
        'customerName': 'David Kim',
        'customerId': 'cust-003',
        'serviceType': 'Plumbing Emergency',
        'issueDescription':
            'Burst pipe under kitchen sink causing water damage. '
                'Water shut off at main. Requires immediate attention.',
        'status': 'accepted',
        'assignedTechnician': 'tech-001',
        'serviceDate': '2026-06-26T14:00:00.000Z',
        'priority': 'emergency',
        'address': '310 Pine Road, Austin, TX 78703',
        'latitude': 30.2849,
        'longitude': -97.7341,
        'createdAt': '2026-06-26T06:45:00.000Z',
        'qrCode': 'SS-REQ-003',
      },
      {
        'requestId': 'req-004',
        'customerName': 'Linda Foster',
        'customerId': 'cust-004',
        'serviceType': 'Security System',
        'issueDescription':
            'Front-door motion sensor offline. Security panel '
                'shows zone 3 fault. Camera feed intermittent.',
        'status': 'accepted',
        'assignedTechnician': 'tech-002',
        'serviceDate': '2026-06-27T11:00:00.000Z',
        'priority': 'high',
        'address': '55 Cedar Boulevard, Austin, TX 78704',
        'latitude': 30.2440,
        'longitude': -97.7590,
        'createdAt': '2026-06-25T15:00:00.000Z',
        'qrCode': 'SS-REQ-004',
      },

      
      {
        'requestId': 'req-005',
        'customerName': 'Robert Nguyen',
        'customerId': 'cust-005',
        'serviceType': 'Network Setup',
        'issueDescription':
            'New office wing requires network infrastructure: '
                '8 ethernet drops, patch panel, and managed switch configuration.',
        'status': 'inProgress',
        'assignedTechnician': 'tech-001',
        'serviceDate': '2026-06-26T09:00:00.000Z',
        'priority': 'medium',
        'address': '203 Elm Court, Austin, TX 78705',
        'latitude': 30.2930,
        'longitude': -97.7480,
        'createdAt': '2026-06-24T10:00:00.000Z',
        'qrCode': 'SS-REQ-005',
      },
      {
        'requestId': 'req-006',
        'customerName': 'Ethan Williams',
        'customerId': 'cust-001',
        'serviceType': 'Generator Maintenance',
        'issueDescription':
            'Standby generator annual service overdue. Last '
                'serviced 14 months ago. Oil change, filter, and load-bank test required.',
        'status': 'inProgress',
        'assignedTechnician': 'tech-002',
        'serviceDate': '2026-06-26T08:00:00.000Z',
        'priority': 'low',
        'address': '142 Maple Avenue, Austin, TX 78701',
        'latitude': 30.2672,
        'longitude': -97.7431,
        'createdAt': '2026-06-23T14:00:00.000Z',
        'qrCode': 'SS-REQ-006',
      },

      
      {
        'requestId': 'req-007',
        'customerName': 'David Kim',
        'customerId': 'cust-003',
        'serviceType': 'HVAC Repair',
        'issueDescription':
            'Heating element failure in split-unit bedroom. '
                'Unit powers on but does not heat.',
        'status': 'completed',
        'assignedTechnician': 'tech-001',
        'serviceDate': '2026-06-20T10:00:00.000Z',
        'priority': 'medium',
        'address': '310 Pine Road, Austin, TX 78703',
        'latitude': 30.2849,
        'longitude': -97.7341,
        'createdAt': '2026-06-19T09:00:00.000Z',
        'qrCode': 'SS-REQ-007',
      },
      {
        'requestId': 'req-008',
        'customerName': 'Linda Foster',
        'customerId': 'cust-004',
        'serviceType': 'Electrical Fault',
        'issueDescription':
            'Outdoor GFCI outlets tripping after rain. Possible '
                'water ingress in outlet box.',
        'status': 'completed',
        'assignedTechnician': 'tech-002',
        'serviceDate': '2026-06-18T13:00:00.000Z',
        'priority': 'high',
        'address': '55 Cedar Boulevard, Austin, TX 78704',
        'latitude': 30.2440,
        'longitude': -97.7590,
        'createdAt': '2026-06-17T11:00:00.000Z',
        'qrCode': 'SS-REQ-008',
      },

      
      {
        'requestId': 'req-009',
        'customerName': 'Robert Nguyen',
        'customerId': 'cust-005',
        'serviceType': 'Plumbing Emergency',
        'issueDescription':
            'Customer reported sewage smell from basement. '
                'Inspection revealed issue is outside service area (city main line).',
        'status': 'rejected',
        'assignedTechnician': 'tech-001',
        'serviceDate': '2026-06-22T15:00:00.000Z',
        'priority': 'high',
        'address': '203 Elm Court, Austin, TX 78705',
        'latitude': 30.2930,
        'longitude': -97.7480,
        'createdAt': '2026-06-21T16:00:00.000Z',
        'qrCode': 'SS-REQ-009',
      },

      
      {
        'requestId': 'req-010',
        'customerName': 'Robert Nguyen',
        'customerId': 'cust-005',
        'serviceType': 'Electrical Fault',
        'issueDescription':
            'Main electrical panel sparking and emitting burning '
                'smell. Breakers feel hot to touch. Power partially cut. URGENT.',
        'status': 'pending',
        'assignedTechnician': 'tech-002',
        'serviceDate': '2026-06-26T11:30:00.000Z',
        'priority': 'emergency',
        'address': '203 Elm Court, Austin, TX 78705',
        'latitude': 30.2930,
        'longitude': -97.7480,
        'createdAt': '2026-06-26T09:55:00.000Z',
        'qrCode': 'SS-REQ-010',
      },
    ];
  }

  
  
  

  static List<Map<String, dynamic>> getMockNotifications() {
    return [
      {
        'id': 'notif-001',
        'title': 'New Job Assigned',
        'body':
            'You have been assigned a Plumbing Emergency at 310 Pine Road. '
                'Please confirm your attendance.',
        'type': 'job_assigned',
        'readStatus': 0,
        'timestamp': '2026-06-26T06:45:00.000Z',
        'relatedId': 'req-003',
      },
      {
        'id': 'notif-002',
        'title': '⚠️ Emergency Job Alert',
        'body':
            'URGENT: Electrical panel fault at 203 Elm Court. '
                'Customer safety at risk. Respond immediately.',
        'type': 'emergency',
        'readStatus': 0,
        'timestamp': '2026-06-26T09:56:00.000Z',
        'relatedId': 'req-010',
      },
      {
        'id': 'notif-003',
        'title': 'Job Status Updated',
        'body':
            'Service request REQ-005 has been moved to In Progress '
                'by Alex Rodriguez.',
        'type': 'status_update',
        'readStatus': 0,
        'timestamp': '2026-06-26T09:05:00.000Z',
        'relatedId': 'req-005',
      },
      {
        'id': 'notif-004',
        'title': 'Report Submitted',
        'body':
            'Service report for REQ-007 (HVAC Repair – David Kim) '
                'has been successfully submitted.',
        'type': 'report_submitted',
        'readStatus': 1,
        'timestamp': '2026-06-20T16:30:00.000Z',
        'relatedId': 'rep-001',
      },
      {
        'id': 'notif-005',
        'title': 'New Message from Marcus Johnson',
        'body':
            'Hey Alex, please make sure to photo-document the '
                'panel before starting work on REQ-010.',
        'type': 'chat',
        'readStatus': 0,
        'timestamp': '2026-06-26T09:58:00.000Z',
        'relatedId': 'admin-001',
      },
      {
        'id': 'notif-006',
        'title': 'Job Completed',
        'body':
            'Great work! REQ-008 (Electrical Fault – Linda Foster) '
                'marked as completed. Customer rating: ⭐⭐⭐⭐⭐',
        'type': 'job_completed',
        'readStatus': 1,
        'timestamp': '2026-06-18T17:00:00.000Z',
        'relatedId': 'req-008',
      },
      {
        'id': 'notif-007',
        'title': 'Sync Completed',
        'body':
            '4 pending records have been successfully synced to '
                'the cloud. All data is up to date.',
        'type': 'sync',
        'readStatus': 1,
        'timestamp': '2026-06-25T22:00:00.000Z',
        'relatedId': '',
      },
      {
        'id': 'notif-008',
        'title': 'Schedule Reminder',
        'body':
            'You have 2 jobs scheduled for tomorrow. First job '
                'starts at 09:00 AM. Check your route.',
        'type': 'reminder',
        'readStatus': 0,
        'timestamp': '2026-06-26T08:00:00.000Z',
        'relatedId': '',
      },
    ];
  }

  
  
  

  static List<Map<String, dynamic>> getMockChatMessages() {
    return [
      {
        'id': 'msg-001',
        'sender_id': 'admin-001',
        'sender_name': 'Marcus Johnson',
        'receiver_id': 'tech-001',
        'message':
            'Good morning Alex! Big day ahead. You have 3 active '
                'jobs. Start with req-003, it\'s marked as emergency.',
        'timestamp': '2026-06-26T07:00:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-002',
        'sender_id': 'tech-001',
        'sender_name': 'Alex Rodriguez',
        'receiver_id': 'admin-001',
        'message':
            'Morning Marcus! Got it, heading to Pine Road first. '
                'ETA around 8:30 AM.',
        'timestamp': '2026-06-26T07:05:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-003',
        'sender_id': 'admin-001',
        'sender_name': 'Marcus Johnson',
        'receiver_id': 'tech-001',
        'message':
            'Perfect. Customer David Kim will meet you at the '
                'front door. He mentioned the shutoff valve is already closed.',
        'timestamp': '2026-06-26T07:07:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-004',
        'sender_id': 'tech-001',
        'sender_name': 'Alex Rodriguez',
        'receiver_id': 'admin-001',
        'message':
            'Good to know. Do we have a copper pipe repair kit '
                'in the van? I might need a 3/4 inch coupler.',
        'timestamp': '2026-06-26T07:10:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-005',
        'sender_id': 'admin-001',
        'sender_name': 'Marcus Johnson',
        'receiver_id': 'tech-001',
        'message':
            'Yes, van 2 is stocked. Check the red toolbox in the '
                'back. Also, remember to capture before/after photos.',
        'timestamp': '2026-06-26T07:12:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-006',
        'sender_id': 'tech-001',
        'sender_name': 'Alex Rodriguez',
        'receiver_id': 'admin-001',
        'message':
            'On-site now. Confirmed burst pipe, secondary leak at '
                'elbow joint. Starting repair. Will update shortly.',
        'timestamp': '2026-06-26T08:35:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-007',
        'sender_id': 'admin-001',
        'sender_name': 'Marcus Johnson',
        'receiver_id': 'tech-001',
        'message': 'Copy that. Keep me posted. Great work!',
        'timestamp': '2026-06-26T08:37:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-008',
        'sender_id': 'tech-001',
        'sender_name': 'Alex Rodriguez',
        'receiver_id': 'admin-001',
        'message':
            'Repair complete. Customer signed off. Uploading '
                'report now. Heading to next job at Elm Court.',
        'timestamp': '2026-06-26T09:50:00.000Z',
        'is_read': 1,
        'attachment_url': '',
      },
      {
        'id': 'msg-009',
        'sender_id': 'admin-001',
        'sender_name': 'Marcus Johnson',
        'receiver_id': 'tech-001',
        'message':
            'Hey Alex, please make sure to photo-document the '
                'panel before starting work on REQ-010.',
        'timestamp': '2026-06-26T09:58:00.000Z',
        'is_read': 0,
        'attachment_url': '',
      },
      {
        'id': 'msg-010',
        'sender_id': 'tech-001',
        'sender_name': 'Alex Rodriguez',
        'receiver_id': 'admin-001',
        'message': 'Will do, Marcus. Arriving in about 10 minutes.',
        'timestamp': '2026-06-26T10:01:00.000Z',
        'is_read': 0,
        'attachment_url': '',
      },
    ];
  }

  
  
  

  static List<Map<String, dynamic>> getMockServiceReports() {
    return [
      {
        'reportId': 'rep-001',
        'serviceRequestReference': 'req-007',
        'findings':
            'Heating element in indoor unit failed due to '
                'capacitor degradation. Refrigerant level was also 15% below spec, '
                'indicating a slow leak at the service valve fitting.',
        'actionsTaken':
            'Replaced heating element and capacitor assembly. '
                'Located and sealed refrigerant leak at service valve using approved '
                'sealant. Topped up refrigerant to manufacturer spec (R-410A, 2.4 kg). '
                'Tested unit across all modes — heating, cooling, fan.',
        'completionNotes':
            'Unit fully operational. Recommended annual '
                'refrigerant check. Customer educated on filter maintenance schedule.',
        'images': jsonEncode([
          'report_images/rep-001/before_unit.jpg',
          'report_images/rep-001/capacitor_replaced.jpg',
          'report_images/rep-001/after_unit.jpg',
        ]),
        'signature': 'signatures/rep-001/david_kim_sig.png',
        'voiceNote': '',
        'timestamp': '2026-06-20T15:45:00.000Z',
        'technicianId': 'tech-001',
        'customerName': 'David Kim',
        'partsUsed': jsonEncode([
          {'part': 'Heating Element Assembly', 'qty': 1, 'cost': 89.99},
          {'part': 'Start Capacitor 45/5 MFD', 'qty': 1, 'cost': 24.50},
          {'part': 'R-410A Refrigerant (per kg)', 'qty': 2, 'cost': 35.00},
        ]),
      },
      {
        'reportId': 'rep-002',
        'serviceRequestReference': 'req-008',
        'findings':
            'Two outdoor GFCI outlets on the south-facing wall '
                'showed water ingress at the conduit entry points. Moisture had '
                'triggered the GFCI repeatedly and corroded one outlet terminal.',
        'actionsTaken':
            'Removed and replaced both outdoor GFCI outlets '
                'with weather-resistant models (TR+WR rated). Sealed conduit '
                'entry points with outdoor-grade silicone. Installed bubble covers. '
                'Tested GFCI trip and reset under load.',
        'completionNotes':
            'Both outlets pass all GFCI tests. Recommend '
                'customer inspect covers after heavy rain. Work completed to NEC code.',
        'images': jsonEncode([
          'report_images/rep-002/corroded_outlet.jpg',
          'report_images/rep-002/new_outlet_installed.jpg',
          'report_images/rep-002/sealed_conduit.jpg',
        ]),
        'signature': 'signatures/rep-002/linda_foster_sig.png',
        'voiceNote': 'voice_notes/rep-002/site_notes.m4a',
        'timestamp': '2026-06-18T16:30:00.000Z',
        'technicianId': 'tech-002',
        'customerName': 'Linda Foster',
        'partsUsed': jsonEncode([
          {'part': 'GFCI Outlet 20A TR+WR', 'qty': 2, 'cost': 18.75},
          {'part': 'Bubble Cover (Duplex)', 'qty': 2, 'cost': 9.99},
          {'part': 'Silicone Sealant (tube)', 'qty': 1, 'cost': 6.50},
        ]),
      },
      {
        'reportId': 'rep-003',
        'serviceRequestReference': 'req-003',
        'findings':
            'Confirmed burst 3/4" copper pipe at elbow joint '
                'under kitchen sink cabinet. Secondary hairline crack found '
                '6" upstream from main burst point. Water damage limited to '
                'cabinet interior — no subfloor penetration.',
        'actionsTaken':
            'Cut out 18" damaged pipe section. Installed new '
                'copper pipe segment with two compression fittings. Applied flux '
                'and soldered joints. Pressure tested at 80 PSI for 15 minutes '
                'with no drop. Restored water main. Cleaned and dried cabinet interior.',
        'completionNotes':
            'All joints watertight. Customer advised to '
                'monitor for 48 hours and check joints for any seeping. '
                'Recommended replacing cabinet liner due to water damage.',
        'images': jsonEncode([
          'report_images/rep-003/burst_pipe.jpg',
          'report_images/rep-003/new_pipe_soldered.jpg',
          'report_images/rep-003/pressure_test.jpg',
          'report_images/rep-003/job_complete.jpg',
        ]),
        'signature': 'signatures/rep-003/david_kim_sig.png',
        'voiceNote': '',
        'timestamp': '2026-06-26T09:45:00.000Z',
        'technicianId': 'tech-001',
        'customerName': 'David Kim',
        'partsUsed': jsonEncode([
          {'part': '3/4" Copper Pipe (per foot)', 'qty': 2, 'cost': 12.00},
          {'part': '3/4" Compression Coupling', 'qty': 2, 'cost': 8.25},
          {'part': 'Plumbing Solder & Flux Kit', 'qty': 1, 'cost': 14.99},
        ]),
      },
    ];
  }

  
  
  

  static Map<String, dynamic> getMockCurrentUser() {
    return {
      'id': 'tech-001',
      'full_name': 'Alex Rodriguez',
      'email': 'alex@servicesync.com',
      'phone': '+1-555-0101',
      'role': 'technician',
      'profile_image': '',
      'created_at': '2025-01-15T08:00:00.000Z',
      'assigned_jobs': 12,
      'completed_jobs': 8,
      'completion_rate': 0.67,
    };
  }

  
  
  

  
  static List<double> getWeeklyJobData() {
    return [3, 5, 2, 7, 4, 6, 8];
  }

  
  static List<double> getMonthlyCompletionData() {
    return [72.0, 65.0, 80.0, 78.0, 85.0, 87.0];
  }

  
  
  

  
  
  Future<void> seedDatabase(SQLiteHelper db) async {
    
    if (await db.rowCount('users') == 0) {
      for (final user in getMockUsers()) {
        await db.insertUser(user);
      }
    }

    
    if (await db.rowCount('customers') == 0) {
      for (final customer in getMockCustomers()) {
        await db.insertCustomer(customer);
      }
    }

    
    if (await db.rowCount('service_requests') == 0) {
      for (final request in getMockServiceRequests()) {
        await db.insertServiceRequest(request);
      }
    }

    
    if (await db.rowCount('notifications') == 0) {
      for (final notification in getMockNotifications()) {
        await db.insertNotification(notification);
      }
    }

    
    if (await db.rowCount('chat_messages') == 0) {
      for (final message in getMockChatMessages()) {
        await db.insertChatMessage(message);
      }
    }

    
    if (await db.rowCount('service_reports') == 0) {
      for (final report in getMockServiceReports()) {
        await db.insertServiceReport(report);
      }
    }
  }
}
