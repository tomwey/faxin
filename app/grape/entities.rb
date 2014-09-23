module Faxin
  module APIEntities
    class LawType < Grape::Entity
      expose :id, :name, :laws_count
    end
    
    class LawyerDetail < Grape::Entity
      expose :real_name, :mobile, :city, :lawyer_card, :law_firm, :intro
    end
    
    class UserDetail < Grape::Entity
      expose :nickname do |model, opts|
        if model.profile_type == 'Lawyer'
          model.profile.try(:real_name)
        elsif model.nickname.blank?
          model.email.split('@')[0]
        else
          model.nickname
        end
      end
      expose :email
      expose :avatar_url do |model, opts|
        model.avatar.url(:normal)
      end
      # expose :profile, if: lambda { |model, opts| model.profile_type == 'Lawyer' } do |model, opts|
      #   expose :state
      #   expose :real_name
      #   expose :city
      #   expose :lawyer_firm
      #   expose :mobile
      #   expose :lawyer_card
      #   expose :intro
      # end
    end
  
    class LawDetail < Grape::Entity
      expose :law_content_id, { :as => 'id' }
      expose :title, :pub_date
      expose :law_type_name, { :as => 'type_name' }
    end
    
    class ExtLawDetail < Grape::Entity
      expose :content, :law_id, :law_type
    end
    
    class FavoriteLawDetail < Grape::Entity
      expose :law_content_id, { :as => 'id' }
      expose :title, :pub_date
      expose :law_type_name, { :as => 'type_name' }
    end
  
    class LawContentDetail < Grape::Entity
      expose :content
    end
  
    class CaseDetail < Grape::Entity
      expose :case_content_id, { :as => 'id' }
      expose :title
      # expose :created_at, { :as => 'pub_date' }
      expose :pub_date do |model, opts|
        model.created_at.strftime('%Y-%m-%d')
      end
      expose :law_type_name, { :as => 'type_name' }
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