defmodule KM.HomeModels do
  defmacro __using__(_attrs) do
    quote do
      #   alias KM.HomeModels.Filter
      alias KM.HomeModels.Form
    end
  end
end
