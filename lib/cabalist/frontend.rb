require 'haml'
require 'kaminari/sinatra'
require 'padrino-helpers'
require 'sinatra/base'

module Cabalist
  class Frontend < Sinatra::Base
    
    PER_PAGE ||= 25
    
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
      @collection = klass::page(page).per(PER_PAGE)
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
      @collection = klass::not_classified \
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
      @collection = klass::manually_classified \
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
      @collection = klass::auto_classified. \
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
    
  end
end
