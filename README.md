
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


   ```sh
   $ ffplay -i http://192.168.1.44:50004
   ```

1. クライアントのプレーヤーのMIDI Outを接続先のものにして、再生すると ffplay から音が聞こえるはず
