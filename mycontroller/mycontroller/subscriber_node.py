import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from geometry_msgs.msg import Twist
import time
import re

class subscriber_node(Node):
    def __init__(self):
        super().__init__("subscriber_node")
        self.my_subscriber = self.create_subscription(String,'/custom_topic/command',self.subscriber_callback,10)
        self.my_publisher = self.create_publisher(Twist,'/cmd_vel',10)
        self.energy = 0
    def subscriber_callback(self,msg):
        if self.energy > 0:
            transform = Twist()
            self.get_logger().info(msg.data)
            command = msg.data
            if "left" in command:
                transform.angular.z = 0.5
                self.my_publisher.publish(transform)
                time.sleep(3)
                self.energy -= 10
                transform.angular.z = 0.0
                self.my_publisher.publish(transform)
            elif "right" in command:
                transform.angular.z = -0.5
                self.my_publisher.publish(transform)
                time.sleep(3)
                self.energy -= 10
                transform.angular.z = 0.0
                self.my_publisher.publish(transform)
            elif "heal" in command:
                self.energy += 10
                self.get_logger().info(str(self.energy))
            elif "kaboom" in command:
                self.energy += 30
                self.get_logger().info(str(self.energy))
            if "forward" in command:
                number=2
                if "seconds" in command or "second" in command:
                    input_number = re.search(r'\d+', command)
                    if input_number:
                        number = int(input_number.group())
                    else:
                        number = 2 
                    
                transform.linear.x = 1.0
                self.my_publisher.publish(transform)
                time.sleep(number)
                self.energy -= 10
                transform.linear.x = 0.0
                self.my_publisher.publish(transform)
                        # if char.isdigit():
                        #     number = int(char)
                        #     transform.linear.x = 1.0
                        #     self.my_publisher.publish(transform)
                        #     time.sleep(number)
                        #     transform.linear.x = 0.0
                        #     self.my_publisher.publish(transform)
                        # else:
                        #     transform.linear.x = 1.0
                        #     self.my_publisher.publish(transform)
                        #     time.sleep(2)
                        #     transform.linear.x = 0.0
                        #     self.my_publisher.publish(transform)
            else:
                # transform.linear.x = 1.0
                # self.my_publisher.publish(transform)
                # time.sleep(2)
                transform.linear.x = 0.0
                self.my_publisher.publish(transform)
        else:
            command = msg.data
            if "heal" in command:
                self.energy += 10
                self.get_logger().info(str(self.energy))
            elif "kaboom" in command:
                self.energy += 30
                self.get_logger().info(str(self.energy))
            else:
                self.get_logger().info("First heal me.")

def main(args=None):
    rclpy.init(args=args)
    my_node = subscriber_node()
    rclpy.spin(my_node)

if __name__=='__main__':
    main()