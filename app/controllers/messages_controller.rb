class MessagesController < ApplicationController
  def index
    # messagesテーブルからすべてのレコードを取得
    @messages = Message.all
    # 空のメッセージオブジェクトを生成
    @message = Message.new
  end
  
  def create
    # Messageモデルのインスタンス作成
    # 引数：formにて入力された:name, :body（ハッシュ）
    @message = Message.new(message_params)
    # MessageモデルのインスタンスをDBに保存(保存できない場合はfalseを返す)
    if @message.save
      redirect_to root_path , notice: 'メッセージを保存しました'
    else
      #メッセージが保存できなかった時
      @messages = Message.all
      #アラートを表示（現在のアクションのみ）
      flash.now[:alert] = "メッセージの保存に失敗しました"
      render 'index'
    end
  end

  # ここから下はprivateメソッド
  private
  def message_params
    # params[:message]のパラメータで name , bodyのみを許可
    # 返り値は ex:) {name: "入力されたname" , body: "入力されたbody" }
    # 許可されたパラメータ以外が渡された場合の挙動は？--デフォルトでは無視。
    params.require(:message).permit(:name, :body)
  end
end