import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import speech_recognition as sr


class my_node(Node):
    def __init__(self):
        super().__init__("publisher_node")
        self.count = 0
        self.final_command=''
        self.my_publisher = self.create_publisher(String,'/custom_topic/command',10)
        self.create_timer(2,self.listen_command)
        self.r=sr.Recognizer()
    
    def listen_command(self):
        try:
            with sr.Microphone() as source2:
                self.r.adjust_for_ambient_noise(source2,duration=0.2)
                cust_audio = self.r.listen(source2)
                final_command = self.r.recognize_google(cust_audio)
                final_command = final_command.lower()
                msg = String()
                msg.data = final_command
                self.my_publisher.publish(msg)
        except sr.UnknownValueError:
            pass
        except sr.RequestError:
            pass
        except sr.WaitTimeoutError:
            pass

def main(args=None):
    rclpy.init(args=args)
    cust_node = my_node()
    rclpy.spin(cust_node)
    rclpy.shutdown()

if __name__=='__main__':
    main()