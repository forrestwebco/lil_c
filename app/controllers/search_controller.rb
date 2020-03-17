class SearchController < ApplicationController
  before_action :get_results, only: [:dropdown_index, :index]
  before_action :secure_search

  def toggle_dropdown
    @tags = Tag.trending
  end

  def dropdown_index
    @dropdown = true
  end

  def index
    @search_index = true
    @results_shown = true
  end

  private

  def search
    # intializes results list
    @results = [];
    # to display different result types found for each query
    @result_types = { group: 0, user: 0, post: 0, proposal: 0, comment: 0 , shared_item: 0, survey: 0 }
    # loops through each model and through each item in each model
    [Group, User, Post, Proposal, Comment, SharedItem, Survey].each do |_class|
      # accounts for difference in groups for anrcho
      all_items = if anrcho? and _class.eql? Group
        Group.anrcho
      elsif _class.eql? Group
        Group.global
      else
        _class.all
      end
      all_items.reverse.each do |item|
        match = false; match_by_tag = false
        # scans all text for query
        match = true if scan_text item, @query
        # scans all items for matching tags
        if item.respond_to? :tags
          item.tags.each do |tag|
            if @query.eql? tag.tag or "##{@query}".eql? tag.tag
              match_by_tag = true
              match = true
            end
          end
        end
        # scans comments of current item
        if item.respond_to? :comments and not _class.eql? User
          item.comments.each do |comment|
            match = true if scan_text comment, @query
            break if match
          end
        end
        # scans comments of current item
        if item.respond_to? :questions
          item.questions.each do |question|
            match = true if scan_text question, @query
            break if match
          end
        end
        # a case for keywords used
        case @query
        when "posts", "Posts"
          match = true if _class.eql? Post and not item.group
        when "proposals", "Proposals", "motions", "Motions", "motion", "proposal", "Proposal", "Motion"
          match = true if _class.eql? Proposal and not item.group
        when "groups", "Groups"
          match = true if _class.eql? Group
        when "users", "Users"
          match = true if _class.eql? User
        when "groups and users", "users and groups"
          match = true if [Group, User].include? _class
        when "survey", "surveys", "Survey", "Surveys"
          match = true if _class.eql? Survey
        when "lending", "lending library", "shared item", "shared items", "Shared item", "Shared items", "Lending library"
          match = true if _class.eql? SharedItem
        end
        # cleans out any blog posts from search results
        match = false if item.is_a? Post and item.blog
        if match
          @results << item
          @result_types[item.model_name.singular_route_key.to_sym] +=1
          @group_found_by_tag = if item.is_a?(Group) and match_by_tag then true end
        end
      end
    end
    # remove duplicates
    @results.uniq!
    # removes any types not found at all, for display to view with/without commas
    @result_types.each { |key, val| @result_types.delete(key) if val.zero?  }
  end

  # scans specific peices of text for match
  def scan_text item, query, match=false
    match = true if scan_item_fields item, query, match
    # show all content of a group/user when searched by group/user name
    [:user, :group].each do |sym|
      if item.respond_to? sym and item.send(sym)
        match = true if scan_item_fields item, query
      end
    end
    return match
  end

  def scan_item_fields item, query, match=false
    [:body, :name, :anon_token, :unique_token, :action, :item_type, :size, :aka, :contact, :region, :arrangement, :item_category_id].each do |sym|
      if item.respond_to? sym and item.send(sym).present?
        if sym.eql? :item_category_id and item.category.present?
          # accounts for shared items category (domain), finds category and scans its name
          match = true if sym.eql? :item_category_id and item.category.present? and scan item.category, query
        else
          match = true if scan item.send(sym), query
        end
      end
    end
    return match
  end

  # scans text word by word for match
  def scan text, query, match=false
    for word in text.split(" ")
      for key_word in query.split(" ")
        if key_word.size > 2
          if word.eql? key_word or word.eql? key_word.downcase or word.eql? key_word.capitalize \
            or word.include? key_word.downcase or word.include? key_word.capitalize
            match = true
          end
        end
      end
    end
    return match
  end

  def get_results
    @query = params[:query].present? ? params[:query] : session[:query]
    session[:query] = @query
    search if @query.present?
  end

  def secure_search
    unless invited? or anrcho? or raleigh_dsa?
      redirect_to invite_only_path
    end
  end
end
