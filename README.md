## Good Morninglory! ～ちゃんと起きれば朝顔が咲くアラームアプリ～
## ToDo
- [ ] APIキーべた書きなのを修正


### 特徴

- [x] 時間通りに起きられたかどうかで朝顔を成長させられる

    - [x] 目覚ましが鳴ってすぐ(15秒)起きたり(条件A)、スヌーズの回数が少ないと成長する(条件B)

      - ポイント変動

        - [x] A達成=>残り秒数×10 ポイント

        - [x] A失敗=>-10 ポイント

        - [x] B失敗（スヌーズ使用）=>1回ごとに-30 ポイント

        - [x] アプリ起動=>+1 ポイント

        - [x] アラーム未使用=>ポイント変動なし

        - [x] 3日連続でポイント-10以上減少=>ポイント>100なら100に、ポイント<=100なら0に

      - ポイントと朝顔の成長度合い

        ポイント < 0 => 枯れる

        0 <= ポイント < 100 =>枯れる前

        n × 100 <= ポイント < (n+1) × 100 => 花がn輪咲く

    - [x] すぐ起きなかったり、生活リズムが乱れると朝顔が枯れる

- [x] SQLiteでアラームや朝顔の成長を保存できる

- [ ] アラームを止めるときは朝顔に水をやる＝＞パズルっぽくすることで目覚めやすくする=>今後のアップデートで実装する

- [x] その地域の昼夜や天気を取得し、朝顔の世界に反映させる

- [x] 自分だけのアラームを保存できる

- ~~n分（30分程度）のタイマーを簡単に使える~~

- ~~※もし可能ならmp3をアラーム音にできる~~

### 使用技術

- SQLite

- 天気、位置情報の取得 => openweatherAPI

  

### 画面レイアウト

（ボトムナビゲーションバーを使う）

- [ ] メイン画面

  - [x] 中央に朝顔

  - [ ] プライバシーポリシー

- [x] アラーム画面

  - [x] アラームリスト

    - 要素＝＞時間、スヌーズの有無、パズルの有無

  - [x] 新規アラーム作成ボタン

    - [x] 時刻

    - [x] パズルの有無

    - [x] アラーム音

  - ~~タイマー作成ボタン~~

- [x] アラーム

  - [x] 停止ボタン

    - [x] 普通のボタン

    - [ ] パズル

  - [x] スヌーズボタン

  

===

## プライバシーポリシー

- URL

  https://zenn.dev/cmatsu/articles/3c747a0d68c6a4

  

===

  

### すとあ

朝の目覚めを助けてくれるアラームアプリです。

あなたが健康的に起きれば起きるほど朝顔が育っていき、花が咲きます！

起きた時に天気を教えてくれる機能もあります。

  

朝の目覚めを助けてくれるアラームアプリです！

直感的な操作でアラームの設定がしやすく、見やすいUIになっています。

アラーム音は3種類から選ぶことができ、スヌーズ機能で10分間二度寝することもできます。

アラームが鳴ってから止めるまでの時間が早いと朝顔が育っていき、最大5輪まで花が咲きます！

しかし、スヌーズを使ったり、不規則な生活リズムだと朝顔がしおれることもあります。

現在地の天気を教えてくれる機能もあるため、起きてからスムーズに朝の支度ができます。

  

===

  

### markdown

**Privacy Policy**

  

This privacy policy applies to the Good Morninglory! ～ちゃんと起きれば朝顔が咲くアラームアプリ～ app (hereby referred to as "Application") for mobile devices that was created by CMatsunaga (hereby referred to as "Service Provider") as an Ad Supported service. This service is intended for use "AS IS".

  

**Information Collection and Use**

  

The Application collects information when you download and use it. This information may include information such as

  

*   Your device's Internet Protocol address (e.g. IP address)

*   The pages of the Application that you visit, the time and date of your visit, the time spent on those pages

*   The time spent on the Application

