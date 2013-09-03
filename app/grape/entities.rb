module Faxin
  module APIEntities
    class LawType < Grape::Entity
      expose :id, :name, :laws_count
    end
  
    class LawDetail < Grape::Entity
      expose :law_content_id, { :as => 'id' }
      expose :title, :pub_date
      expose :law_type_name, { :as => 'type_name' }
    end
    
    class FavoriteLawDetail < Grape::Entity
      expose :law_content_id, { :as => 'id' }
      expose :title, :pub_date
      expose :law_type_name, { :as => 'type_name' }
    end
  
    class LawConentDetail < Grape::Entity
      expose :content
    end
  
    class CaseDetail < Grape::Entity
      expose :case_content_id, { :as => 'id' }
      expose :title
      # expose :created_at, { :as => 'pub_date' }
      expose :pub_date do |model, opts|
        model.created_at.strftime('%Y-%m-%d')
      end
    end
    
    class FavoriteCaseDetail < Grape::Entity
      expose :case_content_id, { :as => 'id' }
      expose :title
      expose :created_at, { :as => 'pub_date' }
      expose :law_type_name, { :as => 'type_name' }
    end
  
    class AnyouDetail < Grape::Entity
      expose :id, :name, :cases_count
    end
    
    class SearchHistoryDetail < Grape::Entity
      expose :keyword
      expose :search_count, { :as => 'count' }
    end
  
  end
end