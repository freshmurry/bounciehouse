class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:index, :create, :destroy]

  def index
    if current_user == @conversation.sender || current_user == @conversation.recipient
      @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
      @messages = @conversation.messages.order("created_at DESC")
    else
      redirect_to conversations_path, alert: "You don't have permission to view this."
    end
  end

  def create
    @message = @conversation.messages.new(message_params)

    if current_user == @conversation.sender || current_user == @conversation.recipient
      if @message.save
        ActionCable.server.broadcast "conversation_#{@conversation.id}", message: render_message(@message)
        head :ok
      else
        flash[:alert] = "Message could not be sent."
      end
    else
      flash[:alert] = "You cannot send a message in this conversation."
    end

    redirect_back(fallback_location: conversations_path)
  end

  def destroy
    @message = @conversation.messages.find(params[:id])
    
    if @message.destroy
      flash[:notice] = "Message deleted successfully."
    else
      flash[:alert] = "Message could not be deleted."
    end

    redirect_back(fallback_location: conversations_path)
  end

  private

  def render_message(message)
    render(partial: 'messages/message', locals: { message: message })
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:context, :user_id)
  end
end
