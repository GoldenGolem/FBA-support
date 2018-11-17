module AddSkipParamsParsingOption
  def self.prepended(mod)
    mod.class_eval do
      cattr_accessor :skipped_paths do
        []
      end
    end
  end

  private

  def parse_formatted_parameters(env)
    request = ActionDispatch::Request.new(env)
    if skipped_paths.include?(request.path)
      ::Rails.logger.info "Skipping params parsing for path #{ request.path }"
      nil
    else
      super(env)
    end
  end
end
ActionDispatch::ParamsParser.send :prepend, AddSkipParamsParsingOption