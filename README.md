# Voice Controlled Bot

Depenedencies:
* rclpy
* std_msgs
* geometry_msgs
* SpeechRecognition
* re
* pyttsx3

## Build Docker image
There is a docker file in the root of the project. Change directory to the root of the project and open Command Prompt there. Type:

``` docker build -t <name> .```

Run it:

``` docker run -it --rm <name> --name <container>```

Since there is no launch file we have to use three terminals attach them to the docker container:

```docker exec -it <container> bash```

Run these three commands in three terminals:

```ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py```

```ros2 run mycontroller publisher_node```

```ros2 run mycontroller subsriber_node```

And finally give the commands and let the bot do the work.
