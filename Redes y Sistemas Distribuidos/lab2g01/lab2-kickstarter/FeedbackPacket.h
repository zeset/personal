#ifndef TRANSPORTTX_H_
#define TRANSPORTTX_H_


class FeedbackPacket: public omnetpp::cPacket {
private:
	cPacket feedbackpkt;
    int remainingBuffer;
    int fPackets;
protected:
    virtual void initialize();
public:
    FeedbackPacket(const char*);
    virtual ~FeedbackPacket();
    virtual void setRemainingBuffer(int size);
    virtual int getRemainingBuffer();
    virtual void setReceivedPackets(int counter);
};

#endif /* FeedbackPacket*/
