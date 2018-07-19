#ifndef QUEUE
#define QUEUE

#include <string.h>
#include <omnetpp.h>
#include <FeedbackPacket.h>

using namespace omnetpp;

class Queue: public cSimpleModule {
private:
    cQueue buffer;
    int dropped;
    cMessage *endServiceEvent;
    simtime_t serviceTime;
    cOutVector bufferSizeVector;
    cOutVector packetDropVector;
    cPacket feedbackPkt;
public:
    Queue();
    virtual ~Queue();
protected:
    virtual void initialize();
    virtual void finish();
    virtual void handleMessage(cMessage *msg);
};

Define_Module(Queue);

Queue::Queue() {
    endServiceEvent = NULL;
}

Queue::~Queue() {
    cancelAndDelete(endServiceEvent);
}

void Queue::initialize() {
    buffer.setName("buffer");
    endServiceEvent = new cMessage("endService");
    bufferSizeVector.setName("SizeVector");
    packetDropVector.setName("DropVector");
    packetDropVector.setMin(0);
    dropped = 0;
}

void Queue::finish() {
}

void Queue::handleMessage(cMessage *msg) {

    // if msg is signaling an endServiceEvent
    if (msg == endServiceEvent) {
        // if packet in buffer, send next one
        if (!buffer.isEmpty()) {
            // dequeue packet
            cPacket *pkt = (cPacket*) buffer.pop();
            // send packet
            send(pkt, "out");
            // start new service
            serviceTime = pkt->getDuration();
            scheduleAt(simTime() + serviceTime, endServiceEvent);
        }
    // check buffer limit
    } else if (buffer.getLength() >= par("bufferSize").longValue()) {
        //drop the packet
        FeedbackPacket *feedbackPkt;
        feedbackPkt = new FeedbackPacket("LOST");
        feedbackPkt->setName("LOST");   
        feedbackPkt->setByteLength(20);
        feedbackPkt->setKind(0);
        feedbackPkt->setRemainingBuffer((par("bufferSize").longValue() - buffer.getLength()));
        buffer.insert(feedbackPkt);
        bufferSizeVector.record(buffer.getLength());

        std::cout << "PAQUETE PERDIDO EN BUFFER RX" << endl;

        delete msg;
        ++dropped;
        packetDropVector.record(dropped);
        packetDropVector.getValuesReceived();
    } else { // if msg is a data packet
        // enqueue the packet
        buffer.insert(msg);
        bufferSizeVector.record(buffer.getLength());
        bufferSizeVector.getValuesReceived();
        // if the server is idle
        if (!endServiceEvent->isScheduled()) {
            // start the service
            scheduleAt(simTime() + 0, endServiceEvent);
        }
    }
}

#endif /* QUEUE */
