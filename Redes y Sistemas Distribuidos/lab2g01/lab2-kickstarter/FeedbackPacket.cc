#include <string.h>
#include <omnetpp.h>
#include <FeedbackPacket.h>

using namespace omnetpp;

FeedbackPacket::FeedbackPacket(const char*){

}

FeedbackPacket::~FeedbackPacket(){
    
}

void FeedbackPacket::initialize() {
    remainingBuffer = 0;
    feedbackpkt.setName("MsgFeedback");
}

void FeedbackPacket::setRemainingBuffer(int size) {	
    remainingBuffer = size;
}

int FeedbackPacket::getRemainingBuffer() {
    return(remainingBuffer);
}

void FeedbackPacket::setReceivedPackets(int counter){
    fPackets = counter;
}
