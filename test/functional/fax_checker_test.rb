require 'test_helper'
require 'mail'

require 'fax_checker'

class FaxCheckerTest < ActionMailer::TestCase

  test "waiting" do
    mail = Mail.read('test/fixtures/mails/waiting.eml')
    status = OVHFaxChecker.status mail
    resp = {
      :fax_id=>258,
      :campaign_id=>217,
      :date=>1359480306,
      :message=>"Processing",
      :code=>100,
      :ticket_id=>80437
    }
    assert_equal(resp, status)
  end

  test "memory" do
    mail = Mail.read('test/fixtures/mails/memory.eml')
    status = OVHFaxChecker.status mail
    resp = {
      :fax_id=>258,
      :campaign_id=>217,
      :date=>1359480344,
      :message=>"No answer from remote=20",
      :code=>100,
      :ticket_id=>80435
    }
    assert_equal(resp, status)
  end

  test "failed" do
    mail = Mail.read('test/fixtures/mails/failed.eml')
    status = OVHFaxChecker.status mail
    resp = {
      :fax_id=>258,
      :campaign_id=>217,
      :date=>1359482156,
      :message=>"No answer from remote ; too many attempts to d=",
      :code=>500,
      :ticket_id=>80435
    }
    assert_equal(resp, status)
  end

  test "completed" do
    mail = Mail.read('test/fixtures/mails/completed.eml')
    status = OVHFaxChecker.status mail
    resp = {
      :fax_id=>258,
      :campaign_id=>217,
      :date=>1359480380,
      :message=>nil,
      :code=>200,
      :ticket_id=>80436
    }
    assert_equal(resp, status)
  end

end
