# repository for brochures
class BrochureRepository
  def delete_all
    Brochure.delete_all
  end

  # update body of single brochure by type
  def update_by_type(type, body)
    brochure = by_type(type)
    brochure.body = body
    brochure.save
    brochure
  end

  # get single brochure by type
  def by_type(type)
    type = type.to_s
    brochure = Brochure.where(type: type).first
    return brochure if brochure
    Brochure.new do |b|
      b.type = type
    end
  end

  def all
    Brochure.all
  end
end
