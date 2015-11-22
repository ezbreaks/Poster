class ConnectionsController < ApplicationController
  before_action :set_connection, only: [:destroy]

  def create
    connection = current_user.connections.create_from_omniauth(auth_hash)
    if connection.save
      redirect_to dashboard_path, notice: 'Connection Created'
    else
      redirect_to dashboard_path, notice: 'Something went wrong'
    end
  end

  def destroy
    # @connection = Connection.find(params[:id])
    if @connection.present?
      @connection.destroy
    end
    redirect_to dashboard_path, notice: 'Connection deleted'
  end

  private

  def set_connection
    @connection = Connection.find(params[:id])
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
