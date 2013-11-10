module LawTypesHelper
  def link_to_if(law_type)
    if law_type.id == 3
      law_type.name
    else
      link_to law_type.name, law_type
    end
  end
end
