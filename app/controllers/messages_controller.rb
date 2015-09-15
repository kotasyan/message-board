class MessagesController < ApplicationController
  #edit,update,destroyアクションの前に、set_messageメソッドで対象レコードを取得
  before_action :set_message, only: [:edit, :update, :destroy]
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
  
  def edit
  end

  def update
    # @messageを更新
    if @message.update(message_params)
      # 保存に成功した場合は、トップページへリダイレクト
      redirect_to root_path, notice: 'メッセージを編集しました'
    else
      # 保存に失敗した場合は、編集画面へ戻す
      render 'edit'
    end
  end
  
  def destroy
    @message.destroy
    redirect_to root_path, notice: 'メッセージを削除しました'
  end
      
  # ここから下はprivateメソッド
  private
  def message_params
    # params[:message]のパラメータで name , bodyのみを許可
    # 返り値は ex:) {name: "入力されたname" , body: "入力されたbody" }
    # 許可されたパラメータ以外が渡された場合の挙動は？--デフォルトでは無視。
    params.require(:message).permit(:name, :body)
  end
  
  def set_message
    # Messageデータベースからデータを検索
    @message = Message.find(params[:id])
  end
end