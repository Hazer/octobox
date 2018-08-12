# hack to add support for dash and forward slashes to Searrrch
Searrrch::OPERATOR_EXPRESSION = /(\w+):[\ 　]?([\w\p{Han}\p{Katakana}\p{Hiragana}\p{Hangul}ー\.\-,\/]+|(["'])(\\?.)*?\3)/

class Search
  attr_accessor :query
  attr_accessor :scope

  def initialize(query: '', scope:)
    @query = Searrrch.new(query, explode_comma: true)
    @scope = scope
  end

  def results
    res = scope
    res = scope.search_by_subject_title(query.freetext) if query.freetext.present?
    res = res.repo(repo) if repo.present?
    res = res.owner(owner) if owner.present?
    res = res.type(type) if type.present?
    res = res.reason(reason) if reason.present?
    res = res.label(label) if label.present?
    res = res.state(state) if state.present?
    res = res.starred(starred) unless starred.nil?
    res = res.archived(archived) unless archived.nil?
    res = res.unread(unread) unless unread.nil?
    res
  end

  private

  def repo
    query.to_array(:repo).first
  end

  def owner
    query.to_array(:owner).first
  end

  def author
    query.to_array(:author).first
  end

  def unread
    return nil unless query.to_array(:unread).present?
    query.to_array(:unread).first.downcase == "true"
  end

  def type
    query.to_array(:type).map(&:classify)
  end

  def reason
    query.to_array(:reason).map{|r| r.downcase.gsub(' ', '_') }
  end

  def state
    query.to_array(:state).map(&:downcase)
  end

  def label
    query.to_array(:label).first
  end

  def starred
    return nil unless query.to_array(:starred).present?
    query.to_array(:starred).first.try(:downcase) == "true"
  end

  def archived
    return nil unless query.to_array(:archived).present?
    query.to_array(:archived).first.downcase == "true"
  end
end
