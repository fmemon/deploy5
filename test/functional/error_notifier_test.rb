require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "errored" do
  
   begin
   Cart.find("wibble")
      raise ActiveRecord::RecordNotFound

 rescue ActiveRecord::RecordNotFound => e
   ErrorNotifier.errored(e).deliver
 end

   mail = ActionMailer::Base.deliveries.last
  
    assert_equal "App Errored", mail.subject
    assert_equal ["dave@example.org"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "Hello Admin", mail.body.encoded
  end

end
