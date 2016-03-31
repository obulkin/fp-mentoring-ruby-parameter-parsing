require_relative "../lib/parser"
require "uri"

RSpec.describe Parser do
  describe ".decode" do
    it "parses a flat param" do
      expect(Parser.decode("name=foo")).to match({ name: "foo" })
    end

    it "parses a compound param" do
      expect(Parser.decode("name=sally&job=developer")).to match({
        name: "sally",
        job: "developer",
      })
    end

    context "an array" do
      it "will parse correctly" do
        expect(Parser.decode("pets=cats,dogs")).to match({
          pets: %w{cats dogs}
        })
      end
    end

    context "nested param" do
      it "will parse correctly" do
        expect(Parser.decode("user[name]=mike")).to match({
          user: {
            name: "mike"
          }
        })
      end

      it "with multiple attributes will parse correctly" do
        expect(Parser.decode("user[name]=mike&user[pets]=cats,dogs")).to match({
          user: {
            name: "mike",
            pets: %w{cats dogs}
          }
        })
      end

      it "with multiple hashes will parse correctly" do
        message = URI::encode("Hello world!")
        expect(Parser.decode("user[name]=mike&user[pets]=cats,dogs&message[body]=#{message}")).to match({
          user: {
            name: "mike",
            pets: %w{cats dogs}
          },
          message: {
            body: "Hello world!"
          }
        })
      end

      xit "with a 3 level hash will parse correctly" do
        message = URI::encode("Hello world!")
        expect(Parser.decode("user[name]=mike&user[pets][name]=fido&message[body]=#{message}")).to match({
          user: {
            name: "mike",
            pets: {
              name: "fido"
            }
          },
          message: {
            body: "Hello world!"
          }
        })
      end
    end
  end

  describe ".encode" do
    xit "will turn a shallow hash into a rest string" do
      info = { name: "foo" }

      expect(Parser.encode(info)).to eq("name=foo")
    end

    xit "will turn a nested hash into a rest string" do
      info = { user: { name: "brian" } }

      expect(Parser.encode(info)).to eq("user[name]=brian")
    end

    xit "will turn a complicated nested hash into a rest string" do
      info = { user: { name: "brian", job: "boss" }, type: "complicated" }

      expect(Parser.encode(info)).to eq("user[name]=brian&user[job]=boss&type=complicated")
    end
  end
end
