class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :destroy]
  before_action :authenticate_user!

  def index
    @conversations = Conversation.involving(current_user)
  end

  def create
    @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first_or_create(conversation_params)
    redirect_to conversation_messages_path(@conversation)
  end

  def destroy
    @conversation.destroy
    redirect_to conversations_url, notice: "Conversation Deleted!"
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
