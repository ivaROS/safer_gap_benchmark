#!/usr/bin/env python3

import rospy
from std_msgs.msg import String
from geometry_msgs.msg import Twist

class DummyStopPub():
    def __init__(self):
        self.publisher = rospy.Publisher('/dummy_stop_cmd', Twist, queue_size=10)
        self.rate = rospy.Rate(10)

    def pub(self):
        while not rospy.is_shutdown():
            if self.publisher.get_num_connections() == 0:
                rospy.logwarn("Waiting for subscriber to connect to {}".format(self.publisher.name))
            else:
                cmd = Twist()
                rospy.loginfo("Publish zero velocities.")
                self.publisher.publish(cmd)
            self.rate.sleep()

if __name__=="__main__":
    rospy.init_node('dummy_stop_cmd')

    d = DummyStopPub()

    try:
        d.pub()
    except rospy.ROSInterruptException:
        pass