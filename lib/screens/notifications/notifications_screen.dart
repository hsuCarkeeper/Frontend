import 'package:flutter/material.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final String type; // 'trip', 'reminder', 'system'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String filter = 'all'; // 'all' or 'unread'

  final List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: '여행 출발 알림',
      message: '내일 제주도 여행이 시작됩니다. 준비물을 확인해주세요!',
      time: '2시간 전',
      type: 'trip',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: '체크리스트 완료',
      message: '부산 여행 체크리스트를 모두 완료했습니다.',
      time: '5시간 전',
      type: 'reminder',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: '새로운 기능 업데이트',
      message: '여행 일정 공유 기능이 추가되었습니다.',
      time: '1일 전',
      type: 'system',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: '여행 준비 리마인더',
      message: '강릉 여행까지 3일 남았습니다. 숙소 예약을 확인해주세요.',
      time: '2일 전',
      type: 'reminder',
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: '체크리스트 추가',
      message: '서울 여행에 새로운 항목이 추가되었습니다.',
      time: '3일 전',
      type: 'trip',
      isRead: true,
    ),
  ];

  List<NotificationItem> get filteredNotifications {
    if (filter == 'all') {
      return notifications;
    }
    return notifications.where((n) => !n.isRead).toList();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'trip':
        return Icons.location_on_outlined;
      case 'reminder':
        return Icons.alarm;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  Color getNotificationColor(String type) {
    switch (type) {
      case 'trip':
        return Colors.blue;
      case 'reminder':
        return Colors.orange;
      case 'system':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(title: '알림', showBack: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 필터 및 전체 읽음 처리
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => filter = 'all'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: filter == 'all'
                                  ? const Color(0xFF2E6BFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              '전체',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: filter == 'all'
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => filter = 'unread'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: filter == 'unread'
                                  ? const Color(0xFF2E6BFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  '읽지 않음',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: filter == 'unread'
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: -8,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Text(
                                        unreadCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (unreadCount > 0)
                    TextButton(
                      onPressed: markAllAsRead,
                      child: const Text(
                        '모두 읽음',
                        style: TextStyle(
                          color: Color(0xFF2E6BFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // 알림 목록
              if (filteredNotifications.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_off,
                            size: 32,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          filter == 'unread' ? '읽지 않은 알림이 없습니다' : '알림이 없습니다',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = filteredNotifications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => markAsRead(notification.id),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: notification.isRead
                                ? Colors.white
                                : const Color(0xFFF0F5FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: notification.isRead
                                  ? Colors.grey[200]!
                                  : const Color(0xFF2E6BFF).withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: getNotificationColor(notification.type)
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  getNotificationIcon(notification.type),
                                  size: 20,
                                  color:
                                      getNotificationColor(notification.type),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: notification.isRead
                                                  ? FontWeight.w500
                                                  : FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (!notification.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF2E6BFF),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification.message,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      notification.time,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/notifications'),
    );
  }
}
