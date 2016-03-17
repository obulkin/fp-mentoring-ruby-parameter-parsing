require_relative "../lib/parser"

RSpec.describe Parser do
  describe ".run" do
    it "parses a flat param" do
      expect(Parser.run("name=foo")).to match({ name: "foo" })
    end

    context "an array" do
      xit "will parse correctly" do
        expect(Parser.run("pets=cats,dogs")).to match({
          pets: %w{cats dogs}
        })
      end
    end

    context "nested param" do
      xit "will parse correctly" do
        expect(Parser.run("user[name]=mike")).to match({
          user: {
            name: "mike"
          }
        })
      end

      xit "with multiple attributes will parse correctly" do
        expect(Parser.run("user[name]=mike&user[pets]=cats,dogs")).to match({
          user: {
            name: "mike",
            pets: %w{cats dogs}
          }
        })
      end

      xit "with multiple hashes will parse correctly" do
        message = URI::encode("Hello world!")
        expect(Parser.run("user[name]=mike&user[pets]=cats,dogs&message[body]=#{message}")).to match({
          user: {
            name: "mike",
            pets: %w{cats dogs}
          },
          message: {
            body: "Hello world!"
          }
        })
      end
    end
  end
end
