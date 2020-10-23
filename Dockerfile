FROM alphacep/kaldi-vosk-server:latest

RUN \
   mkdir /opt/kaldi-en \
   && cd /opt/kaldi-en \
   && wget -q https://goofy.zamia.org/zamia-speech/asr-models/kaldi-generic-en-tdnn_fl-r20190609.tar.xz \
   && tar xf kaldi-generic-en-tdnn_fl-r20190609.tar.xz \
   && mkdir -p model/ivector \
   && mv kaldi-generic-en-tdnn_fl-r20190609/extractor/final.* model/ivector \
   && mv kaldi-generic-en-tdnn_fl-r20190609/extractor/global_cmvn.stats model/ivector \
   && mv kaldi-generic-en-tdnn_fl-r20190609/ivectors_test_hires/conf/online_cmvn.conf model/ivector \
   && mv kaldi-generic-en-tdnn_fl-r20190609/ivectors_test_hires/conf/splice.conf model/ivector \
   \
   && mv kaldi-generic-en-tdnn_fl-r20190609/conf/mfcc_hires.conf model/mfcc.conf \
   && mv kaldi-generic-en-tdnn_fl-r20190609/model/final.mdl model \
   && mv kaldi-generic-en-tdnn_fl-r20190609/model/graph/HCLG.fst model \
   && mv kaldi-generic-en-tdnn_fl-r20190609/model/graph/words.txt model \
   && mv kaldi-generic-en-tdnn_fl-r20190609/model/graph/phones/word_boundary.int model \
   \
   && rm -rf kaldi-generic-en-tdnn_fl-r20190609 \
   && rm -rf kaldi-generic-en-tdnn_fl-r20190609.tar.xz

EXPOSE 2700
WORKDIR /opt/vosk-server/websocket
ENV VOSK_SAMPLE_RATE 16000
CMD [ "python3", "./asr_server.py", "/opt/kaldi-en/model" ]