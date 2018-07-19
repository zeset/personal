#ifndef TRANSPORTTX
#define TRANSPORTTX

#include <string.h>
#include <omnetpp.h>
#include <FeedbackPacket.h>
#include <iostream>

using namespace omnetpp;

class TransportTx: public cSimpleModule {
private:
    int tPackets;
    cQueue buffer;
    cMessage *endServiceEvent;
    simtime_t serviceTime;
    cOutVector bufferSizeVector;
    cOutVector packetDropVector;
    int dropped;
    int window;
    int acks_count;
public:
    TransportTx();
    virtual ~TransportTx();
protected:
    virtual void initialize();
    virtual void finish();
    virtual void handleMessage(cMessage *msg);
};

Define_Module(TransportTx);


TransportTx::TransportTx() {
    endServiceEvent = NULL;
}

TransportTx::~TransportTx() {
    cancelAndDelete(endServiceEvent);
}

void TransportTx::initialize() {
    buffer.setName("buffer");
    endServiceEvent = new cMessage("endService");
    tPackets = 0;
    window = 1;
    acks_count = 0;
    dropped = 0;
}

void TransportTx::finish() {
}

void TransportTx::handleMessage(cMessage *msg) {

    //msg is a packet
    if (strcmp(msg->getName(), "ACK") == 0){
        // msg is an ACK

        //Do something with the feedback info
        FeedbackPacket *feedbackpkt = (FeedbackPacket*)msg;
        int remainingBuffer = feedbackpkt->getRemainingBuffer();
        
        // increment counter
        acks_count++;

        // double the window and reset counters if all acks were found
        if (acks_count == window) {
          window = window*2;
          acks_count = 0;
          std::cout << "VENTANA INCREMENDA A: " << window << endl;
        }

        delete (msg);
    } else if (strcmp(msg->getName(), "LOST") == 0){
        // msg is about a packet being lost or dropped
        std::cout << "PAQUETE PERDIDO: " << window << endl;

        // resize window
        if (window > 1) {
          window = window / 2;  
          acks_count = 0;
          std::cout << "VENTANA DECREMENTADA A: " << window << endl;
        }
        buffer.clear();
        delete (msg);
    } else  {
        // if msg is signaling an endServiceEvent
        if (msg == endServiceEvent) {
          // if packet in buffer, send next one
          if (!buffer.isEmpty()) {
             // dequeue packet
             cPacket *pkt = (cPacket*) buffer.pop();
             // send packet
             send(pkt, "toOut$o");

             // start new service
             ++tPackets;
             bufferSizeVector.record(tPackets);
             serviceTime = pkt->getDuration();
             scheduleAt(simTime() + serviceTime, endServiceEvent);
          }
        // check buffer limit
        } else if (buffer.getLength() >= par("bufferSize").longValue()) {
          //drop the packet

          delete msg;
          this->bubble("packet dropped");
          ++dropped;
          packetDropVector.record(dropped);
        // if msg is a data packet
        } else {
            // enqueue the packet
            buffer.insert(msg);
            bufferSizeVector.record(buffer.getLength());
            // if the server is idle
            if (!endServiceEvent->isScheduled()) {
                // start the service
                scheduleAt(simTime() + 0, endServiceEvent);
            }
        }
        
    } 

}

#endif /* TRANSPORTTX */
