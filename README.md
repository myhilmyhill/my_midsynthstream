
クライアント rtpmidi -> ホスト rtpmidid -> ホスト ffmpeg -> クライアント ffplay

1. クライアント側の rtpmidi のセットアップをする。
1. ホストに MIDI デバイスを接続する。

   `aconnect -l` などで目的のがあるか確認
1. ホストの音声ライン入力などに、シーケンサーからの出力をつなぐ

   `arecord -lL` で入力があるか見て、 `arecord`, `aplay` とかで鳴るか確認
1. ホストで `docker compose up` する
1. ホストの標準出力を見ながら、いい頃合いにクライアント側の rtpmidi を接続する。
   mDNS はあてにしていないので、IPアドレス直指定か別途名前解決できる仕組みがいいと思う
1. streamer が up できたら、その標準出力からクライアントで sdp を作って ffplay で読み込むと再生できる

   ```sdp.sdp
   v=0
   o=- 0 0 IN IP4 127.0.0.1
   s=No Name
   c=IN IP4 192.168.1.34
   t=0 0
   a=tool:libavformat 61.7.100
   m=audio 8888 RTP/AVP 10
   b=AS:1411
   a=rtpmap:10 L16/44100/2
   ```

   ```sh
   $ ffplay -protocol_whitelist "file,rtp,udp" sdp.sdp
   ```

1. クライアントのプレーヤーのMIDI Outを接続先のものにして、再生すると ffplay から音が聞こえるはず
