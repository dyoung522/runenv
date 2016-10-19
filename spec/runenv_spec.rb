require "spec_helper"

describe RunEnv do
  it "has a version number" do
    expect(RunEnv::VERSION).not_to be nil
  end

  it "has a program name" do
    expect(RunEnv::PROGRAM).not_to be nil
  end

  describe OptParse do
    it "responds to --version" do
      expect(RunEnv::OptParse.parse(%w(--version), true).version).to eq(RunEnv::OptParse.version)
    end

    it "responds to --help" do
      expect(RunEnv::OptParse.parse(%w(--help), true).help).to be true
    end
  end
end
