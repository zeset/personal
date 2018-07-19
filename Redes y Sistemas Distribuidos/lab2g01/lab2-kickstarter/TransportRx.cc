#ifndef TRANSPORTRX
#define TRANSPORTRX

#include <string.h>
#include <omnetpp.h>
#include <FeedbackPacket.h>
#include <iostream>


using namespace omnetpp;

class TransportRx: public cSimpleModule {
private:
    int rPackets;
    int dPackets;
    cQueue buffer;
    cMessage *endServiceEvent;
    simtime_t serviceTime;
    cOutVector bufferSizeVector;
    cOutVector packetDropVector;
    cOutVector packetReceivedVector;
    cPacket feedbackPkt;
public:
    TransportRx();
    virtual ~TransportRx();
protected:
    virtual void initialize();
    virtual void finish();
    virtual void handleMessage(cMessage *msg);
};

Define_Module(TransportRx);

TransportRx::TransportRx() {
    endServiceEvent = NULL;
}

TransportRx::~TransportRx() {
    cancelAndDelete(endServiceEvent);
}

void TransportRx::initialize() {
    buffer.setName("buffer");
    endServiceEvent = new cMessage("endService");
    rPackets = 0;
    dPackets = 0;
    packetDropVector.setName("Packages dropped by Rx");
    packetReceivedVector.setName("Packages received by Rx");
}

void TransportRx::finish() {
}

void TransportRx::handleMessage(cMessage *msg) {

    // if msg is signaling an endServiceEvent
    if (msg == endServiceEvent) {
        // if packet in buffer, send next one
        if (!buffer.isEmpty()) {
            // dequeue packet
            cPacket *pkt = (cPacket*) buffer.pop();

            if ((strcmp(pkt->getName(), "LOST") == 0) ||
                (strcmp(pkt->getName(), "ACK") == 0)) {
                send(pkt, "toOut$o");
            } else {
                // send pkt
                send(pkt, "toApp");
            }
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
        feedbackPkt->setReceivedPackets(rPackets);
        buffer.insert(feedbackPkt);
        bufferSizeVector.record(buffer.getLength());

        std::cout << "PAQUETE PERDIDO EN BUFFER RX" << endl;

        delete msg;
        this->bubble("packet dropped");
        ++dPackets;
        packetDropVector.record(dPackets);
    } else {
        // enqueue the packet    

        buffer.insert(msg);

        FeedbackPacket *feedbackPkt;
        feedbackPkt = new FeedbackPacket("ACK");
        feedbackPkt->setName("ACK");
        feedbackPkt->setByteLength(20);
        feedbackPkt->setKind(0);
        feedbackPkt->setRemainingBuffer((par("bufferSize").longValue() - buffer.getLength()));
        feedbackPkt->setReceivedPackets(rPackets);
        buffer.insert(feedbackPkt);
        bufferSizeVector.record(buffer.getLength());
        // if the server is idle
        ++rPackets;
        packetReceivedVector.record(rPackets);
        if (!endServiceEvent->isScheduled()) {
            // start the service
            scheduleAt(simTime() + 0, endServiceEvent);
        }

    }
}

#endif /* TRANSPORTRX */
