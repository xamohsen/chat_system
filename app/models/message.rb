require 'elasticsearch/model'

class Message < ApplicationRecord

  belongs_to :chat, :class_name => "Chat", :primary_key => "chat_number", :foreign_key => "chat_number"
  validates_presence_of :message_number, :text, :chat_number, :app_token

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  def self.search_chat(query)
    self.search({
                    query: {
                        bool: {
                            must: [
                                {
                                    multi_match: {
                                        query: query[:text],
                                    }
                                },
                                {
                                    match: {app_token: query[:app_token]}
                                },
                                {
                                    match: {chat_number: query[:chat_number]}
                                }
                            ]
                        }
                    }
                })
  end
end

Message.__elasticsearch__.create_index!

Message.import(force: true)
