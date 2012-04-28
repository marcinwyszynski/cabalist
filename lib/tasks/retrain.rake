namespace :cabalist do
  
  desc 'Retrain a Cabalist model'
  task :retrain, [:model] => :environment do |t, args|
    unless args.model
      puts "Usage: rake cabalist:retrain[<CLASS NAME>]"
    else
      begin
        args.model.constantize.train_model
      rescue Exception => e
        puts "Could not retrain the classifier"
        puts "Possibly the class is not Cabalist-enabled?"
        puts "Anyway, here is your stack trace:"
        puts e.backtrace
      else
        puts "Classifier retrained successfully"
      end
    end
  end
  
end