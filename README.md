# Card e-Binder

カードコレクター向けの、トレーディングカードを整理できるサイトです。<br>
トレカを集めるのが趣味の友人とカードショップへ行った時に、スマホのメモ帳で買いたいカードを管理していたのを見て、トレカ情報を管理できるWebアプリがあれば快適になると思い、このアプリを作成しました。<br>
このアプリでは、カードリストを作成して、そのカードリストにカードを登録することができます。<br>
自分の集めているカードの情報をこのアプリで整理しましょう。<br>
また、スマホでもご覧いただけるようレスポンシブ対応もしているので、トレカショップでお買い物の際は是非お使いください。

<img width="1512" alt="Top" src="https://user-images.githubusercontent.com/75765095/234252339-6c21b46b-8e74-4139-aa62-bdde68891452.png">

<img width="572" alt="スマホサイズトップ画面" src="https://user-images.githubusercontent.com/75765095/235911611-252eb27c-0239-456d-81bf-c65c435b5856.png">

# URL
https://card-e-binder.herokuapp.com/<br>
ヘッダーのゲストログインボタンよりゲストユーザーでログインできます。<br>
ゲストユーザーにはテストデータを投入済みですので、ご試用ください。

# 使用技術
## フロントエンド
- HTML
- SCSS
- Javascript
## バックエンド
- Ruby 3.1.3
- Ruby on Rails 7.0.4.3
- PostgreSQL 15.2
## インフラ
- Heroku
- Amazon S3
## その他
- RSpec(テストフレームワーク)
- Rubocop Airbnb（コーディングチェックツール）

# インフラ構成図
![インフラ構成図](https://user-images.githubusercontent.com/75765095/235909643-51c4ec4c-e9d5-4693-8aa3-63c868ba9f9e.png)

# ER図
<img width="739" alt="er図" src="https://user-images.githubusercontent.com/75765095/235910598-3934edef-9d5e-41b3-9fff-1fe5f713a6ab.png">

# 機能一覧
- ユーザー関連機能
  - 新規登録
  - ログイン
  - ログアウト
  - ゲストログイン

  deviseのGemを使用してユーザー登録、ログイン/ログアウト機能を実装しました。<br>
  ゲストログイン機能も実装しており、こちらは自分で実装しました。<br>
  ゲストユーザーのデータは、seeds.rbで投入しています。<br>
  なおユーザー削除機能は実装していないですが、万が一ゲストユーザーが消えてしまった場合を考慮して、ゲストユーザーがDBに存在すればそのユーザーで、存在しなければ新規作成してログインする仕様としました。
  
  <img width="1512" alt="ログイン" src="https://user-images.githubusercontent.com/75765095/236110044-9debb820-0dd4-496e-afde-378eb019bd7a.png">
  
  <img width="1512" alt="新規登録" src="https://user-images.githubusercontent.com/75765095/236110056-a78e74a4-620b-40d7-81e8-f9e09e937d6c.png">

- カードリスト関連機能
  - 新規作成
  - 一覧表示
  - 編集
  - 削除

  カードリストを新規作成できます。<br>
  ブースターやスターターのパッケージ毎、欲しいカードのリストなどお好きなように作成頂けます。<br>
  作成したカードリストは一覧表示が可能で、一覧画面より編集と削除が可能です。<br>
  一覧画面には、kaminariのGemを利用したページネーション機能と、自前で実装したソート機能を実装しています。
  
  <img width="1511" alt="カードリスト新規作成" src="https://user-images.githubusercontent.com/75765095/236109742-05b8e22f-9fc5-4bdc-a02e-e5ab2384a37f.png">
  
  <img width="1512" alt="カードリスト一覧" src="https://user-images.githubusercontent.com/75765095/236109760-e27d68c7-3451-4380-b2f4-ac6aaae50dd7.png">


- カード関連機能
  - 登録
  - 画像投稿
  - 一覧表示
  - 詳細表示
  - 編集
  - 削除
  - 検索

  作成したカードリストにカードを登録できます。<br>
  ActiveStorageのGemを使用し、AmazonS3と連携した画像投稿機能を実装しており、カード画像を投稿することができます。<br>
  カード画像はカード詳細画面で確認でき、コレクターのカードを眺めて楽しみたいというニーズに応えました。<br>
  登録したカードは、カード詳細画面から編集、削除が可能です。<br>
  また、カード検索も実装しており、デフォルトで全件表示、検索時はカード名で部分一致検索の仕様としています。<br>
  カード一覧およびカード検索では、カードリスト一覧同様ページネーションとソート機能を実装しています。<br>
  これにより必要なカード情報に素早くアクセスできます。
  
  <img width="1512" alt="カード登録" src="https://user-images.githubusercontent.com/75765095/236110767-0e446725-77f2-41a3-8c17-748a65b5d1dc.png">
  
  ![カード詳細](https://user-images.githubusercontent.com/75765095/236109221-4283d2f8-32b6-425e-af25-d5394f519e7c.png)
  
  <img width="1512" alt="カード一覧" src="https://user-images.githubusercontent.com/75765095/236110786-336a7d5f-5390-4236-9f9a-a73d41206947.png">
  
  <img width="1512" alt="カード検索" src="https://user-images.githubusercontent.com/75765095/236110801-3801dbbc-b527-4aa4-8bbc-8bf4e911a7e0.png">

- パンくずリスト

  gretelのGemを使用して、各画面にパンくずリストを実装しています。
