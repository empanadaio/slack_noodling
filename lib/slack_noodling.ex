defmodule SlackNoodling do

  alias SlackNoodling.CommandedApp
  alias SlackNoodling.BsCommand

  def send_bs_command(message) do
    command = %BsCommand{
      bs_id: Ecto.UUID.generate,
      message: message
    }
    CommandedApp.dispatch(command)
  end
end
