require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'spec_helper.rb')

# encoding: UTF-8

describe APN::Device do
  
  describe 'token' do
    
    it 'should be unique scoped by app id' do
      d = APN::Device.first
      device = DeviceFactory.new(:token => d.token, :app_id => d.app_id)
      device.should_not be_valid
      device.errors['token'].should include('has already been taken')
      
      device = DeviceFactory.new(:token => device.token.succ, :app_id => d.app_id)
      device.should be_valid
    end
    
    it 'should get cleansed if it contains brackets' do
      token = DeviceFactory.random_token
      device = DeviceFactory.new(:token => "<#{token}>")
      device.token.should == token
      device.token.should_not == "<#{token}>"
    end
    
    it 'should be in the correct pattern' do
      device = DeviceFactory.new(:token => '5gxadhy6 6zmtxfl6 5zpbcxmw ez3w7ksf qscpr55t trknkzap 7yyt45sc g6jrw7qz')
      device.should be_valid
      device.token = '5gxadhy6 6zmtxfl6 5zpbcxmw ez3w7ksf qscpr55t trknkzap 7yyt45sc g6'
      device.should_not be_valid
      device.token = '5gxadhy6 6zmtxfl6 5zpbcxmw ez3w7ksf qscpr55t trknkzap 7yyt45sc g6jrw7!!'
      device.should_not be_valid
    end
    
  end
  
  describe 'to_hexa' do
    
    it 'should convert the text string to hexadecimal' do
      device = DeviceFactory.new(:token => '5gxadhy6 6zmtxfl6 5zpbcxmw ez3w7ksf qscpr55t trknkzap 7yyt45sc g6jrw7qz')
      Digest::MD5.hexdigest(device.to_hexa) == Digest::MD5.hexdigest(fixture_value('hexa.bin'))
    end
    
  end
  
  describe 'before_create' do
    
    it 'should set the last_registered_at date to Time.now' do
      time = Time.now
      Time.stub(:now).and_return(time)
      device = DeviceFactory.create
      device.last_registered_at.should_not be_nil
      device.last_registered_at.to_s.should == time.to_s
      
      # ago = 1.week.ago
      # device = DeviceFactory.create(:last_registered_at => ago)
      # device.last_registered_at.should_not be_nil
      # device.last_registered_at.to_s.should == ago.to_s
    end
    
  end
  
end