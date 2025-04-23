class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :destroy]
  before_action :authenticate_user!

  def index
    @conversations = Conversation.involving(current_user)
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create(conversation_params)
    end

    redirect_to conversation_messages_path(@conversation)
  end

  def destroy
    @conversation.destroy
    redirect_to conversations_url

    # @conversation = Conversation.find(params[:id])
    # @recipent = @conversation.recipent

    # @conversation.destroy
    # @conversations = Conversation.where(recipient_id: @recipent.id)

    respond_to :js
    redirect_back(fallback_location: request.referer, notice: "Conversation Deleted!")
  end

  private
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end
    
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end
end