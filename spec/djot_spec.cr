require "./spec_helper"

describe Djot::SiHmac do
  it "Djot::SiHmac signs data with default HS256 encryption" do
    Djot::SiHmac.new("foo bar").of("nice".to_slice).hexstring.should eq "91f389947e52eb008dbc46b365e8899cfbf58d1403ff570639baa7f41b48a94a"
  end

  it "Djot::SiHmac signs data with HS384 encryption" do
    Djot::SiHmac.new("foo bar", 384).of("nice".to_slice).hexstring.should eq "49a399aff64ba3cbb115198a94b42b172bfcd435bb7c8914c34b9ac733afeecf70d83d9155a9a736ec11af416ed39ee9"
  end

  it "Djot::SiHmac signs data with HS512 encryption" do
    Djot::SiHmac.new("foo bar", 512).of("nice".to_slice).hexstring.should eq "948593ec4a85edb4160b9c54e14d36bf2a6441e07390fffa97c5f30db79df2b28da028a6d5678aba57ac176fd362003cb511bdbdcf48cb358aac40ecca3ae215"
  end

  it "Djot::SiHmac displays its name correctly" do
    [256, 384, 512].map do |bits|
      Djot::SiHmac.new("foo bar", bits).name.should eq "HS#{bits}"  
    end
  end
end

describe Djot::EnvelopeSimple do 
  it "Djot::EnvelopeSimple signs itself properly" do
    signature = Djot::SiHmac.new("secret", 256)
    jwt: String = Djot::EnvelopeSimple.new(signature).wrap(
      {"foo": 1234, "bar": "baz"}
    )
    jwt.split("\.")[2].should eq "bce7ce101c8d5e684b1489c84512402fb289371beb7fc7147048606137be6c00"
  end


  it "Djot::EnvelopeSimple produces correct output" do
    signature = Djot::SiHmac.new("secret", 384)
  
    Djot::EnvelopeSimple.new(Djot::SiHmac.new("secret", 384)).wrap(
      {"foo": 1234, "bar": "baz"}
    ).should eq  "eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9" \
    ".eyJmb28iOjEyMzQsImJhciI6ImJheiJ9" \
    ".721da194d085890594f07aaebee619747e2de8c5edf3c653e2584acd1823a3cd257071a1da1e672dc9dcf2c64ad1bbc6"
  end
end


describe Djot::TokenSimple do
  it "Djot::TokenSimple checks signature" do
    signature = Djot::SiHmac.new("secret", 384)
    token = "eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9" \
    ".eyJmb28iOjEyMzQsImJhciI6ImJheiJ9" \
    ".721da194d085890594f07aaebee619747e2de8c5edf3c653e2584acd1823a3cd257071a1da1e672dc9dcf2c64ad1bbc6"
    Djot::TokenSimple.new(token, signature).signature_matches?.should eq true
  end
end