# coding: utf-8
require 'entities'
require 'helpers'
require 'json'

module Faxin
  class FavoritesAPI < Grape::API
    
    resource :user do 
      
      params do
        requires :token, type: String, desc: "用户认证token"
      end
      
      get '/total_favorites' do
        # 1,认证是否登录
        user = authenticate!
        # 2,分组查询收藏的记录
        favorites = user.favorites.includes(:law_type).select('law_type_id, count(*) as total').where(:visible => true).group(:law_type_id)
        hash = []
        favorites.each do |f|
          type = f.law_type
          hash << { id: type.try(:id), name: type.try(:name), count: f.total }
        end
        
        { code: 0, message: 'ok', data: hash }
        
      end
      
      params do
        requires :token, type: String, desc: "用户认证token"
        requires :type_id, type: Integer, desc: "所属类别的ID"
      end
      
      get '/favorites' do
        # 1,认证是否登录
        user = authenticate!
        
        favorites = Favorite.where('user_id = ? and law_type_id = ? and visible = ?', user.id, params[:type_id].to_i, true).order('favorited_at DESC')
        
        { code: 0, message: 'ok', data: favorites }
        
      end
      
      params do
        requires :token, type: String, desc: "用户认证token"
        requires :data, type: Array, desc: "真正收藏的内容"
      end
      post '/favorite' do
        user = authenticate!
        array = JSON.parse(params[:data].first)
        count = 0
        errors = []
        array.each do |item|
          om = item['operation_method']
          if om == 'A'
            # 新建
            fav = Favorite.new(item.merge({ user_id: user.id}))
            unless fav.save
              # 保存出错
              count += 1
              errors << '(A)' + LawType.find_by_id(item['law_type_id']).try(:name) + '/' + item['law_article_id'].to_s + '/' + item['content']
            end
          elsif om == 'M'
            # 更新
            favorite = user.favorites.where(:id => item['id']).first
            unless ( favorite && favorite.update_attributes(item.delete(:id)) )
              # 更新出错
              count += 1
            end
            
            if favorite.blank?
              errors << '(M)' + '收藏所对应的ID不存在'
            elsif not favorite.update_attributes(item.delete(:id))
              errors << '(M)' + item['id'].to_s + '/' + '收藏失败'
            end
            
          elsif om == 'D'
            # 删除
            favorite = user.favorites.where( :id => item['id']).first
            unless (favorite && favorite.update_attribute(:visible, false))
              # 删除失败
              count += 1
            end
            
            if favorite.blank?
              errors << '(D)' + '收藏所对应的ID不存在'
            elsif not favorite.update_attribute(:visible, false)
              errors << '(D)' + item['id'].to_s + '/' + '删除收藏失败'
            end
            
          end
        end
        
        if count > 0
          { code: 5001, message: '同步失败, error:' + errors.join(', ') }
        else
          { code: 0, message: 'ok' }
        end

      end
      
    end
    
  end
end