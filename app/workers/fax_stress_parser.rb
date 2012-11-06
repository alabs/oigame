class FaxStressParser

  @queue = :fax_stress_parser

  def self.perform
    Mail.defaults do
      retriever_method :pop3, :address => 'peta.alabs.es',
                              :port => 110,
                              :user_name => 'oigame-fax-status',
                              :password => 'elpass',
                              :enable_ssl => false
    end

    mails = Mail.all
    mails.each do |mail|
      # process_mail
    end
    # send_report
  end
end
