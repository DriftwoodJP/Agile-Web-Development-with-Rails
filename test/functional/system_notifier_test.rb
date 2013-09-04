require 'test_helper'

class SystemNotifierTest < ActionMailer::TestCase
  test "error_occured" do
    # エラーをどうやって起こすのか？
    # error = "Couldn't find Cart with id=wibble"
    # mail = SystemNotifier.error_occured(error)
    # assert_equal "Depot App Error Incident", mail.subject
    # assert_equal ["Sam Ruby <depot@example.com>"], mail.to
    # assert_equal ["system@example.com"], mail.from
    # assert_match "Error details", mail.body.encoded
  end

end
