module Support::Capybara
  def self.capybara_running?
    Capybara.current_session.driver.browser_initialized?
  end

  def self.upload_screenshot
    image_path = Capybara.save_screenshot
    filename = image_path.split('/').last
    response = `curl https://uguu.se/api.php?d=upload -F file=@#{image_path}`
    remote_url = response[/(http[^"]*#{filename})/]
    puts "Capybara screenshot available at #{remote_url}"
  end
end
