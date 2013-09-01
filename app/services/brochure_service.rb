class BrochureService
  def initialize(brochure_repository)
    @brochure_repository = brochure_repository
  end

  def get_help
    brochure_repository.by_type(:help)
  end

  def update_help(body)
    brochure_repository.update_by_type(:help, body)
  end

  def get_suicidal_thoughts
    brochure_repository.by_type(:suicidal_thoughts)
  end

  def update_suicidal_thoughts(body)
    brochure_repository.update_by_type(:suicidal_thoughts, body)
  end

  def get_advice_for_relatives
    brochure_repository.by_type(:advice_for_relatives)
  end

  def update_advice_for_relatives(body)
    brochure_repository.update_by_type(:advice_for_relatives, body)
  end

  private
    attr_reader :brochure_repository
end
