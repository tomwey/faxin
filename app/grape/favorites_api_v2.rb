# coding: utf-8
require 'entities'
require 'helpers'
require 'json'

module Faxin
  class FavoritesAPIV2 < Grape::API
        
    resource :user do 
      
      ####################### 文件夹操作 #######################
      # 获取所有的文件夹
      params do
        requires :token, type: String, desc: "用户认证token"
        optional :version, type: Integer, desc: "版本号"
      end
      
      get '/all_folders' do
        # 1,认证是否登录
        user = authenticate!
        
        version = params[:version].to_i
        
        #folders = user.folders.where('version > ?', version)
        folders = Folder.includes(:user).where('user_id = ? and version > ? and visible = ?', user.id, version, true).order('created_at DESC')
        
        { code: 0, message: 'ok', data: folders }
      end # end 
      
      # 同步文件夹操作
      params do
        requires :token, type: String, desc: "用户认证"
        requires :data, type: Array, desc: "文件夹数组"
        # requires :om, type: String, desc: "操作方式"
        # optional :name, type: String, desc: "文件夹名字"
        # optional :id, type: String, desc: "文件夹ID"
      end
      
      post '/folders' do
        # 1,认证是否登录
        user = authenticate!
        
        array = JSON.parse(params[:data].first)
        count = 0
        errors = []
        temp = []
        array.each do |item|
          om = item['state']
          client_id = item["client_folder_id"].to_i
          if om == 'A'
            # 新建
            folder = Folder.new
            folder.name = item["name"]
            folder.user_id = user.id
            folder.state = om
            if folder.save
              new_folder = Folder.find(folder.id)
              new_folder.client_id = client_id
              temp << new_folder
            else
              count += 1
            end
          elsif om == 'M'
            # 更新
            folder = user.folders.where(:id => item['id']).first
            
            if folder
              folder.name = item["name"]
              folder.state = "M"
              if folder.save
                folder.client_id = client_id
                temp << folder
              else
                count += 1
              end
            end
            
          elsif om == 'D'
            # 删除
            folder = user.folders.where(:id => item['id']).first
            
            if folder
              folder.visible = false
              folder.state = "D"
              if folder.save
                folder.client_id = client_id
                temp << folder
              else
                count += 1
              end
            end
            
          end
        end
        
        if count > 0
          { code: 20001, message: '同步失败' }
        else
          { code: 0, message: 'ok', data: temp }
        end
        
        # om = params[:om]
        # 
        # unless %w(A M D).include?(om)
        #   return { code: 10001, message: '错误的同步操作' }
        # end
        # 
        # if om == 'A'
        #   if params[:name].blank?
        #     return { code: 10002, message: '必须传入文件夹名称' }
        #   else
        #     # 创建文件夹
        #     if user.folders.where({:name => params[:name], :visible => true}).count > 0
        #       return { code: 10005, message: '文件夹名已经使用' }
        #     else
        #       folder = user.folders.create!(name: params[:name], state: 'A')
        #     end
        #   end
        # else
        #   if params[:id].to_i == 0
        #     return { code: 10003, message: '不正确的文件夹ID' }
        #   else
        #     folder = user.folders.where({:id => params[:id].to_i, :visible => true}).limit(1).first
        #     if folder.blank?
        #       return { code: 10004, message: '该文件夹已被删除' }
        #     end
        #     if om == 'M' # 修改
        #       if user.folders.where({:name => params[:name], :visible => true}).count > 0
        #         return { code: 10005, message: '文件夹名已经使用' }
        #       else
        #         folder.name = params[:name]
        #         folder.state = 'M'
        #         folder.save
        #       end
        #     elsif om == 'D' # 删除
        #       folder.state = 'D'
        #       folder.visible = false
        #       folder.save
        #     end
        #   end
        # end
        # 
        # folder = Folder.find(folder.id)
        # 
        # { code: 0, message: 'ok', data: folder }
      end
      
      ####################### 收藏操作 ##########################
      
      params do
        requires :token, type: String, desc: "用户认证token"
        # requires :folder_id, type: Integer, desc: "文件夹ID"
        requires :version, type: Integer, desc: "版本号"
      end
      
      get '/all_favorites' do
        # 1,认证是否登录
        user = authenticate!
        
        favorites = user.favorites.includes(:law_type).where("version > ? and visible = ?", params[:version].to_i, true).order('created_at DESC')        
        { code: 0, message: 'ok', data: favorites }
        
      end
      
      params do
        requires :token, type: String, desc: "用户认证token"
        requires :data, type: Array, desc: "真正收藏的内容"
      end
      
      post '/favorites' do
        array = JSON.parse(params[:data].first)
        count = 0
        errors = []
        temp = []
        array.each do |item|
          om = item['state']
          client_id = item["client_id"].to_i
          client_folder_id = item["client_folder_id"].to_i
          if om == 'A'
            # 新建
            fav = Favorite.new(item.merge({ user_id: user.id}))
            if fav.save
              new_fav = Favorite.find(fav.id)
              new_fav.client_id = client_id
              new_fav.client_folder_id = client_folder_id
              temp << new_fav
            else
              
              # 保存出错
              count += 1
              #errors << '(A)' + LawType.find_by_id(item['law_type_id']).try(:name) + '/' + item['law_article_id'].to_s + '/' + item['content']
            end
          elsif om == 'M'
            # 更新
            favorite = user.favorites.where({:id => item['id'], :folder_id => item[:folder_id]}).first
            if ( favorite && favorite.update_attributes(item.delete(:id)) )
              favorite.client_id = client_id
              favorite.client_folder_id = client_folder_id
              temp << favorite
            else
              # 更新出错
              count += 1
            end
            
            # if favorite.blank?
            #   errors << '(M)' + '收藏所对应的ID不存在'
            # elsif not favorite.update_attributes(item.delete(:id))
            #   errors << '(M)' + item['id'].to_s + '/' + '收藏失败'
            # end
            
          elsif om == 'D'
            # 删除
            favorite = user.favorites.where({:id => item['id'], :folder_id => item[:folder_id]}).first
            if (favorite && favorite.update_attribute(:visible, false))
              favorite.client_id = client_id
              favorite.client_folder_id = client_folder_id
              temp << favorite
            else
              
              # 删除失败
              count += 1
            end
            
            # if favorite.blank?
            #   errors << '(D)' + '收藏所对应的ID不存在'
            # elsif not favorite.update_attribute(:visible, false)
            #   errors << '(D)' + item['id'].to_s + '/' + '删除收藏失败'
            # end
            
          end
        end
        
        if count > 0
          { code: 20001, message: '同步失败' }
        else
          { code: 0, message: 'ok', data: temp }
        end
        
      end
      
    end
    
  end
end