require 'rubygems'
require 'pakyow'

module PakyowApplication
  class Application < Pakyow::Application
    config.app.default_environment = :development
  
    configure(:development) do
    end
    
    routes do
      default :ApplicationController, :index

      get '/:cn/on' do
        presenter.use_view_path request.params[:cn]
        presenter.view.title = request.params[:cn]
        presenter.view.find(".chart").repeat_for(chart_data, {:to=>'chart'}) do |d|
          context.find('.bar').repeat_for(d[:bars], {:to=>'bar'})
        end
        presenter.view.bind({:off => {:href=>"/#{request.params[:cn]}", :content=>'Without backend'}}, {:to=>:be})
      end

    end

    def chart_data
      scale = 10
      [
          build_data_hash('Bozo', [1,40,20,23,52,34,21], scale),
          build_data_hash('Cookie', [4,20,23,30,34,21], scale),
          build_data_hash('Oliver', [23,24,25,26,27,36], scale)
      ]
    end

    def build_data_hash(label, values, scale)
      {
          :label => label,
          :bars => values.collect! { |v| {:value => {:content => v, :style => "width: #{v*scale}px"}} }
      }
    end

    middleware do
    end
  end
end