*   The operating system you use on your mobile device

  

The Application does not gather precise information about the location of your mobile device.

  

The Application collects your device's location, which helps the Service Provider determine your approximate geographical location and make use of in below ways:

  

*   Geolocation Services: The Service Provider utilizes location data to provide features such as personalized content, relevant recommendations, and location-based services.

*   Analytics and Improvements: Aggregated and anonymized location data helps the Service Provider to analyze user behavior, identify trends, and improve the overall performance and functionality of the Application.

*   Third-Party Services: Periodically, the Service Provider may transmit anonymized location data to external services. These services assist them in enhancing the Application and optimizing their offerings.

  

The Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.

  

For a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy.

  

**Third Party Access**

  

Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.

  

Please note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:

  

*   [Google Play Services](https://www.google.com/policies/privacy/)

*   [AdMob](https://support.google.com/admob/answer/6128543?hl=en)

  

The Service Provider may disclose User Provided and Automatically Collected Information:

  

*   as required by law, such as to comply with a subpoena, or similar legal process;

*   when they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;

*   with their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.

  

**Opt-Out Rights**

  

You can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.

  

**Data Retention Policy**

  

The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at matunagachihiro@gmail.com and they will respond in a reasonable time.

  

**Children**

  

The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13.

  

The Application does not address anyone under the age of 13\. The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discover that a child under 13 has provided personal information, the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider (matunagachihiro@gmail.com) so that they will be able to take the necessary actions.

  

**Security**

  

The Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains.

  

**Changes**

  

This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.

  

This privacy policy is effective as of 2024-04-01

  

**Your Consent**

  

By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.

  

**Contact Us**

  

If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at matunagachihiro@gmail.com.

  
  

### preview

・Privacy Policy

This privacy policy applies to the Good Morninglory! ～ちゃんと起きれば朝顔が咲くアラームアプリ～ app (hereby referred to as "Application") for mobile devices that was created by CMatsunaga (hereby referred to as "Service Provider") as an Ad Supported service. This service is intended for use "AS IS".

  
  

・Information Collection and Use

The Application collects information when you download and use it. This information may include information such as

  

  ・Your device's Internet Protocol address (e.g. IP address)

  ・The pages of the Application that you visit, the time and date of your visit, the time   spent on those pages

  ・The time spent on the Application

  ・The operating system you use on your mobile device

  

The Application collects your device's location, which helps the Service Provider determine your approximate geographical location and make use of in below ways:

  

  ・Geolocation Services: The Service Provider utilizes location data to provide features such as personalized content, relevant recommendations, and location-based services.

  ・Analytics and Improvements: Aggregated and anonymized location data helps the Service Provider to analyze user behavior, identify trends, and improve the overall performance and functionality of the Application.

  ・Third-Party Services: Periodically, the Service Provider may transmit anonymized location data to external services. These services assist them in enhancing the Application and optimizing their offerings.

  

The Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.

  
  

For a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy.

  
  

・Third Party Access

Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.

  
  

Please note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:

  

  ・Google Play Services　　https://www.google.com/policies/privacy/

  ・AdMob　　https://support.google.com/admob/answer/6128543?hl=en

  

The Service Provider may disclose User Provided and Automatically Collected Information:

  

  ・as required by law, such as to comply with a subpoena, or similar legal process;

  ・when they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;

  ・with their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.

  

・Opt-Out Rights

You can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.

  
  

・Data Retention Policy

The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at matunagachihiro@gmail.com and they will respond in a reasonable time.

  
  

・Children

The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13.

  
  

The Application does not address anyone under the age of 13. The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discover that a child under 13 has provided personal information, the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider (matunagachihiro@gmail.com) so that they will be able to take the necessary actions.

  
  

・Security

The Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains.

  
  

・Changes

This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.

  
  

This privacy policy is effective as of 2024-04-01

  
  

・Your Consent

By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.

  
  

・Contact Us

If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at matunagachihiro@gmail.com.