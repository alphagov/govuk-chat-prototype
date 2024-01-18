class ChatsController < ApplicationController
  def index
    # rubocop:disable Naming/VariableName
    @excludeJS = true
    # rubocop:enable Naming/VariableName
  end

  def onboarding
    # rubocop:disable Naming/VariableName
    @excludeJS = true
    # rubocop:enable Naming/VariableName
  end

  def new
    @uuid = params[:uuid] || SecureRandom.uuid
    @chats = Chat.where(uuid: @uuid).order(id: :asc) || Chat.new(uuid: @uuid)
  end

  def create
    @chat = Chat.new(chat_params)

    if params[:js_enabled] == "true"
      @chat.reply = ChatApi.fetch(@chat.uuid, @chat.prompt)
      if @chat.save
        redirect_to new_chat_path(uuid: @chat.uuid)
      end
    else
      current_chat_record_count = record_count(@chat.uuid)
      BackgroundApiCallJob.perform_later(@chat.uuid, @chat.prompt, current_chat_record_count)
      render "refresh", locals: { uuid: @chat.uuid, current_chat_record_count:, page_refreshed: true }
    end
  end

  def refresh
    @uuid = params[:uuid]
    @count = params[:count]

    current_chat_record_count = record_count(@uuid)

    if current_chat_record_count > @count.to_i
      redirect_to new_chat_path(uuid: @uuid)
    else
      render "refresh", locals: { uuid: @uuid, current_chat_record_count:, page_refreshed: true }
    end
  end

private

  def chat_params
    params.require(:chat).permit(:uuid, :prompt, :reply)
  end

  def record_count(uuid)
    Chat.where(uuid:).count
  end
end
