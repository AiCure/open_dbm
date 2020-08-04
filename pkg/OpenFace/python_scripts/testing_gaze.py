import time

def main():

    import zmq
    port = "5000"

    context = zmq.Context()
    socket = context.socket(zmq.SUB)

    print "Collecting head pose updates..."

    socket.connect ("tcp://localhost:%s" % port)
    topic_filter = "GazeAngle:"
    socket.setsockopt(zmq.SUBSCRIBE, topic_filter)

    while True:
        head_pose = socket.recv()
        head_pose = head_pose[10:].split(',')
        X = float(head_pose[0])
        Y = float(head_pose[1])

        print 'Yaw: %.1f, Pitch: %.1f' % (X, Y)

        time.sleep(0.01)

if __name__ == '__main__':
    main()




