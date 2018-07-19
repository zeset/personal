#ifndef NET
#define NET

#include <string.h>
#include <omnetpp.h>
#include <packet_m.h>
#include <algorithm>
#include <vector>

using namespace omnetpp;

class Net: public cSimpleModule {
private:
    cOutVector hopCount;
    Packet ** copies;
    std::vector<int> neighbours[57];
    int neighbours_top[57];
public:
    Net();
    virtual ~Net();
protected:
    virtual void initialize();
    virtual void finish();
    virtual void handleMessage(cMessage *msg);
};

Define_Module(Net);

#endif /* NET */

Net::Net() {
}

Net::~Net() {
}

void Net::initialize() {
    hopCount.setName("Hop Count");
    copies = new Packet*[4];

    for (int i = 0; i < 57; i++) {
        std::vector<int> vec;
        neighbours[i] = vec;
        neighbours_top[i] = 0;
    }
}

void Net::finish() {
}

void Net::handleMessage(cMessage *msg) {

    // All msg (events) on net are packets
    Packet *pkt = (Packet *) msg;

    // If this node is the final destination, send to App
    if (pkt->getDestination() == this->getParentModule()->getIndex()) {
        hopCount.record(pkt->getHopCount());
        neighbours[pkt->getSource()].push_back(pkt->getSeqNum());
        send(pkt, "toApp$o");

    }
    // If not, forward the packet to some else... to who?
    else {
        // We send to link interface #0, which is the
        // one connected to the clockwise side of the ring
        // Is this the best choice? are there others?
        int origin = pkt->getSource();
        int k = neighbours_top[origin];
        int seq = pkt->getSeqNum();

        if (std::find(neighbours[origin].begin(), 
            neighbours[origin].end(),
            seq)!=neighbours[origin].end()
            || seq <= k) {

            delete pkt;
        } else {
            if (seq == k+1) {
                neighbours_top[origin] = k + 1;
            } else {
                neighbours[origin].push_back(seq);
            }

            copies[0] = pkt->dup();
            copies[1] = pkt->dup();
            copies[2] = pkt->dup();
            copies[3] = pkt->dup();

            for (int i = 0; i < 2; i++) {
                if (i == pkt->getSLink()) {
                    delete copies[i];
                    continue;
                } else {
                    copies[i]->setHopCount(copies[i]->getHopCount() + 1);
                    send(copies[i], "toLnk$o", i);
                }
            }
        }
    }
}
