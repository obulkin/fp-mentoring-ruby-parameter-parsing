class Parser
  def self.decode(request)
    request.split("&").reduce({}) do |result, partial_request|
      param, value = partial_request.split("=")
      value = URI.decode(value)
      value = value.split(",") if value.include?(",")
      if param.include?("[")
        param1, param2 = param.split /\[|\]/
        if result[param1.to_sym]
          result[param1.to_sym].merge! param2.to_sym => value
          result
        else
          result.merge! param1.to_sym => {param2.to_sym => value}
        end
      else
        result.merge! param.to_sym => value
      end
    end
  end
end