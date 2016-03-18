class Parser
  def self.decode(request)
    request.split("&").reduce({}) do |result, request|
      splitter = request.index("=")
      param, value = request.split("=")
      value = value.split(",") if array_splitter = value.index(",")
      if nesting_start = param.index("[")
        outer_param, inner_param = param.split(/\[|\]/)
        result[]
        result.merge(outer_param.to_sym => {inner_param.to_sym => value})
      else
        result.merge(param.to_sym => value)
      end
    end
  end
end