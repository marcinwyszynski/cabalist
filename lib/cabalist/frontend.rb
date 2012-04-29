require 'googlecharts'
require 'haml'
require 'kaminari/sinatra'
require 'padrino-helpers'
require 'sinatra/base'

module Cabalist
  
  # Provides a web frontend to models where Cabalist functionality has
  # been enabled.
  class Frontend < Sinatra::Base
    
    # Specifies how many records of a given class should be visible on a web
    # GUI page.
    PER_PAGE      = 25
    
    # Specifies basic options for the frontend charts to use
    CHART_OPTIONS = { :background      => '00000000',
                      :colors          => %w(6EB41E 608733 43750A 9AD952 ABD976) +
                                          %w(188D4B 286A45 085C2C 4AC680 6BC693) +
                                          %w(AFC220 879136 707E0A D0E054 D4E07A),
                      :format          => 'image_tag',
                      :legend_position => 'bottom',
                      :size            => '400x300' }
    
    helpers do
      
      def piechart_by_class_variable(klass)
        data, labels = [], []
        variable_name = klass::get_class_variable_name
        klass::all.group_by(&variable_name).each do |k,v|
          label = k.nil? ? 'n/a' : k.to_s
          count = v.count
          labels << "#{label} (#{count})"
          data   << count
        end
        Gchart::pie({ :bar_colors => CHART_OPTIONS[:colors][0...labels.size],
                      :data       => data,
                      :legend     => labels,
                      :title      => "Breakdown by #{variable_name.to_s}" }.merge(CHART_OPTIONS))
      end
      
      def piechart_by_scope(klass)
        data, labels = [], []
        [:manually_classified, :auto_classified, :not_classified].each do |s|
          count = klass::send(s).count
          labels << "#{s.to_s.humanize} (#{count})"
          data   << count
        end
        Gchart::pie({ :bar_colors => CHART_OPTIONS[:colors][0...labels.size],
                      :data       => data,
                      :legend     => labels,
                      :title      => "Breakdown by classification method" }.merge(CHART_OPTIONS))
      end
      
    end
    
    before do
      @classes  = Cabalist::Configuration.instance.frontend_classes
      @app_name = begin
        ::Rails.root.to_s.split('/').last.humanize.titlecase
      rescue
        'Test Rails Application'
      end
    end
    
    # Index page, shows a dashboard and links to classifiers.
    get '/' do
      haml :index
    end
    
    # List all (classified and non-classified) records for <class_name>.
    get "/:class_name/all/?:page?" do
      page = params[:page].to_i < 1 ? 1 : params[:page].to_i
      klass = params[:class_name].titleize.constantize
      @collection = klass::order("id DESC").page(page).per(PER_PAGE)
      haml :classifier, 
           :locals => { :klass => klass,
                        :page  => page,
                        :scope => 'all',
                        :total => klass.count }
    end

    # List non-classified records for <class_name>.
    get "/:class_name/none/?:page?" do
      klass = params[:class_name].titleize.constantize
      page = params[:page].to_i < 1 ? 1 : params[:page].to_i
      @collection = klass::not_classified.order("id DESC") \
                    .page(page).per(PER_PAGE)
      haml :classifier, 
           :locals => { :klass => klass,
                        :page  => page,
                        :scope => 'none',
                        :total => klass::not_classified.count }
    end

    # List manually classified records for <class_name>
    get "/:class_name/manual/?:page?" do
      klass = params[:class_name].titleize.constantize
      page = params[:page].to_i < 1 ? 1 : params[:page].to_i
      @collection = klass::manually_classified.order("id DESC") \
                    .page(page).per(PER_PAGE)
      haml :classifier, 
           :locals => { :klass => klass,
                        :page  => page,
                        :scope => 'manual',
                        :total => klass::manually_classified.count }
    end
    
    # List automatically classified records for <class_name>
    get "/:class_name/auto/?:page?" do
      klass = params[:class_name].titleize.constantize
      page = params[:page].to_i < 1 ? 1 : params[:page].to_i
      @collection = klass::auto_classified.order("autoclassified_at DESC"). \
                    page(page).per(PER_PAGE)
      haml :classifier, 
           :locals => { :klass => klass,
                        :page  => page,
                        :scope => 'auto',
                        :total => klass::auto_classified.count }
    end
    
    # Set the value of class variable for an object
    # of <class_name> with ID <id>
    post "/:class_name/teach/:id" do
      klass = params[:class_name].titleize.constantize
      obj = klass::find(params[:id])
      if params[:classification_freeform].empty?
        new_class = params[:classification]
      else
        new_class = params[:classification_freeform]
      end
      obj.teach(new_class)
      if obj.save
        redirect back
      else
        'failure'
      end
    end
    
    # Automatically classify the object of class
    # <class_name> with ID <id>
    post "/:class_name/autoclassify/:id" do
      klass = params[:class_name].titleize.constantize
      obj = klass::find(params[:id])
      obj.save if obj.classify!
      redirect back
    end
    
    # Rebuild the model used for classification
    post "/:class_name/retrain" do
      klass = params[:class_name].titleize.constantize
      klass::train_model
      redirect back
    end
    
  end
end
